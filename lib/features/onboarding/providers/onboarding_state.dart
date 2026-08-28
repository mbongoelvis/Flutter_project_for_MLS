import 'package:flavr/domain/models/user_preferences.dart';

class OnboardingState {
  /// Current step index (0-based). Steps 0-5 correspond to screens 1-6.
  final int currentStep;

  /// The in-progress draft preferences being built across steps.
  final UserPreferences draft;

  /// True while the final save is in progress.
  final bool isSaving;

  /// Non-null when a save error occurred.
  final String? errorMessage;

  OnboardingState({
    required this.currentStep,
    required this.draft,
    this.isSaving = false,
    this.errorMessage,
  });

  factory OnboardingState.initial() => OnboardingState(
        currentStep: 0,
        draft: UserPreferences.empty(),
      );

  OnboardingState copyWith({
    int? currentStep,
    UserPreferences? draft,
    bool? isSaving,
    String? errorMessage,
    bool clearError = false,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      draft: draft ?? this.draft,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  String toString() =>
      'OnboardingState(step: $currentStep, saving: $isSaving, error: $errorMessage)';
}
