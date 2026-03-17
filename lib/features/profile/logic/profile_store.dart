import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/supabase/supabase_client.dart';

class UserProfileData {
  const UserProfileData({
    required this.name,
    required this.email,
    required this.mobile,
    required this.imageUrl,
    required this.gender,
    required this.age,
    required this.heightCm,
    required this.weightKg,
    required this.community,
  });

  const UserProfileData.empty()
      : name = '',
        email = '',
        mobile = '',
        imageUrl = '',
        gender = '',
        age = null,
        heightCm = null,
        weightKg = null,
        community = '';

  final String name;
  final String email;
  final String mobile;
  final String imageUrl;
  final String gender;
  final int? age;
  final double? heightCm;
  final double? weightKg;
  final String community;

  String get displayName {
    if (name.trim().isNotEmpty) {
      return name.trim();
    }
    if (email.trim().isNotEmpty) {
      final localPart = email.split('@').first.trim();
      if (localPart.isNotEmpty) {
        return localPart
            .split(RegExp(r'[._-]+'))
            .where((part) => part.isNotEmpty)
            .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
            .join(' ');
      }
    }
    return 'Gromotion User';
  }

  String get initials {
    final parts = displayName
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) {
      return 'G';
    }
    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  String get handle {
    final source = name.trim().isNotEmpty ? name : email.split('@').first;
    final normalized = source
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '.')
        .replaceAll(RegExp(r'^\.|\.$'), '');
    return '@${normalized.isEmpty ? 'gromotion.user' : normalized}';
  }

  UserProfileData copyWith({
    String? name,
    String? email,
    String? mobile,
    String? imageUrl,
    String? gender,
    int? age,
    double? heightCm,
    double? weightKg,
    String? community,
  }) {
    return UserProfileData(
      name: name ?? this.name,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      imageUrl: imageUrl ?? this.imageUrl,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      community: community ?? this.community,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'mobile': mobile,
      'imageUrl': imageUrl,
      'gender': gender,
      'age': age,
      'heightCm': heightCm,
      'weightKg': weightKg,
      'community': community,
    };
  }

  factory UserProfileData.fromJson(Map<String, dynamic> json) {
    return UserProfileData(
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      mobile: json['mobile'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      age: (json['age'] as num?)?.toInt(),
      heightCm: (json['heightCm'] as num?)?.toDouble(),
      weightKg: (json['weightKg'] as num?)?.toDouble(),
      community: json['community'] as String? ?? '',
    );
  }
}

class ProfileStore {
  ProfileStore._();

  static final ProfileStore instance = ProfileStore._();

  static const _loggedInKey = 'profile_store.logged_in';

  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  Future<UserProfileData> loadProfile() async {
    final prefs = await _prefs;
    final rawProfile = prefs.getString(_profileKeyForCurrentUser());
    if (rawProfile == null || rawProfile.isEmpty) {
      return const UserProfileData.empty();
    }

    try {
      return UserProfileData.fromJson(
        jsonDecode(rawProfile) as Map<String, dynamic>,
      );
    } catch (error) {
      debugPrint('Failed to load user profile: $error');
      return const UserProfileData.empty();
    }
  }

  Future<void> saveProfile(UserProfileData profile) async {
    final prefs = await _prefs;
    await prefs.setString(_profileKeyForCurrentUser(), jsonEncode(profile.toJson()));
  }

  Future<void> saveProfilePatch({
    String? name,
    String? email,
    String? mobile,
    String? imageUrl,
    String? gender,
    int? age,
    double? heightCm,
    double? weightKg,
    String? community,
  }) async {
    final current = await loadProfile();
    await saveProfile(
      current.copyWith(
        name: _normalizeString(name) ?? current.name,
        email: _normalizeString(email) ?? current.email,
        mobile: _normalizeString(mobile) ?? current.mobile,
        imageUrl: _normalizeString(imageUrl) ?? current.imageUrl,
        gender: _normalizeString(gender) ?? current.gender,
        age: age ?? current.age,
        heightCm: heightCm ?? current.heightCm,
        weightKg: weightKg ?? current.weightKg,
        community: _normalizeString(community) ?? current.community,
      ),
    );
  }

  Future<bool> isLoggedIn() async {
    final prefs = await _prefs;
    return prefs.getBool(_loggedInKey) ?? false;
  }

  Future<void> setLoggedIn(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(_loggedInKey, value);
  }

  String _profileKeyForCurrentUser() {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null || userId.isEmpty) {
      return 'profile_store.user_profile.pending';
    }
    return 'profile_store.user_profile.$userId';
  }

  String? _normalizeString(String? value) {
    if (value == null) {
      return null;
    }
    return value.trim();
  }
}