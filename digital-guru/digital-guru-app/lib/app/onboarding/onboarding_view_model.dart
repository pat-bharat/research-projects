import 'package:digital_guru_app/app/common/service/shared_preferences_service.dart';
import 'package:flutter_riverpod/legacy.dart';

final onboardingViewModelProvider =
    StateNotifierProvider<OnboardingViewModel, bool>((ref) {
  final sharedPreferencesService = ref.watch(sharedPreferencesServiceProvider);
  return OnboardingViewModel(sharedPreferencesService);
});

class OnboardingViewModel extends StateNotifier<bool> {
  OnboardingViewModel(this.sharedPreferencesService)
      : super(sharedPreferencesService.isOnboardingComplete());
  final SharedPreferencesService sharedPreferencesService;

  Future<void> completeOnboarding() async {
    await sharedPreferencesService.setOnboardingComplete();
    state = true;
  }

  bool get isOnboardingComplete => state;
}
