import 'package:flutter/material.dart';

import '../../../app/router/route_names.dart';
import '../../auth/data/auth_service.dart';
import '../../auth/data/session_service.dart';
import '../../events/widgets/decorative_background.dart';
import '../../events/widgets/frosted_glass_button.dart';
import '../../events/widgets/gradient_button.dart';
import '../data/profile_service.dart';
import '../logic/profile_store.dart';
import '../ui/profile_widgets.dart';
import 'edit_profile_screen.dart';
import 'personal_information_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authService = AuthService();
  final _sessionService = SessionService();
  final _profileService = ProfileService();
  UserProfileData _profile = const UserProfileData.empty();
  UserProfileStatsData _stats = const UserProfileStatsData.empty();
  var _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await _profileService.loadCurrentUserProfileData();
    final stats = await _profileService.loadCurrentUserStatsData();
    if (!mounted) {
      return;
    }

    setState(() {
      _profile = profile;
      _stats = stats;
      _isLoading = false;
    });
  }

  Future<void> _openEditProfile() async {
    final didUpdate = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(initialProfile: _profile),
      ),
    );
    if (didUpdate == true) {
      await _loadProfile();
    }
  }

  Future<void> _openPersonalInformation() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PersonalInformationScreen(profile: _profile),
      ),
    );
  }

  Future<void> _logout() async {
    try {
      await _sessionService.endSessionIfActive();
    } catch (error) {
      debugPrint('Failed to close user session: $error');
    }

    await _authService.signOutUser();
    await ProfileStore.instance.setLoggedIn(false);
    if (!mounted) {
      return;
    }

    Navigator.pushNamedAndRemoveUntil(
      context,
      RouteNames.splash,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: DecorativeBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    SizedBox(width: 44, height: 44),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Profile',
                          style: TextStyle(
                            fontFamily: 'Alexandria',
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 44, height: 44),
                  ],
                ),
                const SizedBox(height: 28),
                if (_isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: CircularProgressIndicator(
                        color: Color(0xFFA56EFF),
                      ),
                    ),
                  )
                else ...[
                  ProfileSectionCard(
                    child: _ProfileHeaderCard(
                      profile: _profile,
                      onEditPressed: _openEditProfile,
                    ),
                  ),
                  const SizedBox(height: 18),
                  ProfileSectionCard(
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                    child: _ProfileStatsSection(stats: _stats),
                  ),
                  const SizedBox(height: 18),
                  ProfileMenuItem(
                    icon: Icons.person_outline,
                    title: 'Personal Information',
                    onTap: _openPersonalInformation,
                  ),
                  const SizedBox(height: 22),
                  FrostedGlassButton(
                    label: 'Logout',
                    onPressed: _logout,
                    height: 52,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  const _ProfileHeaderCard({
    required this.profile,
    required this.onEditPressed,
  });

  final UserProfileData profile;
  final VoidCallback onEditPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 92,
          height: 92,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFA56EFF),
                Color(0xFF4D4FD7),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7B61FF).withValues(alpha: 0.28),
                blurRadius: 22,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipOval(
            child: profile.imageUrl.isNotEmpty
                ? Image.network(
                    profile.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => _InitialAvatar(initials: profile.initials),
                  )
                : _InitialAvatar(initials: profile.initials),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          profile.displayName,
          style: const TextStyle(
            fontFamily: 'Alexandria',
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          profile.handle,
          style: TextStyle(
            fontFamily: 'Alexandria',
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Colors.white.withValues(alpha: 0.68),
          ),
        ),
        const SizedBox(height: 18),
        GradientButton(
          label: 'Edit Profile',
          onPressed: onEditPressed,
          width: 168,
          height: 48,
        ),
      ],
    );
  }
}

class _InitialAvatar extends StatelessWidget {
  const _InitialAvatar({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        initials,
        style: const TextStyle(
          fontFamily: 'Alexandria',
          fontSize: 34,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _ProfileStatsSection extends StatelessWidget {
  const _ProfileStatsSection({required this.stats});

  final UserProfileStatsData stats;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Stats',
          style: TextStyle(
            fontFamily: 'Alexandria',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: ProfileStatItem(
                value: '${stats.workouts}',
                label: 'Workouts',
              ),
            ),
            Expanded(
              child: ProfileStatItem(
                value: '${stats.challenges}',
                label: 'Challenges',
              ),
            ),
            Expanded(
              child: ProfileStatItem(
                value: _formatPoints(stats.points),
                label: 'Points',
              ),
            ),
            Expanded(
              child: ProfileStatItem(
                value: stats.rank == null ? '#-' : '#${stats.rank}',
                label: 'Rank',
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatPoints(int points) {
    if (points >= 1000) {
      final compact = points / 1000;
      return compact == compact.roundToDouble()
          ? '${compact.toStringAsFixed(0)}K'
          : '${compact.toStringAsFixed(1)}K';
    }
    return '$points';
  }
}