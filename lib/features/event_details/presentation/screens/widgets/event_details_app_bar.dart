import 'package:event_hub/features/events/models/event_model.dart';
import 'package:flutter/material.dart';

class EventDetailsAppBar extends StatelessWidget {
  final EventModel event;

  const EventDetailsAppBar({
    super.key,
    required this.event,
  });

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
            color: Colors.black.withOpacity(.35),
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
            color: Colors.black.withOpacity(.35),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.bookmark_border,
              color: Colors.white,
            ),
          ),
        ),
      ],
      title: const Text(
        "Event Details",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Image.asset(
          event.coverImage,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}