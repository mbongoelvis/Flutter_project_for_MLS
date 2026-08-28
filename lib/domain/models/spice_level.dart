enum SpiceLevel {
  none,
  mild,
  medium,
  hot,
  extraHot;

  int get value => index;

  String get label => switch (this) {
        none => 'No Spice',
        mild => 'Mild',
        medium => 'Medium',
        hot => 'Hot',
        extraHot => 'Extra Hot',
      };

  String get emoji => switch (this) {
        none => '😊',
        mild => '🌶️',
        medium => '🌶️🌶️',
        hot => '🌶️🌶️🌶️',
        extraHot => '🔥🔥🔥',
      };

  static SpiceLevel fromValue(int value) {
    return SpiceLevel.values[value.clamp(0, SpiceLevel.values.length - 1)];
  }
}
