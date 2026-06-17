import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_hub/core/services/shared_prefs_service.dart';

class OnboardingState {
  final int currentIndex;
  final bool isCompleted;

  const OnboardingState({
    this.currentIndex = 0,
    this.isCompleted = false,
  });

  OnboardingState copyWith({
    int? currentIndex,
    bool? isCompleted,
  }) {
    return OnboardingState(
      currentIndex: currentIndex ?? this.currentIndex,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingState());

  void setPageIndex(int index) {
    emit(state.copyWith(currentIndex: index));
  }

  Future<void> completeOnboarding() async {
    await SharedPrefsService.setHasSeenOnboarding(true);
    emit(state.copyWith(isCompleted: true));
  }
}
