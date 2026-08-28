import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class FoodSuggestion extends Equatable {
  final String id;
  final String name;
  final String description;
  final String cuisine;
  final List<String> ingredients;
  final Map<String, int> macros; // calories, protein_g, carbs_g, fat_g
  final List<String> dietaryTags;
  final int prepTimeMinutes;
  final int spiceLevelValue; // 0-4
  final List<String> whyItFitsYou;
  final String imageSearchQuery;
  final DateTime suggestedAt;

  const FoodSuggestion({
    required this.id,
    required this.name,
    required this.description,
    required this.cuisine,
    required this.ingredients,
    required this.macros,
    required this.dietaryTags,
    required this.prepTimeMinutes,
    required this.spiceLevelValue,
    required this.whyItFitsYou,
    required this.imageSearchQuery,
    required this.suggestedAt,
  });

  factory FoodSuggestion.fromJson(Map<String, dynamic> json) {
    // Helper to read a key by either camelCase or snake_case
    T? getField<T>(String camel, String snake) =>
        (json[camel] ?? json[snake]) as T?;

    return FoodSuggestion(
      id: const Uuid().v4(),
      name: (json['name'] as String?) ?? 'Unknown Dish',
      description: (json['description'] as String?) ?? '',
      cuisine: (json['cuisine'] as String?) ?? 'International',
      ingredients: (getField<List>('ingredients', 'ingredients') != null)
          ? List<String>.from(getField<List>('ingredients', 'ingredients')!)
          : [],
      macros: json['macros'] != null
          ? Map<String, int>.from(
              (json['macros'] as Map).map(
                (k, v) => MapEntry(k.toString(), (v as num).toInt()),
              ),
            )
          : {'calories': 0, 'protein_g': 0, 'carbs_g': 0, 'fat_g': 0},
      dietaryTags: (getField<List>('dietaryTags', 'dietary_tags') != null)
          ? List<String>.from(getField<List>('dietaryTags', 'dietary_tags')!)
          : [],
      prepTimeMinutes:
          ((getField<num>('prepTimeMinutes', 'prep_time_minutes')) ?? 30).toInt(),
      spiceLevelValue:
          ((getField<num>('spiceLevelValue', 'spice_level_value')) ?? 0)
              .toInt()
              .clamp(0, 4),
      whyItFitsYou: (getField<List>('whyItFitsYou', 'why_it_fits_you') != null)
          ? List<String>.from(getField<List>('whyItFitsYou', 'why_it_fits_you')!)
          : [],
      imageSearchQuery:
          (getField<String>('imageSearchQuery', 'image_search_query')) ??
              (json['name'] as String? ?? 'food dish'),
      suggestedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'cuisine': cuisine,
      'ingredients': ingredients,
      'macros': macros,
      'dietary_tags': dietaryTags,
      'prep_time_minutes': prepTimeMinutes,
      'spice_level_value': spiceLevelValue,
      'why_it_fits_you': whyItFitsYou,
      'image_search_query': imageSearchQuery,
      'suggested_at': suggestedAt.toIso8601String(),
    };
  }

  int get calories => macros['calories'] ?? 0;
  int get proteinG => macros['protein_g'] ?? 0;
  int get carbsG => macros['carbs_g'] ?? 0;
  int get fatG => macros['fat_g'] ?? 0;

  @override
  List<Object?> get props => [id];
}
