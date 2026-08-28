import 'package:flutter/material.dart';
import 'package:flavr/core/theme/app_colors.dart';
import 'package:flavr/core/theme/app_spacing.dart';
import 'package:flavr/domain/models/food_suggestion.dart';
import 'package:flavr/features/suggestions/presentation/widgets/macro_badge.dart';

class SuggestionDetailScreen extends StatelessWidget {
  final FoodSuggestion suggestion;

  const SuggestionDetailScreen({super.key, required this.suggestion});

  @override
  Widget build(BuildContext context) {
    final spiceLabel = _spiceLabel(suggestion.spiceLevelValue);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Hero header
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: _cuisineColor(suggestion.cuisine),
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding:
                  const EdgeInsets.only(left: 60, right: 16, bottom: 12),
              title: Text(
                suggestion.name,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Colors.white,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _cuisineColor(suggestion.cuisine),
                      _cuisineColor(suggestion.cuisine).withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Text(
                    _cuisineEmoji(suggestion.cuisine),
                    style: const TextStyle(fontSize: 96),
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cuisine + time + spice row
                  Row(
                    children: [
                      _InfoChip(
                        icon: Icons.public_outlined,
                        label: suggestion.cuisine,
                        color: AppColors.secondary,
                      ),
                      const SizedBox(width: 8),
                      _InfoChip(
                        icon: Icons.schedule_rounded,
                        label: '${suggestion.prepTimeMinutes} min',
                        color: AppColors.accent,
                      ),
                      const SizedBox(width: 8),
                      _InfoChip(
                        label: spiceLabel,
                        color: AppColors.error,
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Description
                  const _SectionTitle('About This Dish'),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    suggestion.description,
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 15,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Macros
                  const _SectionTitle('Nutrition (per serving)'),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      MacroBadge.calories(suggestion.macros['calories'] ?? 0),
                      const SizedBox(width: 8),
                      MacroBadge.protein(suggestion.macros['protein_g'] ?? 0),
                      const SizedBox(width: 8),
                      MacroBadge.carbs(suggestion.macros['carbs_g'] ?? 0),
                      const SizedBox(width: 8),
                      MacroBadge.fat(suggestion.macros['fat_g'] ?? 0),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Why it fits you
                  const _SectionTitle('Why It Fits You ✨'),
                  const SizedBox(height: AppSpacing.sm),
                  ...suggestion.whyItFitsYou.map((reason) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('✅ ', style: TextStyle(fontSize: 14)),
                            Expanded(
                              child: Text(
                                reason,
                                style: const TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),

                  const SizedBox(height: AppSpacing.lg),

                  // Ingredients
                  const _SectionTitle('Ingredients'),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: suggestion.ingredients
                        .map((ing) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.cardBackground,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(0xFFEEE0D5),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                ing,
                                style: const TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ))
                        .toList(),
                  ),

                  if (suggestion.dietaryTags.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.lg),
                    const _SectionTitle('Dietary Tags'),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: suggestion.dietaryTags
                          .map((tag) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: AppColors.secondary
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  tag,
                                  style: const TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.secondary,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ],

                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _cuisineColor(String cuisine) {
    final lc = cuisine.toLowerCase();
    if (lc.contains('italian')) return const Color(0xFF1B7E4E);
    if (lc.contains('indian')) return const Color(0xFFD4460A);
    if (lc.contains('japanese')) return const Color(0xFFBD2424);
    if (lc.contains('mexican')) return const Color(0xFF6B3A9C);
    if (lc.contains('mediterranean')) return const Color(0xFF1565C0);
    if (lc.contains('thai')) return const Color(0xFF7B6200);
    if (lc.contains('chinese')) return const Color(0xFFC62828);
    if (lc.contains('american')) return const Color(0xFF1565C0);
    if (lc.contains('korean')) return const Color(0xFF4A148C);
    if (lc.contains('middle')) return const Color(0xFF558B2F);
    return AppColors.primaryDark;
  }

  String _cuisineEmoji(String cuisine) {
    final lc = cuisine.toLowerCase();
    if (lc.contains('italian')) return '🍝';
    if (lc.contains('indian')) return '🍛';
    if (lc.contains('japanese')) return '🍱';
    if (lc.contains('mexican')) return '🌮';
    if (lc.contains('mediterranean')) return '🫒';
    if (lc.contains('thai')) return '🍜';
    if (lc.contains('chinese')) return '🥢';
    if (lc.contains('american')) return '🍔';
    if (lc.contains('korean')) return '🥩';
    if (lc.contains('middle')) return '🧆';
    return '🍽️';
  }

  String _spiceLabel(int level) {
    switch (level) {
      case 0:
        return '😌 No Spice';
      case 1:
        return '🌶️ Mild';
      case 2:
        return '🌶️🌶️ Medium';
      case 3:
        return '🌶️🌶️🌶️ Hot';
      default:
        return '🔥 Extra Hot';
    }
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Nunito',
        fontWeight: FontWeight.w700,
        fontSize: 17,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData? icon;
  final String label;
  final Color color;

  const _InfoChip({
    this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: color, size: 13),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
