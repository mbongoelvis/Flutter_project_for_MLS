import 'package:flavr/core/utils/prompt_builder.dart';
import 'package:flavr/data/remote/gemini_food_remote_source.dart';
import 'package:flavr/domain/models/food_suggestion.dart';
import 'package:flavr/domain/models/user_preferences.dart';
import 'package:flavr/domain/repositories/i_food_suggestion_repository.dart';

class FoodSuggestionRepositoryImpl implements IFoodSuggestionRepository {
  final GeminiFoodRemoteSource _remoteSource;

  const FoodSuggestionRepositoryImpl(this._remoteSource);

  @override
  Future<List<FoodSuggestion>> getSuggestions({
    required UserPreferences preferences,
    int count = 5,
    List<String> excludeNames = const [],
  }) async {
    final prompt = PromptBuilder.build(
      preferences,
      excludeNames: excludeNames,
      count: count,
    );
    return _remoteSource.fetchSuggestions(prompt);
  }
}
