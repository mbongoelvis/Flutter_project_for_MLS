import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flavr/data/local/user_preferences_local_source.dart';
import 'package:flavr/data/remote/gemini_client.dart';
import 'package:flavr/data/remote/gemini_food_remote_source.dart';
import 'package:flavr/data/repositories/food_suggestion_repository_impl.dart';
import 'package:flavr/data/repositories/preferences_repository_impl.dart';
import 'package:flavr/domain/repositories/i_food_suggestion_repository.dart';
import 'package:flavr/domain/repositories/i_preferences_repository.dart';

/// Provides the [UserPreferencesLocalSource] for raw Hive box access.
/// The underlying box must have been opened by [HiveService.init()] at startup.
final userPrefsLocalSourceProvider = Provider<UserPreferencesLocalSource>(
  (ref) => UserPreferencesLocalSource(),
);

/// Provides the [GeminiClient] configured with the API key from .env.
final geminiClientProvider = Provider<GeminiClient>(
  (ref) => GeminiClient(),
);

/// Provides the [GeminiFoodRemoteSource] backed by [GeminiClient].
final geminiFoodRemoteSourceProvider = Provider<GeminiFoodRemoteSource>(
  (ref) => GeminiFoodRemoteSource(ref.watch(geminiClientProvider)),
);

/// Provides the [IPreferencesRepository] implementation.
final preferencesRepositoryProvider = Provider<IPreferencesRepository>(
  (ref) => PreferencesRepositoryImpl(ref.watch(userPrefsLocalSourceProvider)),
);

/// Provides the [IFoodSuggestionRepository] implementation.
final foodSuggestionRepositoryProvider = Provider<IFoodSuggestionRepository>(
  (ref) => FoodSuggestionRepositoryImpl(
    ref.watch(geminiFoodRemoteSourceProvider),
  ),
);
