import 'package:flutter/material.dart';

import '../../events/widgets/decorative_background.dart';
import '../../events/widgets/gradient_button.dart';
import '../data/profile_service.dart';
import '../logic/profile_store.dart';
import '../ui/profile_widgets.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    super.key,
    required this.initialProfile,
  });

  final UserProfileData initialProfile;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _profileService = ProfileService();
  late final TextEditingController _nameController;
  late final TextEditingController _imageUrlController;
  late final TextEditingController _emailController;
  late final TextEditingController _mobileController;
  late final TextEditingController _genderController;
  late final TextEditingController _communityController;
  late final TextEditingController _ageController;
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;
  var _isSaving = false;

  @override
  void initState() {
    super.initState();
    final profile = widget.initialProfile;
    _nameController = TextEditingController(text: profile.name);
    _imageUrlController = TextEditingController(text: profile.imageUrl)
      ..addListener(_refreshPreview);
    _emailController = TextEditingController(text: profile.email);
    _mobileController = TextEditingController(text: profile.mobile);
    _genderController = TextEditingController(text: profile.gender);
    _communityController = TextEditingController(text: profile.community);
    _ageController = TextEditingController(text: profile.age?.toString() ?? '');
    _heightController = TextEditingController(
      text: profile.heightCm?.toStringAsFixed(0) ?? '',
    );
    _weightController = TextEditingController(
      text: profile.weightKg?.toStringAsFixed(0) ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _imageUrlController
      ..removeListener(_refreshPreview)
      ..dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _genderController.dispose();
    _communityController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _refreshPreview() {
    setState(() {});
  }

  Future<void> _save() async {
    final validationError = _validateInputs();
    if (validationError != null) {
      _showMessage(validationError);
      return;
    }

    final updatedProfile = widget.initialProfile.copyWith(
      name: _nameController.text.trim(),
      imageUrl: _imageUrlController.text.trim(),
      email: _emailController.text.trim(),
      mobile: _mobileController.text.trim(),
      gender: _genderController.text.trim(),
      community: _communityController.text.trim(),
      age: _parseOptionalInt(_ageController.text),
      heightCm: _parseOptionalDouble(_heightController.text),
      weightKg: _parseOptionalDouble(_weightController.text),
    );

    setState(() => _isSaving = true);
    try {
      await _profileService.updateCurrentUserProfileData(updatedProfile);
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop(true);
    } on ProfileUpdateException catch (error) {
      if (!mounted) {
        return;
      }
      _showMessage(error.message);
    } catch (error) {
      if (!mounted) {
        return;
      }
      _showMessage('Profile save failed. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  String? _validateInputs() {
    if (_nameController.text.trim().isEmpty) {
      return 'Name is required.';
    }
    if (_emailController.text.trim().isEmpty) {
      return 'Email is required.';
    }
    if (!_emailController.text.contains('@')) {
      return 'Enter a valid email address.';
    }
    if (_mobileController.text.trim().isEmpty) {
      return 'Mobile number is required.';
    }
    if (!_isValidOptionalInt(_ageController.text)) {
      return 'Age must be a whole number.';
    }
    if (!_isValidOptionalDouble(_heightController.text)) {
      return 'Height must be a valid number.';
    }
    if (!_isValidOptionalDouble(_weightController.text)) {
      return 'Weight must be a valid number.';
    }
    return null;
  }

  int? _parseOptionalInt(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    return int.tryParse(trimmed);
  }

  double? _parseOptionalDouble(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    return double.tryParse(trimmed);
  }

  bool _isValidOptionalInt(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty || int.tryParse(trimmed) != null;
  }

  bool _isValidOptionalDouble(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty || double.tryParse(trimmed) != null;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }

  @override
  Widget build(BuildContext context) {
    final rawName = _nameController.text.trim();
    final previewName = rawName.isEmpty
        ? widget.initialProfile.displayName
        : rawName;
    final previewInitials = previewName
        .split(RegExp(r'\s+'))
        .where((entry) => entry.isNotEmpty)
        .take(2)
        .map((entry) => entry[0].toUpperCase())
        .join();

    return Scaffold(
      backgroundColor: Colors.black,
      body: DecorativeBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                      ),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Edit Profile',
                          style: TextStyle(
                            fontFamily: 'Alexandria',
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 24),
                ProfileSectionCard(
                  child: Column(
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFA56EFF),
                              Color(0xFF4D4FD7),
                            ],
                          ),
                        ),
                        child: ClipOval(
                          child: _imageUrlController.text.trim().isNotEmpty
                              ? Image.network(
                                  _imageUrlController.text.trim(),
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => _EditAvatarFallback(
                                    initials: previewInitials.isEmpty ? 'G' : previewInitials,
                                  ),
                                )
                              : _EditAvatarFallback(
                                  initials: previewInitials.isEmpty ? 'G' : previewInitials,
                                ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      _ProfileEditField(
                        controller: _imageUrlController,
                        label: 'Profile Image URL',
                        keyboardType: TextInputType.url,
                      ),
                      const SizedBox(height: 14),
                      _ProfileEditField(
                        controller: _nameController,
                        label: 'Name',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                ProfileSectionCard(
                  child: Column(
                    children: [
                      _ProfileEditField(
                        controller: _emailController,
                        label: 'Email',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 14),
                      _ProfileEditField(
                        controller: _mobileController,
                        label: 'Mobile Number',
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 14),
                      _ProfileEditField(
                        controller: _genderController,
                        label: 'Gender',
                      ),
                      const SizedBox(height: 14),
                      _ProfileEditField(
                        controller: _communityController,
                        label: 'Community',
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _ProfileEditField(
                              controller: _ageController,
                              label: 'Age',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _ProfileEditField(
                              controller: _heightController,
                              label: 'Height (cm)',
                              keyboardType: const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _ProfileEditField(
                        controller: _weightController,
                        label: 'Weight (kg)',
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                GradientButton(
                  label: _isSaving ? 'Saving...' : 'Save Changes',
                  onPressed: _isSaving ? () {} : _save,
                  width: double.infinity,
                  height: 52,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileEditField extends StatelessWidget {
  const _ProfileEditField({
    required this.controller,
    required this.label,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(
        fontFamily: 'Alexandria',
        color: Colors.white,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontFamily: 'Alexandria',
          color: Colors.white.withValues(alpha: 0.72),
        ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.08),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          borderSide: BorderSide(color: Color(0xFFA56EFF)),
        ),
      ),
    );
  }
}

class _EditAvatarFallback extends StatelessWidget {
  const _EditAvatarFallback({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        initials,
        style: const TextStyle(
          fontFamily: 'Alexandria',
          fontSize: 30,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}