import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flavr/core/theme/app_colors.dart';
import 'package:flavr/core/theme/app_spacing.dart';
import 'package:flavr/core/widgets/loading_overlay.dart';
import 'package:flavr/features/suggestions/presentation/widgets/retry_widget.dart';
import 'package:flavr/features/suggestions/presentation/widgets/suggestion_card.dart';
import 'package:flavr/features/suggestions/providers/suggestions_provider.dart';

class SuggestionsScreen extends ConsumerWidget {
  const SuggestionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(suggestionsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Discover'),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          if (state.hasValue && (state.value?.isNotEmpty ?? false))
            IconButton(
              icon: const Icon(Icons.refresh_rounded, color: AppColors.primary),
              tooltip: 'New suggestions',
              onPressed: () =>
                  ref.read(suggestionsProvider.notifier).regenerate(),
            ),
        ],
      ),
      body: state.when(
        loading: () => const FlavrLoadingIndicator(
          message: 'FlavrAI is cooking up ideas…',
        ),
        error: (error, _) => RetryWidget(
          message: error.toString(),
          onRetry: () => ref.invalidate(suggestionsProvider),
        ),
        data: (suggestions) {
          if (suggestions.isEmpty) {
            return RetryWidget(
              message: 'No suggestions yet. Tap refresh to get started.',
              onRetry: () =>
                  ref.read(suggestionsProvider.notifier).regenerate(),
            );
          }
          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () =>
                ref.read(suggestionsProvider.notifier).regenerate(),
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                Text(
                  '${suggestions.length} suggestion${suggestions.length == 1 ? '' : 's'} for you',
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 13,
                    color: AppColors.textHint,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                ...suggestions.map(
                  (s) => SuggestionCard(
                    suggestion: s,
                    onTap: () => context.push(
                      '/suggestions/${s.id}',
                      extra: s,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                OutlinedButton.icon(
                  onPressed: () =>
                      ref.read(suggestionsProvider.notifier).loadMore(),
                  icon: const Icon(Icons.add_rounded, color: AppColors.primary),
                  label: const Text(
                    'Load 5 more',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          );
        },
      ),
      floatingActionButton: state.hasValue
          ? FloatingActionButton.extended(
              onPressed: () =>
                  ref.read(suggestionsProvider.notifier).regenerate(),
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.auto_awesome_rounded, color: Colors.white),
              label: const Text(
                'Surprise Me',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            )
          : null,
    );
  }
}
