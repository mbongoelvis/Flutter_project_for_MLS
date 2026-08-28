import 'package:flavr/data/local/user_preferences_local_source.dart';
import 'package:flavr/domain/models/user_preferences.dart';
import 'package:flavr/domain/repositories/i_preferences_repository.dart';

class PreferencesRepositoryImpl implements IPreferencesRepository {
  final UserPreferencesLocalSource _localSource;

  const PreferencesRepositoryImpl(this._localSource);

  @override
  Future<UserPreferences?> loadPreferences() async {
    return _localSource.load();
  }

  @override
  Future<void> savePreferences(UserPreferences preferences) async {
    await _localSource.save(preferences);
  }

  @override
  Future<void> clearPreferences() async {
    await _localSource.clear();
  }

  @override
  bool get hasCompletedOnboarding => _localSource.hasCompleted;
}
