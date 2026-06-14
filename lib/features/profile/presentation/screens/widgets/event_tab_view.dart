import 'package:event_hub/core/widgets/events_list_tile.dart';
import 'package:event_hub/models/event_model.dart';
import 'package:flutter/material.dart';

class EventTabView extends StatelessWidget {
  final List<EventModel> events;

  const EventTabView({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      itemCount: events.length,
      itemBuilder: (_, i) => EventListTile(
        event: events[i],
        onTap: () {},
      ),
    );
  }
}
