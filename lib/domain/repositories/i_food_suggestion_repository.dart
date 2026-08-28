import 'package:flavr/domain/models/food_suggestion.dart';
import 'package:flavr/domain/models/user_preferences.dart';

abstract interface class IFoodSuggestionRepository {
  /// Returns a list of food suggestions tailored to [preferences].
  ///
  /// [count] controls how many suggestions to request (default 5).
  /// [excludeNames] prevents repeating dishes the user has already seen.
  Future<List<FoodSuggestion>> getSuggestions({
    required UserPreferences preferences,
    int count = 5,
    List<String> excludeNames = const [],
  });
}
