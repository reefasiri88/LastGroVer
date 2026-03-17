import 'package:flutter/material.dart';

import '../../events/widgets/decorative_background.dart';
import '../logic/profile_store.dart';
import '../ui/profile_widgets.dart';

class PersonalInformationScreen extends StatelessWidget {
  const PersonalInformationScreen({
    super.key,
    required this.profile,
  });

  final UserProfileData profile;

  @override
  Widget build(BuildContext context) {
    final details = [
      ('Name', profile.displayName),
      ('Email', _fallback(profile.email)),
      ('Mobile Number', _fallback(profile.mobile)),
      ('Gender', _fallback(profile.gender)),
      ('Age', profile.age?.toString() ?? 'Not set yet'),
      ('Height', profile.heightCm == null ? 'Not set yet' : '${profile.heightCm!.toStringAsFixed(0)} cm'),
      ('Weight', profile.weightKg == null ? 'Not set yet' : '${profile.weightKg!.toStringAsFixed(0)} kg'),
      ('Community', _fallback(profile.community)),
    ];

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
                          'Personal Information',
                          style: TextStyle(
                            fontFamily: 'Alexandria',
                            fontSize: 22,
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
                      for (var index = 0; index < details.length; index++) ...[
                        _PersonalInfoRow(
                          label: details[index].$1,
                          value: details[index].$2,
                        ),
                        if (index < details.length - 1)
                          Divider(
                            height: 28,
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _fallback(String value) {
    return value.trim().isEmpty ? 'Not set yet' : value.trim();
  }
}

class _PersonalInfoRow extends StatelessWidget {
  const _PersonalInfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Alexandria',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.66),
            ),
          ),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontFamily: 'Alexandria',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}