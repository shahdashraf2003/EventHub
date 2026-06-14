import 'package:event_hub/features/event_details/presentation/screens/event_details_screen.dart';
import 'package:event_hub/features/events/presentation/screens/event_screen.dart';
import 'package:event_hub/features/filter/pressentation/screens/filter_bottom_sheet.dart';
import 'package:event_hub/features/home/presentation/screens/widgets/category_chip.dart';
import 'package:event_hub/features/home/presentation/screens/widgets/event_card.dart';
import 'package:event_hub/features/home/presentation/screens/widgets/home_app_bar.dart';
import 'package:event_hub/features/home/presentation/screens/widgets/home_bottom_nav_bar.dart';
import 'package:event_hub/features/home/presentation/screens/widgets/home_search_bar.dart';
import 'package:event_hub/features/home/presentation/screens/widgets/invite_friends_banner.dart';
import 'package:event_hub/features/home/presentation/screens/widgets/section_header.dart';
import 'package:event_hub/features/profile/presentation/screens/organizer_profile_screen.dart';
import 'package:event_hub/features/search/presentation/screens/search_screen.dart' show SearchScreen;
import 'package:event_hub/models/category_model.dart';
import 'package:event_hub/models/event_model.dart';
import 'package:event_hub/models/organizer_model.dart';
import 'package:event_hub/models/review_model.dart';
import 'package:flutter/material.dart';

final List<EventModel> sampleUpcomingEvents = [
  EventModel(
    id: '1',
    title: 'International Band Mu...',
    day: '10',
    date: 'JUNE',
    location: '36 Guild Street London, UK',
    goingCount: 20,
    goingAvatars: [],
    coverImage: 'assets/images/upcoming1.png',
    time: '7:00 PM',
    address: '36 Guild Street London, UK',
    organizer: 'Event Organizer',
    organizerImage: '',
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
    goingAvatars: [],
    coverImage: 'assets/images/upcoming2.png',
    time: '8:00 PM',
    address: 'Radius Gallery',
    organizer: 'Gallery Host',
    organizerImage: '',
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

const _organizer = OrganizerModel(
  name: 'David Silbia',
  avatar: 'assets/images/organizer_avatar.png',
  following: 350,
  followers: 346,
  about:
      'Enjoy your favourite dishes and a lovely time with friends and family. '
      'Food from local food trucks will be available for purchase.',
);

const _profileEvents = [
  EventModel(
    id: 'p1',
    title: 'A virtual evening of smooth jazz',
    day: '1',
    date: '1ST MAY • SAT • 2:00 PM',
    location: 'Jazz Hall, New York',
    goingCount: 0,
    goingAvatars: [],
    coverImage: 'assets/images/event_jazz.png',
    time: '2:00 PM',
    address: 'Jazz Hall, New York',
    organizer: 'David Silbia',
    organizerImage: '',
    about: '',
    ticketPrice: 0,
    description: '',
  ),
];

const _profileReviews = [
  ReviewModel(
    reviewerName: 'Rocks Velkeinjen',
    reviewerAvatar: 'assets/images/reviewer1.png',
    rating: 4,
    comment: 'Cinemas is the ultimate experience to see new movies.',
    date: '10 Feb',
  ),
  ReviewModel(
    reviewerName: 'Angelina Zolly',
    reviewerAvatar: 'assets/images/reviewer2.png',
    rating: 3,
    comment: 'Amazing organizer! Highly recommend their events.',
    date: '10 Feb',
  ),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;

  void _onNavTap(int index) {
    if (index == _navIndex) return;

    switch (index) {
      case 3: 
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OrganizerProfileScreen(
              organizer: _organizer,
              events: _profileEvents,
              reviews: _profileReviews,
            ),
          ),
        ).then((_) => setState(() => _navIndex = 0));
        return;

      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EventsScreen()),
        ).then((_) => setState(() => _navIndex = 0));
        return;

    }

    setState(() => _navIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      bottomNavigationBar: HomeBottomNavBar(
        currentIndex: _navIndex,
        onTap: _onNavTap,
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
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Column(
                children: [
                  HomeAppBar(
                    location: "New York, USA",
                    onMenuTap: () {},
                    onNotificationTap: () {},
                  ),
                  const SizedBox(height: 14),
                  HomeSearchBar(
                    onFilterTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const FilterBottomSheet(),
                        ),
                      );
                    },
                    onChanged: (value) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SearchScreen(),
                        ),
                      );
                    },
                  ),
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
              onSeeAll: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EventsScreen()),
                );
              },
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 14)),

          SliverToBoxAdapter(
            child: EventCardList(
              events: sampleUpcomingEvents,
              onEventTap: (event) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EventDetailsScreen(event: event),
                  ),
                );
              },
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          SliverToBoxAdapter(
            child: InviteFriendsBanner(onInvite: () {}),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          SliverToBoxAdapter(
            child: SectionHeader(title: "Nearby You", onSeeAll: () {}),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }
}