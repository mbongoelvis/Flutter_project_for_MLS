import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/flavr_button.dart';
import '../../../../domain/models/dietary_option.dart';
import '../../providers/onboarding_provider.dart';
import '../widgets/option_card.dart';
import '../widgets/step_header.dart';

class Step1DietaryScreen extends ConsumerWidget {
  const Step1DietaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(onboardingProvider).draft;
    final selected = draft.dietaryOptions;

    void toggle(DietaryOption option) {
      final current = List<DietaryOption>.from(selected);
      if (current.contains(option)) {
        if (current.length > 1) current.remove(option);
      } else {
        // Vegan overrides vegetarian and omnivore
        if (option == DietaryOption.vegan) {
          current.removeWhere((d) =>
              d == DietaryOption.vegetarian || d == DietaryOption.omnivore);
        }
        // Omnivore overrides vegan/vegetarian
        if (option == DietaryOption.omnivore) {
          current.removeWhere((d) =>
              d == DietaryOption.vegan || d == DietaryOption.vegetarian);
        }
        current.add(option);
      }
      ref.read(onboardingProvider.notifier).setDietaryOptions(current);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.lg),
          const StepHeader(
            emoji: '🍽️',
            title: 'How do you eat?',
            subtitle: 'Select all that describe your eating style.',
          ),
          const SizedBox(height: AppSpacing.xl),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.3,
              ),
              itemCount: DietaryOption.values.length,
              itemBuilder: (context, index) {
                final option = DietaryOption.values[index];
                return OptionCard(
                  emoji: option.emoji,
                  label: option.displayName,
                  isSelected: selected.contains(option),
                  onTap: () => toggle(option),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          FlavrButton(
            label: 'Continue',
            onPressed: selected.isNotEmpty
                ? () {
                    ref.read(onboardingProvider.notifier).nextStep();
                    context.go('/onboarding/2');
                  }
                : null,
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}
