import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_hub/core/services/shared_prefs_service.dart';

enum SplashState { initial, navigateToHome, navigateToSignIn, navigateToOnboarding }

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashState.initial);

  void checkNavigation() async {
    await Future.delayed(const Duration(seconds: 3));
    if (SharedPrefsService.isLoggedIn) {
      emit(SplashState.navigateToHome);
    } else if (SharedPrefsService.hasSeenOnboarding) {
      emit(SplashState.navigateToSignIn);
    } else {
      emit(SplashState.navigateToOnboarding);
    }
  }
}
