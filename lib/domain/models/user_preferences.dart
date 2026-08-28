import 'package:hive_flutter/hive_flutter.dart';
import 'dietary_option.dart';
import 'allergy.dart';
import 'cuisine_type.dart';
import 'health_goal.dart';
import 'spice_level.dart';

part 'user_preferences.g.dart';

@HiveType(typeId: 0)
class UserPreferences extends HiveObject {
  @HiveField(0)
  List<DietaryOption> dietaryOptions;

  @HiveField(1)
  List<Allergy> allergies;

  @HiveField(2)
  List<CuisineType> favoriteCuisines;

  @HiveField(3)
  HealthGoal healthGoal;

  @HiveField(4)
  SpiceLevel spiceLevel;

  @HiveField(5)
  int mealComplexity;

  @HiveField(6)
  bool onboardingComplete;

  @HiveField(7)
  DateTime lastUpdated;

  UserPreferences({
    required this.dietaryOptions,
    required this.allergies,
    required this.favoriteCuisines,
    required this.healthGoal,
    required this.spiceLevel,
    required this.mealComplexity,
    required this.onboardingComplete,
    required this.lastUpdated,
  });

  factory UserPreferences.empty() => UserPreferences(
        dietaryOptions: [DietaryOption.omnivore],
        allergies: [Allergy.none],
        favoriteCuisines: [],
        healthGoal: HealthGoal.balanced,
        spiceLevel: SpiceLevel.medium,
        mealComplexity: 2,
        onboardingComplete: false,
        lastUpdated: DateTime.now(),
      );

  UserPreferences copyWith({
    List<DietaryOption>? dietaryOptions,
    List<Allergy>? allergies,
    List<CuisineType>? favoriteCuisines,
    HealthGoal? healthGoal,
    SpiceLevel? spiceLevel,
    int? mealComplexity,
    bool? onboardingComplete,
    DateTime? lastUpdated,
  }) =>
      UserPreferences(
        dietaryOptions: dietaryOptions ?? this.dietaryOptions,
        allergies: allergies ?? this.allergies,
        favoriteCuisines: favoriteCuisines ?? this.favoriteCuisines,
        healthGoal: healthGoal ?? this.healthGoal,
        spiceLevel: spiceLevel ?? this.spiceLevel,
        mealComplexity: mealComplexity ?? this.mealComplexity,
        onboardingComplete: onboardingComplete ?? this.onboardingComplete,
        lastUpdated: lastUpdated ?? this.lastUpdated,
      );
}
