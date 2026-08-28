import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flavr/domain/models/food_suggestion.dart';
import 'package:flavr/providers.dart';

final suggestionsProvider =
    AsyncNotifierProvider<SuggestionsNotifier, List<FoodSuggestion>>(
  SuggestionsNotifier.new,
);

class SuggestionsNotifier extends AsyncNotifier<List<FoodSuggestion>> {
  @override
  Future<List<FoodSuggestion>> build() async {
    final prefs =
        await ref.read(preferencesRepositoryProvider).loadPreferences();
    if (prefs == null) return [];
    return ref
        .read(foodSuggestionRepositoryProvider)
        .getSuggestions(preferences: prefs);
  }

  Future<void> regenerate() async {
    final previous = state.valueOrNull ?? [];
    final excludeNames = previous.map((s) => s.name).toList();

    state = const AsyncLoading();
    final prefs =
        await ref.read(preferencesRepositoryProvider).loadPreferences();
    if (prefs == null) {
      state = const AsyncData([]);
      return;
    }

    state = await AsyncValue.guard(() => ref
        .read(foodSuggestionRepositoryProvider)
        .getSuggestions(preferences: prefs, excludeNames: excludeNames));
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull ?? [];
    if (current.isEmpty) return;

    final prefs =
        await ref.read(preferencesRepositoryProvider).loadPreferences();
    if (prefs == null) return;

    final excludeNames = current.map((s) => s.name).toList();
    final more = await ref
        .read(foodSuggestionRepositoryProvider)
        .getSuggestions(preferences: prefs, excludeNames: excludeNames);

    state = AsyncData([...current, ...more]);
  }
}
