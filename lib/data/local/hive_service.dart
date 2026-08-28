import 'package:hive_flutter/hive_flutter.dart';
import 'package:flavr/core/constants/hive_boxes.dart';
import 'package:flavr/domain/models/hive_adapters.dart';
import 'package:flavr/domain/models/user_preferences.dart';

class HiveService {
  HiveService._();

  static Future<void> init() async {
    await Hive.initFlutter();

    // Register all adapters (manual, replacing code-gen)
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserPreferencesAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(DietaryOptionAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(AllergyAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(CuisineTypeAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(HealthGoalAdapter());
    }
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(SpiceLevelAdapter());
    }

    // Open boxes
    await Hive.openBox<UserPreferences>(kPreferencesBox);
  }

  static Future<void> closeAll() async {
    await Hive.close();
  }
}
