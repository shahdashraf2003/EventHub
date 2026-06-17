import 'package:event_hub/model/entities/event_model.dart';
import 'package:event_hub/model/repositories/ticketmaster_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final TicketmasterRepository _repository;
  Timer? _debounce;

  SearchCubit(this._repository) : super(SearchState.initial()) {
    _browseFeatured();
  }

  Future<void> _browseFeatured() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final results = await _repository.getUpcomingEvents(
        city: 'New York',
        classificationId: state.selectedClassificationId,
      );
      emit(state.copyWith(
        results: results,
        isLoading: false,
        hasSearched: true,
      ));
    } catch (_) {
      emit(state.copyWith(
        error: 'Could not load events.',
        isLoading: false,
      ));
    }
  }

  void searchByKeyword(String keyword) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), () async {
      emit(state.copyWith(isLoading: true, error: null, query: keyword));
      try {
        final results = keyword.isEmpty
            ? await _repository.getUpcomingEvents(
                city: 'New York',
                classificationId: state.selectedClassificationId,
              )
            : await _repository.searchByKeyword(
                keyword: keyword,
              );

        emit(state.copyWith(
          results: results,
          isLoading: false,
          hasSearched: true,
        ));
      } catch (e) {
        emit(state.copyWith(
          error: 'Search failed. Please try again.',
          isLoading: false,
        ));
      }
    });
  }

  void applyFilter(String? classificationId) {
    emit(state.copyWith(selectedClassificationId: classificationId));
    searchByKeyword(state.query);
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
