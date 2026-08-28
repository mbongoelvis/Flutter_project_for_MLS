import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flavr/core/theme/app_colors.dart';
import 'package:flavr/core/theme/app_spacing.dart';
import 'package:flavr/core/widgets/flavr_button.dart';
import 'package:flavr/domain/models/allergy.dart';
import 'package:flavr/features/onboarding/presentation/widgets/multi_select_grid.dart';
import 'package:flavr/features/onboarding/presentation/widgets/option_card.dart';
import 'package:flavr/features/onboarding/presentation/widgets/step_header.dart';
import 'package:flavr/features/onboarding/providers/onboarding_provider.dart';
import 'package:flavr/router/route_names.dart';

class Step2AllergiesScreen extends ConsumerStatefulWidget {
  const Step2AllergiesScreen({super.key});

  @override
  ConsumerState<Step2AllergiesScreen> createState() =>
      _Step2AllergiesScreenState();
}

class _Step2AllergiesScreenState extends ConsumerState<Step2AllergiesScreen> {
  late List<Allergy> _selected;
  bool _noneSelected = false;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(onboardingProvider).draft.allergies;
    _noneSelected = draft.contains(Allergy.none);
    _selected = draft.where((a) => a != Allergy.none).toList();
  }

  void _toggleNone() {
    setState(() {
      _noneSelected = !_noneSelected;
      if (_noneSelected) _selected.clear();
    });
  }

  List<Allergy> get _effectiveSelection =>
      _noneSelected ? [Allergy.none] : _selected;

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
                  emoji: '⚠️',
                  title: 'Any food allergies\nor intolerances?',
                  subtitle:
                      'We\'ll make sure your suggestions are 100% safe for you.',
                ),
                const SizedBox(height: AppSpacing.lg),
                // "None" toggle button
                GestureDetector(
                  onTap: _toggleNone,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: _noneSelected
                          ? AppColors.success.withValues(alpha: 0.1)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _noneSelected
                            ? AppColors.success
                            : const Color(0xFFEEE0D5),
                        width: _noneSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          Allergy.none.emoji,
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'No Allergies',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: _noneSelected
                                ? AppColors.success
                                : AppColors.textPrimary,
                          ),
                        ),
                        if (_noneSelected) ...[
                          const SizedBox(width: 6),
                          Icon(Icons.check_circle_rounded,
                              color: AppColors.success, size: 18),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                if (!_noneSelected) ...[
                  const Text(
                    'Select all that apply:',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 13,
                      color: AppColors.textHint,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  MultiSelectGrid<Allergy>(
                    options:
                        Allergy.values.where((a) => a != Allergy.none).toList(),
                    initiallySelected: _selected,
                    childAspectRatio: 1.6,
                    itemBuilder: (item, isSelected, onTap) => OptionCard(
                      emoji: item.emoji,
                      label: item.displayName,
                      isSelected: isSelected,
                      onTap: onTap,
                    ),
                    onChanged: (list) {
                      setState(() {
                        _selected = list.toList();
                        if (_selected.isNotEmpty) _noneSelected = false;
                      });
                    },
                  ),
                ],
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
                  .setAllergies(_effectiveSelection);
              ref.read(onboardingProvider.notifier).nextStep();
              context.go(RouteNames.onboardingStep3);
            },
          ),
        ),
      ],
    );
  }
}
