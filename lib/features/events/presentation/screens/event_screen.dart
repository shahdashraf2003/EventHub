import 'package:event_hub/core/widgets/events_list_tile.dart';
import 'package:event_hub/features/event_details/presentation/screens/event_details_screen.dart';
import 'package:event_hub/features/events/presentation/cubit/events_cubit.dart';
import 'package:event_hub/features/events/presentation/screens/empty_events_state.dart';
import 'package:event_hub/features/events/presentation/screens/event_tab_selector.dart';
import 'package:event_hub/model/entities/category_model.dart';
import 'package:event_hub/model/repositories/ticketmaster_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventsScreen extends StatelessWidget {
  final CategoryModel? initialCategory;

  const EventsScreen({super.key, this.initialCategory});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventsCubit(
        context.read<TicketmasterRepository>(),
        initialCategory: initialCategory,
      ),
      child: const _EventsView(),
    );
  }
}

class _EventsView extends StatelessWidget {
  const _EventsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Color.fromARGB(47, 34, 34, 34)),
        title: const Text(
          'Events',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF222222),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.more_vert, color: Color(0xFF222222)),
          ),
        ],
      ),
      body: BlocBuilder<EventsCubit, EventsState>(
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: EventTabSelector(
                  selectedIndex: state.selectedTab,
                  onTabChanged: (i) {
                    context.read<EventsCubit>().selectTab(i);
                  },
                ),
              ),


              Expanded(child: _buildBody(context, state)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, EventsState state) {
    if (state.eventsStatus == EventsDataStatus.loading || state.eventsStatus == EventsDataStatus.initial) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF5669FF)),
      );
    }
    if (state.eventsStatus == EventsDataStatus.error && state.error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(state.error!, style: const TextStyle(color: Colors.redAccent)),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.read<EventsCubit>().loadEvents(), 
              child: const Text('Retry')
            ),
          ],
        ),
      );
    }
    if (state.events.isEmpty) {
      return EmptyEventsState(onExplore: () {});
    }
    return RefreshIndicator(
      color: const Color(0xFF5669FF),
      onRefresh: () => context.read<EventsCubit>().loadEvents(),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: state.events.length,
        itemBuilder: (_, i) => EventListTile(
          event: state.events[i],
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EventDetailsScreen(event: state.events[i]),
            ),
          ),
        ),
      ),
    );
  }
}