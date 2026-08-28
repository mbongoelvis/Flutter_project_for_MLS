import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/allergy.dart';
import '../../../domain/models/cuisine_type.dart';
import '../../../domain/models/dietary_option.dart';
import '../../../domain/models/health_goal.dart';
import '../../../domain/models/spice_level.dart';
import '../../../providers.dart';
import 'onboarding_state.dart';

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>(
  (ref) => OnboardingNotifier(ref),
);

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier(this._ref) : super(OnboardingState.initial());

  final Ref _ref;

  void setDietaryOptions(List<DietaryOption> options) {
    state = state.copyWith(
      draft: state.draft.copyWith(dietaryOptions: options),
      clearError: true,
    );
  }

  void setAllergies(List<Allergy> allergies) {
    state = state.copyWith(
      draft: state.draft.copyWith(allergies: allergies),
      clearError: true,
    );
  }

  void setFavoriteCuisines(List<CuisineType> cuisines) => setCuisines(cuisines);

  void setCuisines(List<CuisineType> cuisines) {
    state = state.copyWith(
      draft: state.draft.copyWith(favoriteCuisines: cuisines),
      clearError: true,
    );
  }

  void setHealthGoal(HealthGoal goal) {
    state = state.copyWith(
      draft: state.draft.copyWith(healthGoal: goal),
      clearError: true,
    );
  }

  void setSpiceLevel(SpiceLevel level) {
    state = state.copyWith(
      draft: state.draft.copyWith(spiceLevel: level),
      clearError: true,
    );
  }

  void setMealComplexity(int complexity) {
    state = state.copyWith(
      draft: state.draft.copyWith(mealComplexity: complexity),
      clearError: true,
    );
  }

  void nextStep() {
    if (state.currentStep < 5) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void goToStep(int step) {
    assert(step >= 0 && step <= 5);
    state = state.copyWith(currentStep: step);
  }

  void setCurrentStep(int step) => goToStep(step);

  Future<void> completeOnboarding() async {
    state = state.copyWith(isSaving: true, clearError: true);
    try {
      final prefs = state.draft.copyWith(
        onboardingComplete: true,
        lastUpdated: DateTime.now(),
      );
      await _ref.read(preferencesRepositoryProvider).savePreferences(prefs);
      state = state.copyWith(isSaving: false);
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'Failed to save preferences. Please try again.',
      );
    }
  }

  void resetOnboarding() {
    state = OnboardingState.initial();
  }

  Future<void> loadExistingPreferences() async {
    final prefs =
        await _ref.read(preferencesRepositoryProvider).loadPreferences();
    if (prefs != null) {
      state = state.copyWith(draft: prefs);
    }
  }
}
