import 'package:event_hub/core/database/database_helper.dart';
import 'package:event_hub/core/services/shared_prefs_service.dart';
import 'package:event_hub/model/entities/event_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookmarkCubit extends Cubit<bool> {
  final EventModel event;

  BookmarkCubit(this.event) : super(false) {
    checkSaved();
  }

  Future<void> checkSaved() async {
    final userId = SharedPrefsService.currentUserId;
    if (userId == null) return;
    final saved = await DatabaseHelper.instance.isEventSaved(event.id, userId);
    emit(saved);
  }

  Future<void> toggleSave() async {
    final userId = SharedPrefsService.currentUserId;
    if (userId == null) {
      return; 
    }
    if (state) {
      await DatabaseHelper.instance.removeEvent(event.id, userId);
    } else {
      await DatabaseHelper.instance.saveEvent(event, userId);
    }
    emit(!state);
  }
}
