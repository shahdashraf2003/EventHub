import 'package:event_hub/core/widgets/events_list_tile.dart';
import 'package:event_hub/features/events/presentation/screens/empty_events_state.dart';
import 'package:event_hub/features/events/presentation/screens/event_tab_selector.dart';
import 'package:event_hub/features/home/presentation/screens/widgets/category_chip.dart';
import 'package:event_hub/models/category_model.dart';
import 'package:event_hub/models/event_model.dart';
import 'package:event_hub/services/ticketmaster_service.dart';
import 'package:flutter/material.dart';

final List<CategoryModel> filterCategories = [
  CategoryModel(label: 'Music', emoji: '🎵', color: const Color(0xFF5669FF)),
  CategoryModel(label: 'Art', emoji: '🎨', color: const Color(0xFF4CAF50)),
  CategoryModel(label: 'Food', emoji: '🍽️', color: const Color(0xFF2196F3)),
  CategoryModel(label: 'Tech', emoji: '💻', color: const Color(0xFF9C27B0)),
];

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final _service = TicketmasterService.instance;

  int _selectedTab = 0;
  List<EventModel> _events = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final events = await _service.getEvents(page: _selectedTab == 0 ? 0 : 2);
      if (mounted) setState(() { _events = events; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = 'Failed to load events.'; _loading = false; });
    }
  }

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: EventTabSelector(
              selectedIndex: _selectedTab,
              onTabChanged: (i) {
                setState(() => _selectedTab = i);
                _loadEvents();
              },
            ),
          ),

          // Category filter chips
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: CategoryChipList(
              categories: filterCategories,
              onSelected: (_) {},
            ),
          ),

          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF5669FF)),
      );
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, style: const TextStyle(color: Colors.redAccent)),
            const SizedBox(height: 12),
            TextButton(onPressed: _loadEvents, child: const Text('Retry')),
          ],
        ),
      );
    }
    if (_events.isEmpty) {
      return EmptyEventsState(onExplore: () {});
    }
    return RefreshIndicator(
      color: const Color(0xFF5669FF),
      onRefresh: _loadEvents,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _events.length,
        itemBuilder: (_, i) => EventListTile(
          event: _events[i],
          onTap: () {},
        ),
      ),
    );
  }
}