/// Optional filter state for the suggestions list.
class SuggestionsFilter {
  final String? cuisineFilter;
  final int? maxPrepTimeMinutes;
  final int? maxSpiceLevel;

  const SuggestionsFilter({
    this.cuisineFilter,
    this.maxPrepTimeMinutes,
    this.maxSpiceLevel,
  });

  SuggestionsFilter copyWith({
    String? cuisineFilter,
    int? maxPrepTimeMinutes,
    int? maxSpiceLevel,
    bool clearCuisine = false,
    bool clearPrepTime = false,
    bool clearSpice = false,
  }) {
    return SuggestionsFilter(
      cuisineFilter: clearCuisine ? null : (cuisineFilter ?? this.cuisineFilter),
      maxPrepTimeMinutes:
          clearPrepTime ? null : (maxPrepTimeMinutes ?? this.maxPrepTimeMinutes),
      maxSpiceLevel:
          clearSpice ? null : (maxSpiceLevel ?? this.maxSpiceLevel),
    );
  }

  bool get isActive =>
      cuisineFilter != null ||
      maxPrepTimeMinutes != null ||
      maxSpiceLevel != null;

  static const empty = SuggestionsFilter();
}
