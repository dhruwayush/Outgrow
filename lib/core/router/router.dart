import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/habits/view/create_habit_screen.dart';
import '../../features/habits/view/slip_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/check_in/view/success_screen.dart';
import '../../features/habits/model/habit.dart';
import '../../features/habits/view/habit_detail_screen.dart';
import '../../features/habits/view/urges_screen.dart';
import '../../features/habits/view/breathing_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash', 
    redirect: (context, state) {
      final box = Hive.box('settings');
      final bool onboarded = box.get('onboarding_seen', defaultValue: false);
      
      final bool loggingIn = state.uri.toString() == '/onboarding';
      final bool splashing = state.uri.toString() == '/splash';
      
      if (splashing) return null; // Allow splash to run
      
      if (!onboarded) return '/onboarding';
      if (loggingIn) return '/'; // If onboarded but trying to access onboarding, go home
      
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/success',
        builder: (context, state) {
          final habit = state.extra as Habit;
          return SuccessScreen(habit: habit);
        },
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'create-habit', 
            builder: (context, state) => const CreateHabitScreen(),
          ),
          GoRoute(
            path: 'slip/:habitId',
            builder: (context, state) {
              final habitId = state.pathParameters['habitId']!;
              return SlipScreen(habitId: habitId);
            },
          ),
          GoRoute(
            path: 'habit/:habitId',
            builder: (context, state) {
              final habitId = state.pathParameters['habitId']!;
              return HabitDetailScreen(habitId: habitId);
            },
          ),
          GoRoute(
            path: 'urges',
            builder: (context, state) => const UrgesScreen(),
            routes: [
              GoRoute(
                path: 'breathe',
                builder: (context, state) => const BreathingScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
