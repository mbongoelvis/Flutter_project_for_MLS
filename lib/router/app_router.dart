import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flavr/core/theme/app_colors.dart';
import 'package:flavr/domain/models/food_suggestion.dart';
import 'package:flavr/features/home/presentation/screens/home_screen.dart';
import 'package:flavr/features/onboarding/presentation/screens/onboarding_shell_screen.dart';
import 'package:flavr/features/onboarding/presentation/screens/step_1_dietary_screen.dart';
import 'package:flavr/features/onboarding/presentation/screens/step_2_allergies_screen.dart';
import 'package:flavr/features/onboarding/presentation/screens/step_3_cuisines_screen.dart';
import 'package:flavr/features/onboarding/presentation/screens/step_4_health_goals_screen.dart';
import 'package:flavr/features/onboarding/presentation/screens/step_5_spice_screen.dart';
import 'package:flavr/features/onboarding/presentation/screens/step_6_review_screen.dart';
import 'package:flavr/features/profile/presentation/screens/profile_screen.dart';
import 'package:flavr/features/suggestions/presentation/screens/suggestion_detail_screen.dart';
import 'package:flavr/features/suggestions/presentation/screens/suggestions_screen.dart';
import 'package:flavr/providers.dart';
import 'package:flavr/router/route_names.dart';

// Main shell widget for the bottom navigation tab bar
class _MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const _MainShell({required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu_outlined),
            selectedIcon: Icon(Icons.restaurant_menu_rounded),
            label: 'Discover',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final localSource = ref.watch(userPrefsLocalSourceProvider);

  return GoRouter(
    initialLocation: RouteNames.home,
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final hasCompleted = localSource.hasCompleted;
      final location = state.uri.toString();
      final isOnboarding = location.startsWith('/onboarding');

      if (!hasCompleted && !isOnboarding) {
        return RouteNames.onboardingStep1;
      }
      if (hasCompleted && isOnboarding) {
        return RouteNames.home;
      }
      return null;
    },
    routes: [
      // ── Onboarding shell ──────────────────────────────────────────────
      ShellRoute(
        builder: (context, state, child) =>
            OnboardingShellScreen(child: child),
        routes: [
          GoRoute(
            path: RouteNames.onboardingStep1,
            pageBuilder: (context, state) => _fadeTransition(
              state,
              const Step1DietaryScreen(),
            ),
          ),
          GoRoute(
            path: RouteNames.onboardingStep2,
            pageBuilder: (context, state) => _slideTransition(
              state,
              const Step2AllergiesScreen(),
            ),
          ),
          GoRoute(
            path: RouteNames.onboardingStep3,
            pageBuilder: (context, state) => _slideTransition(
              state,
              const Step3CuisinesScreen(),
            ),
          ),
          GoRoute(
            path: RouteNames.onboardingStep4,
            pageBuilder: (context, state) => _slideTransition(
              state,
              const Step4HealthGoalsScreen(),
            ),
          ),
          GoRoute(
            path: RouteNames.onboardingStep5,
            pageBuilder: (context, state) => _slideTransition(
              state,
              const Step5SpiceScreen(),
            ),
          ),
          GoRoute(
            path: RouteNames.onboardingStep6,
            pageBuilder: (context, state) => _slideTransition(
              state,
              const Step6ReviewScreen(),
            ),
          ),
        ],
      ),

      // ── Main app shell (bottom nav) ───────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            _MainShell(navigationShell: navigationShell),
        branches: [
          // Home branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          // Suggestions branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.suggestions,
                builder: (context, state) => const SuggestionsScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) => SuggestionDetailScreen(
                      suggestion: state.extra as FoodSuggestion,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Profile branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

CustomTransitionPage<void> _fadeTransition(
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}

CustomTransitionPage<void> _slideTransition(
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      final tween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeInOut));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
