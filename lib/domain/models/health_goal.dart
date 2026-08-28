enum HealthGoal {
  balanced,
  weightLoss,
  muscleGain,
  heartHealth,
  energyBoost,
  gutHealth,
  diabeticFriendly;

  String get displayName => switch (this) {
        balanced => 'Just Balanced',
        weightLoss => 'Weight Loss',
        muscleGain => 'Muscle Gain',
        heartHealth => 'Heart Health',
        energyBoost => 'Energy Boost',
        gutHealth => 'Gut Health',
        diabeticFriendly => 'Diabetic-Friendly',
      };

  String get description => switch (this) {
        balanced => 'Well-rounded meals with healthy macros',
        weightLoss => 'Low-calorie, high-fiber, high-satiety meals',
        muscleGain => 'High-protein meals to support muscle building',
        heartHealth => 'Low sodium, omega-3 rich, heart-friendly dishes',
        energyBoost => 'Complex carbs and B-vitamins for sustained energy',
        gutHealth => 'Fermented foods and fiber for a healthy gut',
        diabeticFriendly => 'Low glycemic index, no refined sugars',
      };

  String get emoji => switch (this) {
        balanced => '⚖️',
        weightLoss => '🏃',
        muscleGain => '💪',
        heartHealth => '❤️',
        energyBoost => '⚡',
        gutHealth => '🦠',
        diabeticFriendly => '🩺',
      };
}
