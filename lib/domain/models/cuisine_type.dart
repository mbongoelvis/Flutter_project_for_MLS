enum CuisineType {
  italian,
  indian,
  japanese,
  mexican,
  mediterranean,
  thai,
  chinese,
  american,
  middleEastern,
  korean;

  String get displayName => switch (this) {
        italian => 'Italian',
        indian => 'Indian',
        japanese => 'Japanese',
        mexican => 'Mexican',
        mediterranean => 'Mediterranean',
        thai => 'Thai',
        chinese => 'Chinese',
        american => 'American',
        middleEastern => 'Middle Eastern',
        korean => 'Korean',
      };

  String get flagEmoji => switch (this) {
        italian => '🇮🇹',
        indian => '🇮🇳',
        japanese => '🇯🇵',
        mexican => '🇲🇽',
        mediterranean => '🌊',
        thai => '🇹🇭',
        chinese => '🇨🇳',
        american => '🇺🇸',
        middleEastern => '🌙',
        korean => '🇰🇷',
      };
}
