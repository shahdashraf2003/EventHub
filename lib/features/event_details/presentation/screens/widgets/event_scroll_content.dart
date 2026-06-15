import 'package:event_hub/features/event_details/presentation/screens/widgets/event_details_app_bar.dart';
import 'package:event_hub/models/event_model.dart';
import 'package:event_hub/features/event_details/presentation/screens/widgets/going_avatars_row.dart';
import 'package:event_hub/features/events/presentation/screens/event_info_row.dart';
import 'package:flutter/material.dart';

class EventScrollContent extends StatelessWidget {
  final EventModel event;

  const EventScrollContent({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        EventDetailsAppBar(event: event),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GoingAvatarsRow(
                  avatarAssets: event.goingAvatars,
                  totalCount:  event.ticketPrice,
                  onInvite: () {},
                ),

                const SizedBox(height: 20),

                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 20),

                EventInfoRow(
                  icon: Icons.calendar_today_rounded,
                  iconBg: const Color(0xFFEEF0FF),
                  iconColor: const Color(0xFF5669FF),
                  title: event.date,
                  subtitle: "${event.day} • ${event.time}",
                ),

                const Divider(height: 28),

                EventInfoRow(
                  icon: Icons.location_on_outlined,
                  iconBg: const Color(0xFFFFEEEE),
                  iconColor: const Color(0xFFFF4D67),
                  title: event.location,
                  subtitle: event.address,
                ),

                const Divider(height: 28),

                EventInfoRow(
                  icon: Icons.person_outline,
                  iconBg: const Color(0xFFFFF3E0),
                  iconColor: const Color(0xFFFF9800),
                  title: event.organizer,
                  subtitle: "Organizer",
                  trailing: OutlinedButton(
                    onPressed: () {},
                    child: const Text("Follow"),
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  "About Event",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  event.about,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                    height: 1.65,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}