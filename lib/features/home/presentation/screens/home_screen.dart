import 'package:event_hub/models/category_model.dart';
import 'package:event_hub/models/event_model.dart';
import 'package:flutter/material.dart';
import 'widgets/home_app_bar.dart';
import 'widgets/home_search_bar.dart';
import 'widgets/category_chip.dart';
import 'widgets/section_header.dart';
import 'widgets/event_card.dart';
import 'widgets/invite_friends_banner.dart';
import 'widgets/home_bottom_nav_bar.dart';



final List<EventModel> sampleUpcomingEvents = [
  EventModel(
    id: '1',
    title: 'International Band Mu...',
    day: '10',
    date: 'JUNE',
    location: '36 Guild Street London, UK',
    goingCount: 20,
    goingAvatars: [
      'assets/avatars/a1.png',
      'assets/avatars/a2.png',
      'assets/avatars/a3.png',
    ],
    coverImage: 'assets/images/upcoming1.png',
    time: '7:00 PM',
    address: '36 Guild Street London, UK',
    organizer: 'Event Organizer',
    organizerImage: 'assets/avatars/a1.png',
    about: 'International Band Music Event',
    ticketPrice: 50.0,
    description: 'Join us for an amazing international band performance.',
  ),
  EventModel(
    id: '2',
    title: 'Jo Malone',
    day: '10',
    date: 'JUNE',
    location: 'Radius Gal...',
    goingCount: 20,
    goingAvatars: [
      'assets/avatars/a1.png',
      'assets/avatars/a2.png',
    ],
    coverImage: 'assets/images/upcoming2.png',
    time: '8:00 PM',
    address: 'Radius Gallery',
    organizer: 'Gallery Host',
    organizerImage: 'assets/avatars/a2.png',
    about: 'Jo Malone Exhibition',
    ticketPrice: 30.0,
    description: 'Experience the Jo Malone exhibition.',
  ),
];

final List<CategoryModel> sampleCategories = [
  CategoryModel(label: 'Sports', emoji: '🏀', color: Color(0xFFFF6B6B)),
  CategoryModel(label: 'Music', emoji: '🎵', color: Color(0xFFFF9500)),
  CategoryModel(label: 'Food', emoji: '✖', color: Color(0xFF4CAF50)),
  CategoryModel(label: 'Art', emoji: '🎨', color: Color(0xFF5669FF)),
];
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      bottomNavigationBar: HomeBottomNavBar(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF5669FF),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 20,
              ),
              child: Column(
                children: [
                  HomeAppBar(
                    location: "New York, USA",
                    onMenuTap: () {},
                    onNotificationTap: () {},
                  ),
                  const SizedBox(height: 14),
                  HomeSearchBar(onFilterTap: () {}),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          SliverToBoxAdapter(
            child: CategoryChipList(
              categories: sampleCategories,
              onSelected: (_) {},
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          SliverToBoxAdapter(
            child: SectionHeader(
              title: "Upcoming Events",
              onSeeAll: () {},
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 14)),

          SliverToBoxAdapter(
            child: EventCardList(
              events: sampleUpcomingEvents,
              onEventTap: (event) {
                // Navigator.push to EventDetailsScreen
              },
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          SliverToBoxAdapter(
            child: InviteFriendsBanner(onInvite: () {}),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          SliverToBoxAdapter(
            child: SectionHeader(
              title: "Nearby You",
              onSeeAll: () {},
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }
}