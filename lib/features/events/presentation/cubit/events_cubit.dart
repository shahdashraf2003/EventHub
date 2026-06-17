import 'package:event_hub/model/entities/category_model.dart';
import 'package:event_hub/model/entities/event_model.dart';
import 'package:event_hub/model/repositories/ticketmaster_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'events_state.dart';

class EventsCubit extends Cubit<EventsState> {
  final TicketmasterRepository _repository;

  EventsCubit(this._repository, {CategoryModel? initialCategory})
      : super(EventsState.initial()) {
    if (initialCategory != null) {
      _loadInitialDataWithCategory(initialCategory);
    } else {
      _loadInitialData();
    }
  }

  Future<void> _loadInitialDataWithCategory(CategoryModel category) async {
    emit(state.copyWith(
      categoriesStatus: EventsDataStatus.loading,
      eventsStatus: EventsDataStatus.loading,
      error: null,
    ));

    try {
      final categories = await _repository.getCategories();
      final selectedIndex = categories.indexWhere((c) => c.id == category.id);
      emit(state.copyWith(
        categories: categories,
        selectedCategoryIndex: selectedIndex,
        categoriesStatus: EventsDataStatus.loaded,
      ));
    } catch (_) {
      emit(state.copyWith(
        categories: [category],
        selectedCategoryIndex: 0,
        categoriesStatus: EventsDataStatus.loaded,
      ));
    }

    await loadEvents();
  }

  Future<void> _loadInitialData() async {
    emit(state.copyWith(
      categoriesStatus: EventsDataStatus.loading,
      eventsStatus: EventsDataStatus.loading,
      error: null,
    ));

    try {
      final categories = await _repository.getCategories();
      emit(state.copyWith(
        categories: categories,
        categoriesStatus: EventsDataStatus.loaded,
      ));
    } catch (_) {
      emit(state.copyWith(
        categories: [],
        categoriesStatus: EventsDataStatus.loaded,
      ));
    }

    await loadEvents();
  }

  Future<void> loadEvents() async {
    emit(state.copyWith(
      eventsStatus: EventsDataStatus.loading,
      error: null,
    ));

    try {
      final List<EventModel> events;
      String? classificationId;
      if (state.selectedCategoryIndex >= 0 && state.selectedCategoryIndex < state.categories.length) {
        classificationId = state.categories[state.selectedCategoryIndex].id;
      }

      if (state.selectedTab == 0) {
        events = await _repository.getUpcomingEvents(
          classificationId: classificationId,
          page: 0,
        );
      } else {
        events = await _repository.getPastEvents(
          classificationId: classificationId,
        );
      }

      emit(state.copyWith(
        events: events,
        eventsStatus: EventsDataStatus.loaded,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: 'Failed to load events. Tap retry.',
        eventsStatus: EventsDataStatus.error,
      ));
    }
  }

  void selectTab(int index) {
    if (index == state.selectedTab) return;
    emit(state.copyWith(selectedTab: index));
    loadEvents();
  }

  void selectCategory(int index) {
    if (state.categories.isEmpty) return;
    
    if (index == state.selectedCategoryIndex) {
      emit(state.copyWith(selectedCategoryIndex: -1));
      loadEvents();
    } else {
      emit(state.copyWith(selectedCategoryIndex: index));
      loadEvents();
    }
  }
}
