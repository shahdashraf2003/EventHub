import 'package:event_hub/core/database/database_helper.dart';
import 'package:event_hub/core/services/shared_prefs_service.dart';
import 'package:event_hub/model/entities/event_model.dart';
import 'package:flutter/material.dart';

class EventDetailsAppBar extends StatefulWidget {
  final EventModel event;

  const EventDetailsAppBar({
    super.key,
    required this.event,
  });

  @override
  State<EventDetailsAppBar> createState() => _EventDetailsAppBarState();
}

class _EventDetailsAppBarState extends State<EventDetailsAppBar> {
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _checkSaved();
  }

  @override
  void didUpdateWidget(covariant EventDetailsAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.event.id != widget.event.id) {
      _checkSaved();
    }
  }

  Future<void> _checkSaved() async {
    final userId = SharedPrefsService.currentUserId;
    if (userId == null) return;
    final saved = await DatabaseHelper.instance.isEventSaved(widget.event.id, userId);
    if (mounted && _isSaved != saved) setState(() => _isSaved = saved);
  }

  void _toggleSave() async {
    final userId = SharedPrefsService.currentUserId;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to save events')),
      );
      return;
    }
    if (_isSaved) {
      await DatabaseHelper.instance.removeEvent(widget.event.id, userId);
    } else {
      await DatabaseHelper.instance.saveEvent(widget.event, userId);
    }
    setState(() => _isSaved = !_isSaved);
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 260,
      pinned: true,
      backgroundColor: Colors.transparent,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.35),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.35),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: _toggleSave,
            icon: Icon(
              _isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: _isSaved ? const Color(0xFF5669FF) : Colors.white,
            ),
          ),
        ),
      ],
     
      flexibleSpace: FlexibleSpaceBar(
        background: Image.network(
          widget.event.coverImage,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}