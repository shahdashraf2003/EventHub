import 'package:event_hub/core/database/database_helper.dart';
import 'package:event_hub/core/services/shared_prefs_service.dart';
import 'package:event_hub/model/entities/event_model.dart';
import 'package:flutter/material.dart';

Widget _eventImage(
  String src, {
  double? height,
  double? width,
  BoxFit fit = BoxFit.cover,
}) {
  const placeholder = ColoredBox(color: Color(0xFFEEEEEE));
  if (src.startsWith('http')) {
    return Image.network(
      src,
      height: height,
      width: width,
      fit: fit,
      errorBuilder: (ctx, err, stack) =>
          SizedBox(height: height, width: width, child: placeholder),
      loadingBuilder: (ctx, child, progress) => progress == null
          ? child
          : SizedBox(height: height, width: width, child: placeholder),
    );
  }
  if (src.isNotEmpty) {
    return Image.asset(
      src,
      height: height,
      width: width,
      fit: fit,
      errorBuilder: (ctx, err, stack) =>
          SizedBox(height: height, width: width, child: placeholder),
    );
  }
  return SizedBox(height: height, width: width, child: placeholder);
}

class EventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback onTap;

  const EventCard({super.key, required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Stack(
                children: [
                  _eventImage(
                    event.coverImage,
                    height: 130,
                    width: double.infinity,
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Text(
                            event.day,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF5669FF),
                            ),
                          ),
                          Text(
                            event.month,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF888888),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Bookmark
                  Positioned(
                    top: 10,
                    right: 10,
                    child: _BookmarkIcon(event: event),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF222222),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _StackedAvatars(assets: event.goingAvatars),
                      const SizedBox(width: 6),
                      Text(
                        event.ticketPrice > 0
                            ? 'From \$${event.ticketPrice.toStringAsFixed(0)}'
                            : 'Free',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF666666),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 13,
                        color: Color(0xFF888888),
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          event.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF888888),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookmarkIcon extends StatefulWidget {
  final EventModel event;
  const _BookmarkIcon({required this.event});
  @override
  State<_BookmarkIcon> createState() => _BookmarkIconState();
}

class _BookmarkIconState extends State<_BookmarkIcon> {
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _checkSaved();
  }

  @override
  void didUpdateWidget(covariant _BookmarkIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    _checkSaved();
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
    return GestureDetector(
      onTap: _toggleSave,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          _isSaved ? Icons.bookmark : Icons.bookmark_border,
          size: 16,
          color: _isSaved ? const Color(0xFF5669FF) : const Color(0xFF888888),
        ),
      ),
    );
  }
}

class _StackedAvatars extends StatelessWidget {
  final List<String> assets;
  const _StackedAvatars({required this.assets});

  @override
  Widget build(BuildContext context) {
    final count = assets.length.clamp(0, 3);
    return SizedBox(
      width: count * 16.0 + 10,
      height: 22,
      child: Stack(
        children: List.generate(count, (i) {
          return Positioned(
            left: i * 14.0,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: CircleAvatar(
                radius: 10,
                backgroundImage: AssetImage(assets[i]),
                backgroundColor: const Color(0xFFDDDDDD),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class EventCardList extends StatelessWidget {
  final List<EventModel> events;
  final ValueChanged<EventModel> onEventTap;

  const EventCardList({
    super.key,
    required this.events,
    required this.onEventTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: events.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (_, i) =>
            EventCard(event: events[i], onTap: () => onEventTap(events[i])),
      ),
    );
  }
}
