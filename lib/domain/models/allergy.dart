enum Allergy {
  none,
  gluten,
  dairy,
  treeNuts,
  peanuts,
  soy,
  shellfish,
  eggs,
  sesame;

  String get displayName => switch (this) {
        none => 'No Restrictions',
        gluten => 'Gluten',
        dairy => 'Dairy',
        treeNuts => 'Tree Nuts',
        peanuts => 'Peanuts',
        soy => 'Soy',
        shellfish => 'Shellfish',
        eggs => 'Eggs',
        sesame => 'Sesame',
      };

  String get emoji => switch (this) {
        none => '✅',
        gluten => '🌾',
        dairy => '🥛',
        treeNuts => '🌰',
        peanuts => '🥜',
        soy => '🫘',
        shellfish => '🦐',
        eggs => '🥚',
        sesame => '🌿',
      };
}
