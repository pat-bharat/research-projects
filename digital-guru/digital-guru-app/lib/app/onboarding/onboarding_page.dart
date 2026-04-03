import 'package:digital_guru_app/app/common/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:digital_guru_app/app/onboarding/onboarding_view_model.dart';

class OnboardingPage extends ConsumerWidget {
  Future<void> onGetStarted(BuildContext context, WidgetRef ref) async {
    final onboardingViewModel = ref.read(onboardingViewModelProvider.notifier);
    await onboardingViewModel.completeOnboarding();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Learn something new.\nBecause knowledge is the power.',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            FractionallySizedBox(
              widthFactor: 0.5,
              child: Image.asset('assets/lms_home.png'),
            ),
            CustomButton(
              label: 'Get Started',
              onPressed: () => onGetStarted(context, ref),
              color: Colors.indigo,
              borderRadius: 30,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
