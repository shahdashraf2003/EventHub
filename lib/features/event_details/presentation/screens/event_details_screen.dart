import 'package:event_hub/features/event_details/presentation/screens/widgets/event_bottom_bar.dart';
import 'package:event_hub/features/event_details/presentation/screens/widgets/event_scroll_content.dart';
import 'package:event_hub/models/event_model.dart';
import 'package:flutter/material.dart';

class EventDetailsScreen extends StatelessWidget {
  final EventModel event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          EventScrollContent(event: event),
          EventBottomBar(event: event),
        ],
      ),
    );
  }
}