import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flavr/core/constants/app_constants.dart';
import 'package:flavr/core/theme/app_colors.dart';
import 'package:flavr/core/theme/app_spacing.dart';
import 'package:flavr/core/widgets/flavr_button.dart';
import 'package:flavr/domain/models/cuisine_type.dart';
import 'package:flavr/features/onboarding/presentation/widgets/multi_select_grid.dart';
import 'package:flavr/features/onboarding/presentation/widgets/option_card.dart';
import 'package:flavr/features/onboarding/presentation/widgets/step_header.dart';
import 'package:flavr/features/onboarding/providers/onboarding_provider.dart';
import 'package:flavr/router/route_names.dart';

class Step3CuisinesScreen extends ConsumerStatefulWidget {
  const Step3CuisinesScreen({super.key});

  @override
  ConsumerState<Step3CuisinesScreen> createState() =>
      _Step3CuisinesScreenState();
}

class _Step3CuisinesScreenState extends ConsumerState<Step3CuisinesScreen> {
  late List<CuisineType> _selected;

  @override
  void initState() {
    super.initState();
    _selected =
        List.from(ref.read(onboardingProvider).draft.favoriteCuisines);
  }

  @override
  Widget build(BuildContext context) {
    final remaining = kMaxCuisineSelections - _selected.length;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                StepHeader(
                  emoji: '🌍',
                  title: 'Favourite cuisines?',
                  subtitle: remaining > 0
                      ? 'Pick up to $kMaxCuisineSelections. You can choose $remaining more.'
                      : 'Maximum reached! Deselect to change.',
                ),
                if (_selected.length >= kMaxCuisineSelections)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.sm),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '✓ $kMaxCuisineSelections cuisines selected',
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: AppSpacing.lg),
                MultiSelectGrid<CuisineType>(
                  options: CuisineType.values,
                  initiallySelected: _selected,
                  maxSelections: kMaxCuisineSelections,
                  childAspectRatio: 1.6,
                  itemBuilder: (item, isSelected, onTap) => OptionCard(
                    emoji: item.flagEmoji,
                    label: item.displayName,
                    isSelected: isSelected,
                    onTap: onTap,
                  ),
                  onChanged: (list) {
                    setState(() => _selected = list.toList());
                  },
                ),
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
                  .setFavoriteCuisines(_selected);
              ref.read(onboardingProvider.notifier).nextStep();
              context.go(RouteNames.onboardingStep4);
            },
          ),
        ),
      ],
    );
  }
}
