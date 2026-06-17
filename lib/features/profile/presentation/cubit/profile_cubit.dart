import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileState {
  final int tabIndex;
  final bool isFollowing;

  const ProfileState({
    this.tabIndex = 0,
    this.isFollowing = false,
  });

  ProfileState copyWith({
    int? tabIndex,
    bool? isFollowing,
  }) {
    return ProfileState(
      tabIndex: tabIndex ?? this.tabIndex,
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }
}

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileState());

  void setTabIndex(int index) {
    emit(state.copyWith(tabIndex: index));
  }

  void toggleFollowing() {
    emit(state.copyWith(isFollowing: !state.isFollowing));
  }
}
