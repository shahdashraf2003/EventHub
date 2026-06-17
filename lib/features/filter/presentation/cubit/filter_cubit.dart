import 'package:event_hub/model/entities/category_model.dart';
import 'package:event_hub/model/repositories/ticketmaster_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'filter_state.dart';

class FilterCubit extends Cubit<FilterState> {
  final TicketmasterRepository _repository;

  FilterCubit(this._repository) : super(FilterState.initial()) {
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    emit(state.copyWith(isLoadingCategories: true));
    try {
      final categories = await _repository.getCategories();
      emit(state.copyWith(
        categories: categories,
        isLoadingCategories: false,
      ));
    } catch (_) {
      emit(state.copyWith(
        categories: [],
        isLoadingCategories: false,
      ));
    }
  }

  void selectCategory(int index) {
    emit(state.copyWith(selectedCategory: index));
  }

  void selectTime(int index) {
    emit(state.copyWith(selectedTime: index));
  }

  void setPriceRange(RangeValues range) {
    emit(state.copyWith(priceRange: range));
  }

  void reset() {
    emit(state.copyWith(
      selectedCategory: -1,
      selectedTime: 0,
      priceRange: const RangeValues(20, 120),
    ));
  }

  String? getSelectedClassificationId() {
    if (state.selectedCategory >= 0 && state.selectedCategory < state.categories.length) {
      return state.categories[state.selectedCategory].id;
    }
    return null;
  }
}
