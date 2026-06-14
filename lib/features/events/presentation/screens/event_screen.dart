import 'package:event_hub/core/widgets/events_list_tile.dart';
import 'package:event_hub/features/events/presentation/screens/empty_events_state.dart';
import 'package:event_hub/features/events/presentation/screens/event_tab_selector.dart';
import 'package:event_hub/models/event_model.dart';
import 'package:event_hub/models/category_model.dart';
import 'package:flutter/material.dart';
final List<EventModel> sampleSearchEvents = [
  EventModel(
    id: '1',
    title: 'A virtual evening of smooth jazz',
    date: '1ST MAY · SAT · 2:00 PM',
    location: 'Lot 13 · Oakland, CA',
   day: '', time: '', address: '', organizer:
    '', organizerImage: '',
     coverImage:'assets/images/upcoming1.png', about: '', ticketPrice: 9.5, goingCount: 5, goingAvatars: [], description: '',
  ),
  EventModel(
    id: '2',
    title: "Jo Malone London's Mother's Day",
    date: '1ST MAY · SAT · 2:00 PM',
    location: 'Radius Gallery · Santa Cruz, CA',
    day: '',
    time: '',
    address: '',
    organizer: '',
    organizerImage: '',
    coverImage: 'assets/images/upcoming2.png',
    about: '',
    goingAvatars: [],
    description: '', ticketPrice: 900, goingCount: 6,
  ),
  EventModel(
    id: '3',
    title: "Women's Leadership Conference",
    date: '1ST MAY · SAT · 2:00 PM',
    location: '53 Bush St · San Francisco, CA', day: '', time: '', address: '', organizer: '', organizerImage: '', coverImage: '', about: '', ticketPrice: 9, goingCount: 66, goingAvatars: [], description: '',
  ),
  EventModel(
    id: '4',
    title: 'International Kids Safe Parents Night Out',
    date: '1ST MAY · SAT · 2:00 PM',
    location: 'Lot 13 · Oakland, CA',
    day: '', time: '', address: '', organizer: '', organizerImage: '', coverImage: '', about: '', ticketPrice: 809, goingCount: 50, goingAvatars: [], description: '',
  ),
 
];
 
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
  int _selectedTab = 0;

  List<EventModel> get _currentEvents =>
      _selectedTab == 0 ? sampleSearchEvents : [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Color(0xFF222222)),
        title: const Text(
          "Events",
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
              onTabChanged: (i) => setState(() => _selectedTab = i),
            ),
          ),

          Expanded(
            child: _currentEvents.isEmpty
                ? EmptyEventsState(onExplore: () {})
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _currentEvents.length,
                    itemBuilder: (_, i) => EventListTile(
                      event: _currentEvents[i],
                      onTap: () {},
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}