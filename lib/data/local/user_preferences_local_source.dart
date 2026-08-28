import 'package:hive_flutter/hive_flutter.dart';
import 'package:flavr/core/constants/hive_boxes.dart';
import 'package:flavr/core/errors/app_exception.dart';
import 'package:flavr/domain/models/user_preferences.dart';

class UserPreferencesLocalSource {
  Box<UserPreferences> get _box =>
      Hive.box<UserPreferences>(kPreferencesBox);

  /// Saves [preferences] to the Hive box, overwriting any previous entry.
  Future<void> save(UserPreferences preferences) async {
    try {
      await _box.put(kPrefsKey, preferences);
    } catch (e) {
      throw StorageException('Failed to save preferences: $e');
    }
  }

  /// Returns the stored [UserPreferences], or null if none have been saved.
  UserPreferences? load() {
    try {
      return _box.get(kPrefsKey);
    } catch (e) {
      return null;
    }
  }

  /// Removes the stored preferences entry.
  Future<void> clear() async {
    try {
      await _box.delete(kPrefsKey);
    } catch (e) {
      throw StorageException('Failed to clear preferences: $e');
    }
  }

  /// Synchronously checks whether onboarding has been completed.
  /// Safe to call during router redirect (box is already open).
  bool get hasCompleted {
    final prefs = _box.get(kPrefsKey);
    return prefs?.onboardingComplete ?? false;
  }
}
