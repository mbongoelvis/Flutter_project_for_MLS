enum DietaryOption {
  omnivore,
  vegetarian,
  vegan,
  pescatarian,
  keto,
  paleo,
  halal,
  kosher;

  String get displayName => switch (this) {
        omnivore => 'Omnivore',
        vegetarian => 'Vegetarian',
        vegan => 'Vegan',
        pescatarian => 'Pescatarian',
        keto => 'Keto',
        paleo => 'Paleo',
        halal => 'Halal',
        kosher => 'Kosher',
      };

  String get emoji => switch (this) {
        omnivore => '🍖',
        vegetarian => '🥦',
        vegan => '🌱',
        pescatarian => '🐟',
        keto => '🥑',
        paleo => '🦴',
        halal => '☪️',
        kosher => '✡️',
      };
}
