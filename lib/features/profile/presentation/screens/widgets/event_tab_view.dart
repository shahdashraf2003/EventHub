import 'package:event_hub/features/event_details/presentation/screens/event_details_screen.dart';
import 'package:event_hub/core/widgets/events_list_tile.dart';
import 'package:event_hub/features/profile/presentation/cubit/saved_events_cubit.dart';
import 'package:event_hub/model/entities/event_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventTabView extends StatelessWidget {
  final List<EventModel> events;

  const EventTabView({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SavedEventsCubit(),
      child: const _EventTabViewContent(),
    );
  }
}

class _EventTabViewContent extends StatelessWidget {
  const _EventTabViewContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SavedEventsCubit, SavedEventsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Padding(
            padding: EdgeInsets.only(top: 40),
            child: Center(child: CircularProgressIndicator(color: Color(0xFF5669FF))),
          );
        }

        if (state.events.isEmpty) {
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
          itemCount: state.events.length,
          itemBuilder: (_, i) {
            final event = state.events[i];
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
                context.read<SavedEventsCubit>().removeEvent(event.id);
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
                    if (context.mounted) {
                      context.read<SavedEventsCubit>().loadSavedEvents();
                    }
                  });
                },
              ),
            );
          },
        );
      },
    );
  }
}
