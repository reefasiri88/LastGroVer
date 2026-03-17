import 'package:flutter/material.dart';

import '../../../core/widgets/premium_widgets.dart';
import '../../../features/ar/screens/ar_screen.dart';
import '../../../features/challenges/screens/challenges_screen.dart';
import '../../../features/leaderboard/screens/leaderboard_screen.dart';
import '../../../features/profile/screens/profile_screen.dart';
import 'home_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int currentIndex = 0;
  int previousIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomeScreen(),
      const ChallengesScreen(),
      ArScreen(
        onExit: () {
          setState(() {
            currentIndex = previousIndex == 2 ? 0 : previousIndex;
          });
        },
      ),
      const LeaderboardScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: PremiumNavigationBarFrame(
          child: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                backgroundColor: Colors.transparent,
                elevation: 0,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.white.withValues(alpha: 0.54),
                selectedLabelStyle: const TextStyle(
                  fontFamily: 'Alexandria',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
                unselectedLabelStyle: TextStyle(
                  fontFamily: 'Alexandria',
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                  color: Colors.white.withValues(alpha: 0.54),
                ),
              ),
            ),
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              type: BottomNavigationBarType.fixed,
              onTap: (index) {
                setState(() {
                  if (index == 2) {
                    if (currentIndex != 2) {
                      previousIndex = currentIndex;
                    }
                  } else {
                    previousIndex = index;
                  }
                  currentIndex = index;
                });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: _BottomNavIcon(icon: Icons.home),
                  activeIcon: _BottomNavIcon(
                    icon: Icons.home,
                    selected: true,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: _BottomNavIcon(icon: Icons.emoji_events),
                  activeIcon: _BottomNavIcon(
                    icon: Icons.emoji_events,
                    selected: true,
                  ),
                  label: 'Challenges',
                ),
                BottomNavigationBarItem(
                  icon: _BottomNavIcon(icon: Icons.view_in_ar),
                  activeIcon: _BottomNavIcon(
                    icon: Icons.view_in_ar,
                    selected: true,
                  ),
                  label: 'AR',
                ),
                BottomNavigationBarItem(
                  icon: _BottomNavIcon(icon: Icons.leaderboard),
                  activeIcon: _BottomNavIcon(
                    icon: Icons.leaderboard,
                    selected: true,
                  ),
                  label: 'Leaderboard',
                ),
                BottomNavigationBarItem(
                  icon: _BottomNavIcon(icon: Icons.person),
                  activeIcon: _BottomNavIcon(
                    icon: Icons.person,
                    selected: true,
                  ),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNavIcon extends StatelessWidget {
  const _BottomNavIcon({
    required this.icon,
    this.selected = false,
  });

  final IconData icon;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    if (selected) {
      return PremiumGradientIconBox(
        icon: icon,
        size: 34,
        iconSize: 18,
      );
    }

    return SizedBox(
      width: 34,
      height: 34,
      child: Icon(
        icon,
        size: 22,
        color: Colors.white.withValues(alpha: 0.54),
      ),
    );
  }
}