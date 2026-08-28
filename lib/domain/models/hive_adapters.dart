import 'package:hive_flutter/hive_flutter.dart';
import 'package:flavr/domain/models/dietary_option.dart';
import 'package:flavr/domain/models/allergy.dart';
import 'package:flavr/domain/models/cuisine_type.dart';
import 'package:flavr/domain/models/health_goal.dart';
import 'package:flavr/domain/models/spice_level.dart';
import 'package:flavr/domain/models/user_preferences.dart';

/// Manual TypeAdapter for [UserPreferences]. typeId: 0
class UserPreferencesAdapter extends TypeAdapter<UserPreferences> {
  @override
  final int typeId = 0;

  @override
  UserPreferences read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserPreferences(
      dietaryOptions:
          (fields[0] as List).cast<DietaryOption>(),
      allergies:
          (fields[1] as List).cast<Allergy>(),
      favoriteCuisines:
          (fields[2] as List).cast<CuisineType>(),
      healthGoal: fields[3] as HealthGoal,
      spiceLevel: fields[4] as SpiceLevel,
      mealComplexity: fields[5] as int,
      onboardingComplete: fields[6] as bool,
      lastUpdated: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, UserPreferences obj) {
    writer.writeByte(8);
    writer
      ..writeByte(0)
      ..write(obj.dietaryOptions)
      ..writeByte(1)
      ..write(obj.allergies)
      ..writeByte(2)
      ..write(obj.favoriteCuisines)
      ..writeByte(3)
      ..write(obj.healthGoal)
      ..writeByte(4)
      ..write(obj.spiceLevel)
      ..writeByte(5)
      ..write(obj.mealComplexity)
      ..writeByte(6)
      ..write(obj.onboardingComplete)
      ..writeByte(7)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserPreferencesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

/// Manual TypeAdapter for [DietaryOption] enum. typeId: 1
class DietaryOptionAdapter extends TypeAdapter<DietaryOption> {
  @override
  final int typeId = 1;

  @override
  DietaryOption read(BinaryReader reader) {
    return DietaryOption.values[reader.readByte()];
  }

  @override
  void write(BinaryWriter writer, DietaryOption obj) {
    writer.writeByte(obj.index);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DietaryOptionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

/// Manual TypeAdapter for [Allergy] enum. typeId: 2
class AllergyAdapter extends TypeAdapter<Allergy> {
  @override
  final int typeId = 2;

  @override
  Allergy read(BinaryReader reader) {
    return Allergy.values[reader.readByte()];
  }

  @override
  void write(BinaryWriter writer, Allergy obj) {
    writer.writeByte(obj.index);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AllergyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

/// Manual TypeAdapter for [CuisineType] enum. typeId: 3
class CuisineTypeAdapter extends TypeAdapter<CuisineType> {
  @override
  final int typeId = 3;

  @override
  CuisineType read(BinaryReader reader) {
    return CuisineType.values[reader.readByte()];
  }

  @override
  void write(BinaryWriter writer, CuisineType obj) {
    writer.writeByte(obj.index);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CuisineTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

/// Manual TypeAdapter for [HealthGoal] enum. typeId: 4
class HealthGoalAdapter extends TypeAdapter<HealthGoal> {
  @override
  final int typeId = 4;

  @override
  HealthGoal read(BinaryReader reader) {
    return HealthGoal.values[reader.readByte()];
  }

  @override
  void write(BinaryWriter writer, HealthGoal obj) {
    writer.writeByte(obj.index);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthGoalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

/// Manual TypeAdapter for [SpiceLevel] enum. typeId: 5
class SpiceLevelAdapter extends TypeAdapter<SpiceLevel> {
  @override
  final int typeId = 5;

  @override
  SpiceLevel read(BinaryReader reader) {
    return SpiceLevel.values[reader.readByte()];
  }

  @override
  void write(BinaryWriter writer, SpiceLevel obj) {
    writer.writeByte(obj.index);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpiceLevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
