import 'package:event_hub/model/entities/category_model.dart';
import 'package:event_hub/model/entities/event_model.dart';
import 'package:event_hub/model/repositories/ticketmaster_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final TicketmasterRepository _repository;

  HomeCubit(this._repository) : super(HomeState.initial());

  Future<void> loadInitialData() async {
    emit(state.copyWith(
      categoriesStatus: HomeDataStatus.loading,
      eventsStatus: HomeDataStatus.loading,
      error: null,
    ));

    try {
      final categories = await _repository.getCategories();
      emit(state.copyWith(
        categories: categories,
        categoriesStatus: HomeDataStatus.loaded,
      ));
    } catch (_) {
      emit(state.copyWith(
        categories: [],
        categoriesStatus: HomeDataStatus.loaded,
      ));
    }

    await loadEvents();
  }

  Future<void> loadEvents({String? classificationId}) async {
    emit(state.copyWith(
      eventsStatus: HomeDataStatus.loading,
      error: null,
    ));

    try {
      final upcoming = await _repository.getUpcomingEvents(
        classificationId: classificationId,
        page: 0,
      );
      final nearby = await _repository.getUpcomingEvents(
        classificationId: classificationId,
        page: 1,
      );
      
      emit(state.copyWith(
        upcomingEvents: upcoming,
        nearbyEvents: nearby,
        eventsStatus: HomeDataStatus.loaded,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: 'Could not load events. Check your connection.',
        eventsStatus: HomeDataStatus.error,
      ));
    }
  }

  void selectCategory(int index) {
    if (state.categories.isEmpty) return;
    
    if (index == state.selectedCategoryIndex) {
      emit(state.copyWith(selectedCategoryIndex: -1));
      loadEvents();
    } else {
      emit(state.copyWith(selectedCategoryIndex: index));
      final catId = state.categories[index].id;
      loadEvents(classificationId: catId);
    }
  }

  void changeNavIndex(int index) {
    emit(state.copyWith(navIndex: index));
  }

  void refreshData() async {
    await loadInitialData();
  }
}
