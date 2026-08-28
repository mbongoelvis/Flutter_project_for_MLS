import '../../domain/models/allergy.dart';
import '../../domain/models/health_goal.dart';
import '../../domain/models/spice_level.dart';
import '../../domain/models/user_preferences.dart';

abstract final class PromptBuilder {
  static String build(
    UserPreferences prefs, {
    List<String> excludeNames = const [],
    int count = 5,
  }) {
    final buffer = StringBuffer();

    // 1. Dietary identity
    if (prefs.dietaryOptions.isNotEmpty) {
      final names = prefs.dietaryOptions.map((d) => d.displayName).join(', ');
      buffer.writeln('The user follows a $names diet.');
    }

    // 2. Allergy clause
    final allergies =
        prefs.allergies.where((a) => a != Allergy.none).toList();
    if (allergies.isEmpty) {
      buffer.writeln('They have no known food allergies.');
    } else {
      final names = allergies.map((a) => a.displayName).join(', ');
      buffer.writeln(
          'They have STRICT allergies to: $names. Do NOT include any dish containing these ingredients.');
    }

    // 3. Cuisine preference
    if (prefs.favoriteCuisines.isNotEmpty) {
      final names =
          prefs.favoriteCuisines.map((c) => c.displayName).join(', ');
      buffer.writeln(
          'They enjoy $names cuisines. Prioritize dishes from these cultures, but occasional fusion is welcome.');
    }

    // 4. Health goal directive
    buffer.writeln(_healthGoalClause(prefs.healthGoal));

    // 5. Spice tolerance
    buffer.writeln(_spiceClause(prefs.spiceLevel));

    // 6. Meal complexity
    buffer.writeln(_complexityClause(prefs.mealComplexity));

    // 7. Exclusions
    if (excludeNames.isNotEmpty) {
      final names = excludeNames.join(', ');
      buffer.writeln(
          'Do NOT suggest any of these dishes (already shown): $names.');
    }

    // 8. Output instruction
    buffer.writeln(
        '\nRespond with exactly $count meal suggestions as a JSON array. '
        'Each object must follow the schema from your system instructions exactly. '
        'Return ONLY the raw JSON array — no markdown, no code fences, no extra text.');

    return buffer.toString();
  }

  static String _healthGoalClause(HealthGoal goal) => switch (goal) {
        HealthGoal.weightLoss =>
          'Health goal: weight loss. Prioritize dishes under 500 calories with high fiber and strong satiety. Avoid calorie-dense sauces.',
        HealthGoal.muscleGain =>
          'Health goal: muscle gain. Prefer high-protein meals with at least 30g of protein per serving. Include lean meats, legumes, or tofu.',
        HealthGoal.heartHealth =>
          'Health goal: heart health. Avoid high-sodium and saturated-fat dishes. Include omega-3 rich ingredients like salmon, walnuts, or flaxseed.',
        HealthGoal.energyBoost =>
          'Health goal: sustained energy. Include complex carbohydrates, B-vitamin rich foods, and iron-rich ingredients. Avoid refined sugars.',
        HealthGoal.gutHealth =>
          'Health goal: gut health. Include fermented foods (yogurt, kimchi, miso), fiber-rich vegetables, and prebiotic ingredients where possible.',
        HealthGoal.diabeticFriendly =>
          'Health goal: diabetic-friendly. Low glycemic index dishes only. Avoid refined sugars and white refined carbs. Prioritize fiber and lean protein.',
        HealthGoal.balanced =>
          'Health goal: balanced nutrition. Suggest well-rounded meals with a healthy mix of protein, complex carbs, healthy fats, and vegetables.',
      };

  static String _spiceClause(SpiceLevel level) => switch (level) {
        SpiceLevel.none =>
          'The user prefers completely non-spicy food. No chili, no pepper heat.',
        SpiceLevel.mild =>
          'The user prefers mildly spiced food — very subtle warmth is acceptable.',
        SpiceLevel.medium =>
          'The user enjoys moderately spiced food with noticeable but not overwhelming heat.',
        SpiceLevel.hot =>
          'The user enjoys hot, spicy food with bold chili heat.',
        SpiceLevel.extraHot =>
          'The user loves very hot, intensely spicy food. Bold chili, ghost pepper, and strong spices are welcome.',
      };

  static String _complexityClause(int complexity) => switch (complexity) {
        1 =>
          'Suggest quick and simple recipes suitable for a beginner home cook — under 30 minutes prep time preferred.',
        3 =>
          'Suggest gourmet, restaurant-quality recipes suitable for an experienced home chef. Complex techniques and premium ingredients are welcome.',
        _ =>
          'Suggest moderately involved recipes suitable for an intermediate home cook — 30-60 minutes total.',
      };
}
