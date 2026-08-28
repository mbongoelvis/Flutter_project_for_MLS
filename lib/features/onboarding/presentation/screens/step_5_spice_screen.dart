import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flavr/core/theme/app_spacing.dart';
import 'package:flavr/core/widgets/flavr_button.dart';
import 'package:flavr/domain/models/spice_level.dart';
import 'package:flavr/features/onboarding/presentation/widgets/spice_slider.dart';
import 'package:flavr/features/onboarding/presentation/widgets/step_header.dart';
import 'package:flavr/features/onboarding/providers/onboarding_provider.dart';
import 'package:flavr/router/route_names.dart';

class Step5SpiceScreen extends ConsumerStatefulWidget {
  const Step5SpiceScreen({super.key});

  @override
  ConsumerState<Step5SpiceScreen> createState() => _Step5SpiceScreenState();
}

class _Step5SpiceScreenState extends ConsumerState<Step5SpiceScreen> {
  late SpiceLevel _selected;

  @override
  void initState() {
    super.initState();
    _selected = ref.read(onboardingProvider).draft.spiceLevel;
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
                  emoji: '🌶️',
                  title: 'How spicy do you like it?',
                  subtitle: 'Be honest — we won\'t judge!',
                ),
                const SizedBox(height: AppSpacing.xxl),
                SpiceSelector(
                  selected: _selected,
                  onChanged: (level) => setState(() => _selected = level),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  _selected.emoji,
                  style: const TextStyle(fontSize: 48),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  _selected.label,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
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
                  .setSpiceLevel(_selected);
              ref.read(onboardingProvider.notifier).nextStep();
              context.go(RouteNames.onboardingStep6);
            },
          ),
        ),
      ],
    );
  }
}
