import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flavr/core/theme/app_colors.dart';
import 'package:flavr/core/theme/app_spacing.dart';
import 'package:flavr/core/widgets/flavr_button.dart';
import 'package:flavr/domain/models/allergy.dart';
import 'package:flavr/domain/models/user_preferences.dart';
import 'package:flavr/features/onboarding/presentation/widgets/preference_summary_card.dart';
import 'package:flavr/features/onboarding/providers/onboarding_provider.dart';
import 'package:flavr/providers.dart';
import 'package:flavr/router/route_names.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: FutureBuilder<UserPreferences?>(
        future: ref.read(preferencesRepositoryProvider).loadPreferences(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          final prefs = snapshot.data;
          if (prefs == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'No preferences found.',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 15,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ElevatedButton(
                    onPressed: () => context.go(RouteNames.onboardingStep1),
                    child: const Text('Set up preferences'),
                  ),
                ],
              ),
            );
          }

          final allergyChips = prefs.allergies.isEmpty ||
                  (prefs.allergies.length == 1 &&
                      prefs.allergies.first == Allergy.none)
              ? ['No Allergies ✅']
              : prefs.allergies
                  .map((a) => '${a.emoji} ${a.displayName}')
                  .toList();

          final complexityChip = switch (prefs.mealComplexity) {
            1 => '⚡ Quick & Simple',
            2 => '🍳 Standard',
            3 => '👨‍🍳 Gourmet',
            _ => '🍳 Standard',
          };

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile header
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.primaryDark],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text('🍴', style: TextStyle(fontSize: 36)),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      const Text(
                        'Food Explorer',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Last updated: ${_formatDate(prefs.lastUpdated)}',
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 12,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),
                const _SectionLabel('My Preferences'),
                const SizedBox(height: AppSpacing.sm),

                PreferenceSummaryCard(
                  title: 'DIETARY STYLE',
                  chips: prefs.dietaryOptions
                      .map((d) => '${d.emoji} ${d.displayName}')
                      .toList(),
                  onEdit: () => _editAt(context, ref, prefs, 0),
                ),
                const SizedBox(height: AppSpacing.sm),
                PreferenceSummaryCard(
                  title: 'ALLERGIES',
                  chips: allergyChips,
                  onEdit: () => _editAt(context, ref, prefs, 1),
                ),
                const SizedBox(height: AppSpacing.sm),
                PreferenceSummaryCard(
                  title: 'CUISINES',
                  chips: prefs.favoriteCuisines.isEmpty
                      ? ['Any cuisine 🌍']
                      : prefs.favoriteCuisines
                          .map((c) => '${c.flagEmoji} ${c.displayName}')
                          .toList(),
                  onEdit: () => _editAt(context, ref, prefs, 2),
                ),
                const SizedBox(height: AppSpacing.sm),
                PreferenceSummaryCard(
                  title: 'HEALTH GOAL',
                  chips: [
                    '${prefs.healthGoal.emoji} ${prefs.healthGoal.displayName}'
                  ],
                  onEdit: () => _editAt(context, ref, prefs, 3),
                ),
                const SizedBox(height: AppSpacing.sm),
                PreferenceSummaryCard(
                  title: 'SPICE LEVEL',
                  chips: [
                    '${prefs.spiceLevel.emoji} ${prefs.spiceLevel.label}'
                  ],
                  onEdit: () => _editAt(context, ref, prefs, 4),
                ),
                const SizedBox(height: AppSpacing.sm),
                PreferenceSummaryCard(
                  title: 'MEAL COMPLEXITY',
                  chips: [complexityChip],
                  onEdit: () => _editAt(context, ref, prefs, 5),
                ),

                const SizedBox(height: AppSpacing.xl),
                FlavrButton(
                  label: 'Edit All Preferences',
                  isSecondary: true,
                  leadingIcon: const Icon(
                    Icons.edit_outlined,
                    color: AppColors.primary,
                    size: 18,
                  ),
                  onPressed: () => _editAt(context, ref, prefs, 0),
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          );
        },
      ),
    );
  }

  void _editAt(BuildContext context, WidgetRef ref, UserPreferences prefs, int step) {
    ref.read(onboardingProvider.notifier).loadExistingPreferences(prefs);
    ref.read(onboardingProvider.notifier).setCurrentStep(step);
    const routes = [
      RouteNames.onboardingStep1,
      RouteNames.onboardingStep2,
      RouteNames.onboardingStep3,
      RouteNames.onboardingStep4,
      RouteNames.onboardingStep5,
      RouteNames.onboardingStep6,
    ];
    context.go(routes[step.clamp(0, 5)]);
  }

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Nunito',
        fontWeight: FontWeight.w700,
        fontSize: 18,
        color: AppColors.textPrimary,
      ),
    );
  }
}
