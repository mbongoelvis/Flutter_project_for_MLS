import 'package:flavr/domain/models/user_preferences.dart';

abstract interface class IPreferencesRepository {
  /// Loads the stored [UserPreferences], or null if none exist.
  Future<UserPreferences?> loadPreferences();

  /// Persists the given [preferences] to local storage.
  Future<void> savePreferences(UserPreferences preferences);

  /// Removes all stored preferences, resetting onboarding state.
  Future<void> clearPreferences();

  /// Returns true synchronously if onboarding has been completed.
  /// Safe to call at router redirect time (Hive box already open).
  bool get hasCompletedOnboarding;
}
