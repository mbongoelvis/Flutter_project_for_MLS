import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flavr/core/theme/app_colors.dart';
import 'package:flavr/core/theme/app_spacing.dart';
import 'package:flavr/core/widgets/flavr_button.dart';
import 'package:flavr/domain/models/allergy.dart';
import 'package:flavr/features/onboarding/presentation/widgets/preference_summary_card.dart';
import 'package:flavr/features/onboarding/presentation/widgets/step_header.dart';
import 'package:flavr/features/onboarding/providers/onboarding_provider.dart';
import 'package:flavr/router/route_names.dart';

class Step6ReviewScreen extends ConsumerWidget {
  const Step6ReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final draft = state.draft;

    final allergyChips = draft.allergies.isEmpty ||
            (draft.allergies.length == 1 && draft.allergies.first == Allergy.none)
        ? ['No Allergies ✅']
        : draft.allergies.map((a) => '${a.emoji} ${a.displayName}').toList();

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const StepHeader(
                  emoji: '🎉',
                  title: 'Your Flavor Profile',
                  subtitle: 'Looks good? Tap edit to tweak anything.',
                ),
                const SizedBox(height: AppSpacing.lg),

                PreferenceSummaryCard(
                  title: 'DIETARY STYLE',
                  chips: draft.dietaryOptions
                      .map((d) => '${d.emoji} ${d.displayName}')
                      .toList(),
                  onEdit: () {
                    ref.read(onboardingProvider.notifier).setCurrentStep(0);
                    context.go(RouteNames.onboardingStep1);
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                PreferenceSummaryCard(
                  title: 'ALLERGIES',
                  chips: allergyChips,
                  onEdit: () {
                    ref.read(onboardingProvider.notifier).setCurrentStep(1);
                    context.go(RouteNames.onboardingStep2);
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                PreferenceSummaryCard(
                  title: 'CUISINES',
                  chips: draft.favoriteCuisines.isEmpty
                      ? ['Any cuisine 🌍']
                      : draft.favoriteCuisines
                          .map((c) => '${c.flagEmoji} ${c.displayName}')
                          .toList(),
                  onEdit: () {
                    ref.read(onboardingProvider.notifier).setCurrentStep(2);
                    context.go(RouteNames.onboardingStep3);
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                PreferenceSummaryCard(
                  title: 'HEALTH GOAL',
                  chips: [
                    '${draft.healthGoal.emoji} ${draft.healthGoal.displayName}'
                  ],
                  onEdit: () {
                    ref.read(onboardingProvider.notifier).setCurrentStep(3);
                    context.go(RouteNames.onboardingStep4);
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                PreferenceSummaryCard(
                  title: 'SPICE LEVEL',
                  chips: ['${draft.spiceLevel.emoji} ${draft.spiceLevel.label}'],
                  onEdit: () {
                    ref.read(onboardingProvider.notifier).setCurrentStep(4);
                    context.go(RouteNames.onboardingStep5);
                  },
                ),
                const SizedBox(height: AppSpacing.lg),

                // Meal complexity picker
                const Text(
                  'MEAL COMPLEXITY',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    _ComplexityOption(
                      label: 'Simple',
                      emoji: '⚡',
                      value: 1,
                      selected: draft.mealComplexity,
                      onTap: () => ref
                          .read(onboardingProvider.notifier)
                          .setMealComplexity(1),
                    ),
                    const SizedBox(width: 8),
                    _ComplexityOption(
                      label: 'Moderate',
                      emoji: '🍳',
                      value: 2,
                      selected: draft.mealComplexity,
                      onTap: () => ref
                          .read(onboardingProvider.notifier)
                          .setMealComplexity(2),
                    ),
                    const SizedBox(width: 8),
                    _ComplexityOption(
                      label: 'Gourmet',
                      emoji: '👨‍🍳',
                      value: 3,
                      selected: draft.mealComplexity,
                      onTap: () => ref
                          .read(onboardingProvider.notifier)
                          .setMealComplexity(3),
                    ),
                  ],
                ),

                if (state.errorMessage != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      state.errorMessage!,
                      style: const TextStyle(
                        color: AppColors.error,
                        fontFamily: 'Nunito',
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],

                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: FlavrButton(
            label: state.isSaving ? 'Saving…' : 'Start Discovering Food 🚀',
            isLoading: state.isSaving,
            onPressed: state.isSaving
                ? null
                : () async {
                    await ref
                        .read(onboardingProvider.notifier)
                        .completeOnboarding();
                    if (context.mounted) {
                      context.go(RouteNames.home);
                    }
                  },
          ),
        ),
      ],
    );
  }
}

class _ComplexityOption extends StatelessWidget {
  const _ComplexityOption({
    required this.label,
    required this.emoji,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String emoji;
  final int value;
  final int selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selected;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.1)
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : const Color(0xFFEEE0D5),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 13,
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
