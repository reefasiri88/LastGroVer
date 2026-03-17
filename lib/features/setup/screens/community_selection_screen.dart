import 'package:flutter/material.dart';
import '../../profile/logic/profile_store.dart';
import '../logic/setup_store.dart';
import '../widgets/setup_header.dart';
import '../widgets/setup_button.dart';
import '../widgets/setup_background.dart';
import '../widgets/setup_option_card.dart';

class CommunitySelectionScreen extends StatefulWidget {
  const CommunitySelectionScreen({super.key});

  @override
  State<CommunitySelectionScreen> createState() =>
      _CommunitySelectionScreenState();
}

class _CommunitySelectionScreenState extends State<CommunitySelectionScreen> {
  String? _selectedCommunity;
  bool _isLoading = false;

  final List<String> _communities = [
    'Sedra',
    'Warefa',
    'Alarous',
    'Almanar',
    'Aldanah',
  ];

  void _handleContinue() {
    if (_selectedCommunity == null) return;

    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 1), () async {
      if (!mounted) return;

      SetupStore.instance.setCommunity(_selectedCommunity!);

      await ProfileStore.instance.saveProfilePatch(
        community: _selectedCommunity,
      );

      setState(() => _isLoading = false);
      Navigator.pushNamed(context, '/setup-complete');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SetupBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SetupHeader(
                title: "Which ROSHN Community\nDo You Call Home?",
              ),
              const SizedBox(height: 40),
              ...List.generate(_communities.length, (index) {
                final community = _communities[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index < _communities.length - 1 ? 16 : 0,
                  ),
                  child: SetupOptionCard(
                    label: community,
                    isSelected: _selectedCommunity == community,
                    backgroundColor: const Color(0xFFA56EFF).withValues(alpha: 0.31),
                    onTap: () =>
                        setState(() => _selectedCommunity = community),
                  ),
                );
              }),
              const SizedBox(height: 40),
              SetupButton(
                label: 'Continue',
                onPressed: _handleContinue,
                isLoading: _isLoading,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}