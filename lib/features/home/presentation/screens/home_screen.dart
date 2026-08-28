import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flavr/core/theme/app_colors.dart';
import 'package:flavr/core/theme/app_spacing.dart';
import 'package:flavr/core/widgets/flavr_button.dart';
import 'package:flavr/core/widgets/loading_overlay.dart';
import 'package:flavr/features/suggestions/presentation/widgets/suggestion_card.dart';
import 'package:flavr/features/suggestions/providers/suggestions_provider.dart';
import 'package:flavr/router/route_names.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggestions = ref.watch(suggestionsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 140,
            floating: true,
            pinned: false,
            backgroundColor: AppColors.background,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                onPressed: () => context.go(RouteNames.profile),
                icon: const Icon(Icons.person_rounded, color: AppColors.primary),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg, 60, AppSpacing.lg, AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        const Text('👋', style: TextStyle(fontSize: 28)),
                        const SizedBox(width: 8),
                        Text(
                          'Welcome to Flavr',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Your AI-powered food companion',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick actions
                  Row(
                    children: [
                      Expanded(
                        child: _QuickActionCard(
                          emoji: '✨',
                          label: 'Get Suggestions',
                          color: AppColors.primary,
                          onTap: () => context.go(RouteNames.suggestions),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _QuickActionCard(
                          emoji: '👤',
                          label: 'My Profile',
                          color: AppColors.secondary,
                          onTap: () => context.go(RouteNames.profile),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Latest suggestions preview
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Today\'s Picks',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.go(RouteNames.suggestions),
                        child: const Text(
                          'See all',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  suggestions.when(
                    loading: () => const FlavrLoadingIndicator(
                      message: 'Getting your picks…',
                    ),
                    error: (e, _) => Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.lg),
                      child: Column(
                        children: [
                          const Text('🍽️', style: TextStyle(fontSize: 48)),
                          const SizedBox(height: AppSpacing.sm),
                          const Text(
                            'No suggestions yet',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 15,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          FlavrButton(
                            label: 'Get Suggestions',
                            onPressed: () => ref
                                .read(suggestionsProvider.notifier)
                                .regenerate(),
                          ),
                        ],
                      ),
                    ),
                    data: (list) {
                      if (list.isEmpty) {
                        return Column(
                          children: [
                            const Text('🍽️',
                                style: TextStyle(fontSize: 48)),
                            const SizedBox(height: AppSpacing.sm),
                            const Text('Tap below to get your first picks!'),
                            const SizedBox(height: AppSpacing.md),
                            FlavrButton(
                              label: 'Get Suggestions ✨',
                              onPressed: () => ref
                                  .read(suggestionsProvider.notifier)
                                  .regenerate(),
                            ),
                          ],
                        );
                      }
                      return Column(
                        children: list.take(2).map((s) {
                          return SuggestionCard(
                            suggestion: s,
                            onTap: () => context.push(
                              '/suggestions/${s.id}',
                              extra: s,
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),

                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String emoji;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.emoji,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
