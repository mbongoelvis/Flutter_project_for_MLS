import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flavr/core/theme/app_colors.dart';
import 'package:flavr/core/theme/app_spacing.dart';
import 'package:flavr/core/widgets/flavr_button.dart';
import 'package:flavr/domain/models/health_goal.dart';
import 'package:flavr/features/onboarding/presentation/widgets/step_header.dart';
import 'package:flavr/features/onboarding/providers/onboarding_provider.dart';
import 'package:flavr/router/route_names.dart';

class Step4HealthGoalsScreen extends ConsumerStatefulWidget {
  const Step4HealthGoalsScreen({super.key});

  @override
  ConsumerState<Step4HealthGoalsScreen> createState() =>
      _Step4HealthGoalsScreenState();
}

class _Step4HealthGoalsScreenState
    extends ConsumerState<Step4HealthGoalsScreen> {
  late HealthGoal _selected;

  @override
  void initState() {
    super.initState();
    _selected = ref.read(onboardingProvider).draft.healthGoal;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                const StepHeader(
                  emoji: '🎯',
                  title: 'What\'s your goal?',
                  subtitle: 'We\'ll tune your suggestions to support it.',
                ),
                const SizedBox(height: AppSpacing.lg),
                ...HealthGoal.values.map((goal) {
                  final isSelected = goal == _selected;
                  return GestureDetector(
                    onTap: () => setState(() => _selected = goal),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withOpacity(0.08)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : const Color(0xFFEEE0D5),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(goal.emoji,
                              style: const TextStyle(fontSize: 26)),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  goal.displayName,
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  goal.description,
                                  style: const TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            const Icon(Icons.check_circle_rounded,
                                color: AppColors.primary, size: 22),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: FlavrButton(
            label: 'Continue',
            onPressed: () {
              ref
                  .read(onboardingProvider.notifier)
                  .setHealthGoal(_selected);
              ref.read(onboardingProvider.notifier).nextStep();
              context.go(RouteNames.onboardingStep5);
            },
          ),
        ),
      ],
    );
  }
}
