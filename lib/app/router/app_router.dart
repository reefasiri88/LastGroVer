import 'package:flutter/material.dart';
import 'route_names.dart';
import '../../features/splash/screens/splash_screen.dart';
import '../../features/splash/screens/onboarding_flow_screen.dart';
import '../../features/auth/screens/welcome_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/forgot_password_step1_screen.dart';
import '../../features/auth/screens/forgot_password_step2_screen.dart';
import '../../features/auth/screens/password_changed_screen.dart';
import '../../features/auth/screens/otp_verification_screen.dart';
import '../../features/setup/screens/gender_selection_screen.dart';
import '../../features/setup/screens/age_selection_screen.dart';
import '../../features/setup/screens/weight_selection_screen.dart';
import '../../features/setup/screens/height_selection_screen.dart';
import '../../features/setup/screens/community_selection_screen.dart';
import '../../features/setup/screens/setup_complete_screen.dart';
import '../../features/home/screens/main_navigation_screen.dart';
import '../../features/home/screens/history_screen.dart';
import '../../features/events/screens/events_list_screen.dart';
import '../../features/events/screens/event_details_screen.dart';
import '../../features/events/screens/power_hour_event_screen.dart';
import '../../features/events/screens/youre_in_screen.dart';
import '../../features/leaderboard/screens/leaderboard_rankings_screen.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
        case RouteNames.splash:
            return MaterialPageRoute(
            builder: (_) => const SplashScreen(),
            );

        case '/onboarding':
            return MaterialPageRoute(
            builder: (_) => const OnboardingFlowScreen(),
            );

        case '/welcome':
            return MaterialPageRoute(
            builder: (_) => const WelcomeScreen(),
            );

        case RouteNames.login:
            return MaterialPageRoute(
            builder: (_) => const LoginScreen(),
            );

        case '/register':
            return MaterialPageRoute(
            builder: (_) => const RegisterScreen(),
            );

        case '/otp-verification':
            return MaterialPageRoute(
            builder: (_) => const OTPVerificationScreen(),
            );

        case '/forgot-password-1':
            return MaterialPageRoute(
            builder: (_) => const ForgotPasswordStep1Screen(),
            );

        case '/forgot-password-2':
            return MaterialPageRoute(
            builder: (_) => const ForgotPasswordStep2Screen(),
            );

        case '/password-changed':
            return MaterialPageRoute(
            builder: (_) => const PasswordChangedScreen(),
            );

         case RouteNames.setup:
            return MaterialPageRoute(
            builder: (_) => const GenderSelectionScreen(),
            );

         case '/setup-gender':
            return MaterialPageRoute(
            builder: (_) => const GenderSelectionScreen(),
            );

         case '/setup-age':
            return MaterialPageRoute(
            builder: (_) => const AgeSelectionScreen(),
            );

         case '/setup-weight':
            return MaterialPageRoute(
            builder: (_) => const WeightSelectionScreen(),
            );

         case '/setup-height':
            return MaterialPageRoute(
            builder: (_) => const HeightSelectionScreen(),
            );

         case '/setup-community':
            return MaterialPageRoute(
            builder: (_) => const CommunitySelectionScreen(),
            );

         case '/setup-complete':
            return MaterialPageRoute(
            builder: (_) => const SetupCompleteScreen(),
            );

         case RouteNames.mainNavigation:
            return MaterialPageRoute(
            builder: (_) => const MainNavigationScreen(),
            );

         case RouteNames.history:
            return MaterialPageRoute(
            builder: (_) => const HistoryScreen(),
            );

         case RouteNames.leaderboardRankings:
            return MaterialPageRoute(
            builder: (_) => const LeaderboardRankingsScreen(),
            );

         case '/events':
            return MaterialPageRoute(
            builder: (_) => const EventsListScreen(),
            );

         case '/events/details':
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
            builder: (_) => EventDetailsScreen(
              eventTitle: args?['title'] ?? 'Event Details',
              eventDescription:
                  args?['description'] ?? 'No description available',
              eventDate: args?['date'] ?? '',
            ),
            );

         case '/events/register':
            return MaterialPageRoute(
            builder: (_) => const PowerHourEventScreen(),
            );

         case '/events/success':
            return MaterialPageRoute(
            builder: (_) => const YoureInScreen(),
            );

        default:
            return MaterialPageRoute(
            builder: (_) => const Scaffold(
                body: Center(child: Text('No Route Found')),
            ),
            );

    }
  }
}