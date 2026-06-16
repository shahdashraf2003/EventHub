import 'package:event_hub/core/database/database_helper.dart';
import 'package:event_hub/core/services/shared_prefs_service.dart';
import 'package:event_hub/features/event_details/presentation/screens/event_details_screen.dart';
import 'package:event_hub/core/widgets/events_list_tile.dart';
import 'package:event_hub/model/entities/event_model.dart';
import 'package:flutter/material.dart';

class EventTabView extends StatefulWidget {
  final List<EventModel> events;

  const EventTabView({super.key, required this.events});

  @override
  State<EventTabView> createState() => _EventTabViewState();
}

class _EventTabViewState extends State<EventTabView> {
  List<EventModel> _savedEvents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedEvents();
  }

  Future<void> _loadSavedEvents() async {
    final userId = SharedPrefsService.currentUserId;
    if (userId == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }
    final events = await DatabaseHelper.instance.getSavedEvents(userId);
    if (mounted) {
      setState(() {
        _savedEvents = events;
        _isLoading = false;
      });
    }
  }

  Future<void> _removeEvent(String eventId) async {
    final userId = SharedPrefsService.currentUserId;
    if (userId != null) {
      await DatabaseHelper.instance.removeEvent(eventId, userId);
      setState(() {
        _savedEvents.removeWhere((e) => e.id == eventId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.only(top: 40),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_savedEvents.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 40),
        child: Center(
          child: Text(
            'No saved events.',
            style: TextStyle(color: Color(0xFF888888), fontSize: 14),
          ),
        ),
      );
    }

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      itemCount: _savedEvents.length,
      itemBuilder: (_, i) {
        final event = _savedEvents[i];
        return Dismissible(
          key: Key(event.id),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.redAccent,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (direction) {
            _removeEvent(event.id);
            ScaffoldMessenger.of(context).showSnackBar(
               const SnackBar(content: Text('Event removed from saved list')),
            );
          },
          child: EventListTile(
            event: event,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EventDetailsScreen(event: event),
                ),
              ).then((_) {
                if (mounted) _loadSavedEvents(); 
              });
            },
          ),
        );
      },
    );
  }
}
