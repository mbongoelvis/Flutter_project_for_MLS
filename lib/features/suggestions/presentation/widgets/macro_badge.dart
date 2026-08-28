import 'package:flutter/material.dart';
import 'package:flavr/core/theme/app_colors.dart';

class MacroBadge extends StatelessWidget {
  const MacroBadge({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  factory MacroBadge.calories(int kcal) => MacroBadge(
        label: 'kcal',
        value: '$kcal',
        color: AppColors.macroCalories,
      );

  factory MacroBadge.protein(int grams) => MacroBadge(
        label: 'protein',
        value: '${grams}g',
        color: AppColors.macroProtein,
      );

  factory MacroBadge.carbs(int grams) => MacroBadge(
        label: 'carbs',
        value: '${grams}g',
        color: AppColors.macroCarbs,
      );

  factory MacroBadge.fat(int grams) => MacroBadge(
        label: 'fat',
        value: '${grams}g',
        color: AppColors.macroFat,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 10,
              color: color.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
