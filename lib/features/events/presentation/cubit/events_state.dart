part of 'events_cubit.dart';

enum EventsDataStatus { initial, loading, loaded, error }

class EventsState {
  final List<CategoryModel> categories;
  final List<EventModel> events;
  final EventsDataStatus categoriesStatus;
  final EventsDataStatus eventsStatus;
  final String? error;
  final int selectedCategoryIndex;
  final int selectedTab;

  const EventsState({
    required this.categories,
    required this.events,
    required this.categoriesStatus,
    required this.eventsStatus,
    this.error,
    required this.selectedCategoryIndex,
    required this.selectedTab,
  });

  factory EventsState.initial() {
    return const EventsState(
      categories: [],
      events: [],
      categoriesStatus: EventsDataStatus.initial,
      eventsStatus: EventsDataStatus.initial,
      selectedCategoryIndex: -1,
      selectedTab: 0,
    );
  }

  EventsState copyWith({
    List<CategoryModel>? categories,
    List<EventModel>? events,
    EventsDataStatus? categoriesStatus,
    EventsDataStatus? eventsStatus,
    String? error,
    int? selectedCategoryIndex,
    int? selectedTab,
  }) {
    return EventsState(
      categories: categories ?? this.categories,
      events: events ?? this.events,
      categoriesStatus: categoriesStatus ?? this.categoriesStatus,
      eventsStatus: eventsStatus ?? this.eventsStatus,
      error: error,
      selectedCategoryIndex: selectedCategoryIndex ?? this.selectedCategoryIndex,
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }
}
