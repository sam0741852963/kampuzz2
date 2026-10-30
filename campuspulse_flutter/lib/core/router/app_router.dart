import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home_feed/presentation/home_feed_screen.dart';
import '../../features/study_hub/presentation/study_hub_screen.dart';
import '../../features/quiz_arena/presentation/quiz_arena_screen.dart';
import '../../features/community/presentation/community_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/connect/presentation/connect_screen.dart';
import '../../features/rental/presentation/rental_screen.dart';
import '../../features/bunk_meter/presentation/bunk_meter_screen.dart';
import '../../features/timetable/presentation/timetable_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../widgets/responsive_scaffold.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/connect',
      builder: (context, state) => const ConnectScreen(),
    ),
    GoRoute(
      path: '/rent',
      builder: (context, state) => const RentalScreen(),
    ),
    GoRoute(
      path: '/bunk-meter',
      builder: (context, state) => const BunkMeterScreen(),
    ),
    GoRoute(
      path: '/timetable',
      builder: (context, state) => const TimetableScreen(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return ResponsiveScaffold(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomeFeedScreen(),
          ),
        ),
        GoRoute(
          path: '/study',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: StudyHubScreen(),
          ),
        ),
        GoRoute(
          path: '/arena',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: QuizArenaScreen(),
          ),
        ),
        GoRoute(
          path: '/community',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: CommunityScreen(),
          ),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ProfileScreen(),
          ),
        ),
      ],
    ),
  ],
);
