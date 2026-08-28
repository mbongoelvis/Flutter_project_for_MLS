// Top-level constants (idiomatic Flutter k-prefix style)
const String kAppName = 'Flavr';
const int kSuggestionCount = 5;
const int kMaxCuisineSelections = 5;
const int kOnboardingSteps = 6;

// Class-based access (also kept for explicit qualified usage)
abstract final class AppConstants {
  static const String appName = kAppName;
  static const int suggestionCount = kSuggestionCount;
  static const int maxCuisineSelections = kMaxCuisineSelections;
  static const int onboardingSteps = kOnboardingSteps;
}
