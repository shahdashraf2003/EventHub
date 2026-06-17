import 'package:event_hub/core/database/database_helper.dart';
import 'package:event_hub/core/services/shared_prefs_service.dart';
import 'package:event_hub/model/entities/event_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SavedEventsState {
  final List<EventModel> events;
  final bool isLoading;

  const SavedEventsState({
    this.events = const [],
    this.isLoading = true,
  });

  SavedEventsState copyWith({
    List<EventModel>? events,
    bool? isLoading,
  }) {
    return SavedEventsState(
      events: events ?? this.events,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class SavedEventsCubit extends Cubit<SavedEventsState> {
  SavedEventsCubit() : super(const SavedEventsState()) {
    loadSavedEvents();
  }

  Future<void> loadSavedEvents() async {
    emit(state.copyWith(isLoading: true));
    final userId = SharedPrefsService.currentUserId;
    if (userId == null) {
      emit(state.copyWith(isLoading: false, events: []));
      return;
    }
    final events = await DatabaseHelper.instance.getSavedEvents(userId);
    emit(state.copyWith(isLoading: false, events: events));
  }

  Future<void> removeEvent(String eventId) async {
    final userId = SharedPrefsService.currentUserId;
    if (userId != null) {
      await DatabaseHelper.instance.removeEvent(eventId, userId);
      final newEvents = List<EventModel>.from(state.events)..removeWhere((e) => e.id == eventId);
      emit(state.copyWith(events: newEvents));
    }
  }
}
