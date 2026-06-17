part of 'home_cubit.dart';

enum HomeDataStatus { initial, loading, loaded, error }

class HomeState {
  final List<CategoryModel> categories;
  final List<EventModel> upcomingEvents;
  final List<EventModel> nearbyEvents;
  final HomeDataStatus categoriesStatus;
  final HomeDataStatus eventsStatus;
  final String? error;
  final int selectedCategoryIndex;
  final int navIndex;

  const HomeState({
    required this.categories,
    required this.upcomingEvents,
    required this.nearbyEvents,
    required this.categoriesStatus,
    required this.eventsStatus,
    this.error,
    required this.selectedCategoryIndex,
    required this.navIndex,
  });

  factory HomeState.initial() {
    return const HomeState(
      categories: [],
      upcomingEvents: [],
      nearbyEvents: [],
      categoriesStatus: HomeDataStatus.initial,
      eventsStatus: HomeDataStatus.initial,
      selectedCategoryIndex: -1,
      navIndex: 0,
    );
  }

  HomeState copyWith({
    List<CategoryModel>? categories,
    List<EventModel>? upcomingEvents,
    List<EventModel>? nearbyEvents,
    HomeDataStatus? categoriesStatus,
    HomeDataStatus? eventsStatus,
    String? error,
    int? selectedCategoryIndex,
    int? navIndex,
  }) {
    return HomeState(
      categories: categories ?? this.categories,
      upcomingEvents: upcomingEvents ?? this.upcomingEvents,
      nearbyEvents: nearbyEvents ?? this.nearbyEvents,
      categoriesStatus: categoriesStatus ?? this.categoriesStatus,
      eventsStatus: eventsStatus ?? this.eventsStatus,
      error: error,
      selectedCategoryIndex: selectedCategoryIndex ?? this.selectedCategoryIndex,
      navIndex: navIndex ?? this.navIndex,
    );
  }
}
