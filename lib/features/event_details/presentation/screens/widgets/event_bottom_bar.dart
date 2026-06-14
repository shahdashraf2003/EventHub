import 'package:event_hub/core/widgets/blue_primary_button.dart';
import 'package:event_hub/models/event_model.dart';
import 'package:flutter/material.dart';

class EventBottomBar extends StatelessWidget {
  final EventModel event;

  const EventBottomBar({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        child: BluePrimaryButton(
          label:
              "BUY TICKET \$${event.ticketPrice.toStringAsFixed(0)}",
          onPressed: () {},
        ),
      ),
    );
  }
}