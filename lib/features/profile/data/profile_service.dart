import '../../../core/supabase/supabase_client.dart';
import '../../leaderboard/data/leaderboard_service.dart';
import '../../setup/data/setup_service.dart';
import '../logic/profile_store.dart';

class ProfileUpdateException implements Exception {
  const ProfileUpdateException({
    required this.step,
    required this.message,
  });

  final String step;
  final String message;

  @override
  String toString() => 'ProfileUpdateException(step: $step, message: $message)';
}

class UserProfileStatsData {
  const UserProfileStatsData({
    required this.workouts,
    required this.challenges,
    required this.points,
    required this.rank,
  });

  const UserProfileStatsData.empty()
      : workouts = 0,
        challenges = 0,
        points = 0,
        rank = null;

  final int workouts;
  final int challenges;
  final int points;
  final int? rank;
}

class ProfileService {
  final SetupService _setupService = SetupService();
  final LeaderboardService _leaderboardService = LeaderboardService();

  Future<void> createProfile({
    required String userId,
    required String username,
    required String email,
    required String phoneNumber,
  }) async {
    await supabase.from('profiles').insert({
      'id': userId,
      'username': username,
      'email': email,
      'phone_number': phoneNumber,
      'setup_completed': false,
    });
  }

  Future<Map<String, dynamic>?> getMyProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) return null;

    final data =
        await supabase.from('profiles').select().eq('id', user.id).maybeSingle();

    return data;
  }

  Future<UserProfileData> loadCurrentUserProfileData() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      return const UserProfileData.empty();
    }

    final localProfile = await ProfileStore.instance.loadProfile();
    final profile = await getMyProfile();
    final setup = await _setupService.getMySetup();

    final mergedProfile = UserProfileData(
      name: _readString(profile, 'username', fallback: localProfile.name),
      email: _readString(
        profile,
        'email',
        fallback: user.email ?? localProfile.email,
      ),
      mobile: _readString(profile, 'phone_number', fallback: localProfile.mobile),
      imageUrl: localProfile.imageUrl,
      gender: _readString(setup, 'gender', fallback: localProfile.gender),
      age: _readInt(setup, 'age', fallback: localProfile.age),
      heightCm: _readDouble(setup, 'height', fallback: localProfile.heightCm),
      weightKg: _readDouble(setup, 'weight', fallback: localProfile.weightKg),
      community: _readString(setup, 'community', fallback: localProfile.community),
    );

    await ProfileStore.instance.saveProfile(mergedProfile);
    return mergedProfile;
  }

  Future<void> updateCurrentUserProfileData(UserProfileData profile) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw const ProfileUpdateException(
        step: 'auth',
        message: 'No authenticated user was found. Please sign in again.',
      );
    }

    final normalizedProfile = UserProfileData(
      name: profile.name.trim(),
      email: profile.email.trim(),
      mobile: profile.mobile.trim(),
      imageUrl: profile.imageUrl.trim(),
      gender: profile.gender.trim(),
      age: profile.age,
      heightCm: profile.heightCm,
      weightKg: profile.weightKg,
      community: profile.community.trim(),
    );

    await _updateProfilesRow(user.id, normalizedProfile);
    await _upsertUserSetupRow(user.id, normalizedProfile);
    await ProfileStore.instance.saveProfile(normalizedProfile);
  }

  Future<UserProfileStatsData> loadCurrentUserStatsData() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      return const UserProfileStatsData.empty();
    }

    var workouts = 0;
    var challenges = 0;
    var points = 0;
    int? rank;

    try {
      final arSessions = await supabase
          .from('ar_sessions')
          .select('id')
          .eq('user_id', user.id);
      workouts = (arSessions as List).length;
    } catch (_) {
      workouts = 0;
    }

    try {
      final activityLogs = await supabase
          .from('user_activity_logs')
          .select('challenges_joined_count')
          .eq('user_id', user.id);
      for (final row in (activityLogs as List).cast<Map<String, dynamic>>()) {
        challenges += _readInt(row, 'challenges_joined_count', fallback: 0) ?? 0;
      }
    } catch (_) {
      challenges = 0;
    }

    try {
      final leaderboard = await _leaderboardService.fetchLeaderboard();
      final currentUserEntry = leaderboard.where((entry) => entry.userId == user.id).firstOrNull;
      points = currentUserEntry?.totalPoints ?? 0;
      rank = currentUserEntry?.rank;
    } catch (_) {
      points = 0;
      rank = null;
    }

    return UserProfileStatsData(
      workouts: workouts,
      challenges: challenges,
      points: points,
      rank: rank,
    );
  }

  Future<void> updateLastSeen() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    await supabase.from('profiles').update({
      'last_seen_at': DateTime.now().toIso8601String(),
    }).eq('id', user.id);
  }

  Future<void> markSetupCompleted() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    await supabase.from('profiles').update({
      'setup_completed': true,
      'last_seen_at': DateTime.now().toIso8601String(),
    }).eq('id', user.id);
  }

  String _readString(
    Map<String, dynamic>? data,
    String key, {
    required String fallback,
  }) {
    final value = data?[key]?.toString().trim();
    if (value == null || value.isEmpty) {
      return fallback;
    }
    return value;
  }

  int? _readInt(
    Map<String, dynamic>? data,
    String key, {
    required int? fallback,
  }) {
    final value = data?[key];
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  double? _readDouble(
    Map<String, dynamic>? data,
    String key, {
    required double? fallback,
  }) {
    final value = data?[key];
    if (value is double) {
      return value;
    }
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value?.toString() ?? '') ?? fallback;
  }

  Future<void> _updateProfilesRow(String userId, UserProfileData profile) async {
    try {
      final updatedRow = await supabase
          .from('profiles')
          .update({
            'username': profile.name,
            'email': profile.email,
            'phone_number': profile.mobile,
            'last_seen_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId)
          .select('id')
          .maybeSingle();

      if (updatedRow == null) {
        throw const ProfileUpdateException(
          step: 'profiles',
          message: 'Updating the profiles row was blocked or no profile row matched the authenticated user. Check the profiles RLS policy for id = auth.uid().',
        );
      }
    } catch (error) {
      if (error is ProfileUpdateException) {
        rethrow;
      }

      throw ProfileUpdateException(
        step: 'profiles',
        message: 'Failed to update profiles: ${error.toString()}',
      );
    }
  }

  Future<void> _upsertUserSetupRow(String userId, UserProfileData profile) async {
    try {
      final upsertedRow = await supabase
          .from('user_setup')
          .upsert({
            'user_id': userId,
            'gender': profile.gender,
            'age': profile.age,
            'weight': profile.weightKg,
            'height': profile.heightCm,
            'community': profile.community,
          }, onConflict: 'user_id')
          .select('user_id')
          .maybeSingle();

      if (upsertedRow == null) {
        throw const ProfileUpdateException(
          step: 'user_setup',
          message: 'Updating the user_setup row was blocked or no row was returned. Check the user_setup RLS policy and unique constraint on user_id.',
        );
      }
    } catch (error) {
      if (error is ProfileUpdateException) {
        rethrow;
      }

      throw ProfileUpdateException(
        step: 'user_setup',
        message: 'Failed to update user_setup: ${error.toString()}',
      );
    }
  }
}