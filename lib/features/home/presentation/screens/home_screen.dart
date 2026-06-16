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
import 'package:event_hub/features/search/presentation/screens/search_screen.dart'
    show SearchScreen;
import 'package:event_hub/model/entities/category_model.dart';
import 'package:event_hub/model/entities/event_model.dart';
import 'package:event_hub/model/entities/organizer_model.dart';
import 'package:event_hub/model/entities/review_model.dart';
import 'package:event_hub/model/network/ticketmaster_service.dart';
import 'package:flutter/material.dart';

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
    month: 'MAY',
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
    description: '',
    ticketPrice: 0,
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

  final _service = TicketmasterService.instance;

  final String _city = 'New York';

  List<CategoryModel> _categories = [];
  List<EventModel> _upcomingEvents = [];
  List<EventModel> _nearbyEvents = [];
  bool _loadingCategories = true;
  bool _loadingEvents = true;
  String? _eventsError;
  int _selectedCategoryIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadEvents();
  }

  Future<void> _loadCategories() async {
    try {
      final cats = await _service.getCategories();
      if (mounted) {
        setState(() {
          _categories = cats.isEmpty ? [] : cats;
          _loadingCategories = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _categories = [];
          _loadingCategories = false;
        });
      }
    }
  }

  Future<void> _loadEvents({String? classificationId}) async {
    setState(() {
      _loadingEvents = true;
      _eventsError = null;
    });
    try {
      final upcoming = await _service.getUpcomingEvents(
        city: _city,
        page: 0,
        classificationId: classificationId,
      );
      final nearby = await _service.getUpcomingEvents(
        city: _city,
        page: 1,
        classificationId: classificationId,
      );
      if (mounted) {
        setState(() {
          _upcomingEvents = upcoming;
          _nearbyEvents   = nearby;
          _loadingEvents  = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _eventsError   = 'Could not load events. Check your connection.';
          _loadingEvents = false;
        });
      }
    }
  }

  void _onCategorySelected(int index) {
      final catId = _categories[index].id;
  print('DEBUG category selected: name=${_categories[index].label}, id=$catId');

  if (index == _selectedCategoryIndex) {
    setState(() => _selectedCategoryIndex = -1);
   _loadEvents(classificationId: null);
  } else {
    setState(() => _selectedCategoryIndex = index);
    final catId = (index >= 0 && index < _categories.length)
        ? _categories[index].id
        : null;
    _loadEvents(
      classificationId: (catId != null && catId.isNotEmpty) ? catId : null,
    );
  }
}

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
      body: RefreshIndicator(
        color: const Color(0xFF5669FF),
        onRefresh: () async {
          await Future.wait([_loadCategories(), _loadEvents()]);
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                padding:
                    const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: Column(
                  children: [
                    HomeAppBar(
                      location: 'New York, USA',
                      onMenuTap: () {},
                      onNotificationTap: () {},
                    ),
                    const SizedBox(height: 14),
                    HomeSearchBar(
                      onFilterTap: () async {
                        final catId = await FilterBottomSheet.show(context);
                        if (catId != null) {
                          final idx = _categories.indexWhere((c) => c.id == catId);
                          if (idx >= 0 && idx != _selectedCategoryIndex) {
                            setState(() => _selectedCategoryIndex = idx);
                            _loadEvents(classificationId: catId);
                          }
                        }
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
              child: _loadingCategories
                  ? const SizedBox(
                      height: 42,
                      child: Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF5669FF),
                          ),
                        ),
                      ),
                    )
                  : CategoryChipList(
                      categories: _categories,
                      selectedIndex: _selectedCategoryIndex,
                      onSelected: _onCategorySelected,
                    ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            SliverToBoxAdapter(
              child: SectionHeader(
                title: 'Upcoming Events',
                onSeeAll: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EventsScreen()),
                  );
                },
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 14)),

            SliverToBoxAdapter(child: _buildUpcomingSection()),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            SliverToBoxAdapter(
              child: InviteFriendsBanner(onInvite: () {}),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            SliverToBoxAdapter(
              child: SectionHeader(
                title: 'Nearby You',
                onSeeAll: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EventsScreen()),
                  );
                },
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 14)),

            SliverToBoxAdapter(child: _buildNearbySection()),

            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingSection() {
    if (_loadingEvents) {
      return const SizedBox(
        height: 240,
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFF5669FF)),
        ),
      );
    }
    if (_eventsError != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          _eventsError!,
          style: const TextStyle(color: Colors.redAccent, fontSize: 13),
        ),
      );
    }
    if (_upcomingEvents.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          'No upcoming events found.',
          style: TextStyle(color: Color(0xFF888888), fontSize: 14),
        ),
      );
    }
    return EventCardList(
      events: _upcomingEvents,
      onEventTap: (event) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EventDetailsScreen(event: event),
          ),
        ).then((_) {
          if (mounted) setState(() {});
        });
      },
    );
  }

  Widget _buildNearbySection() {
    if (_loadingEvents) {
      return const SizedBox(
        height: 100,
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFF5669FF)),
        ),
      );
    }
    if (_nearbyEvents.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          'No nearby events found.',
          style: TextStyle(color: Color(0xFF888888), fontSize: 14),
        ),
      );
    }
    return EventCardList(
      events: _nearbyEvents,
      onEventTap: (event) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EventDetailsScreen(event: event),
          ),
        ).then((_) {
          if (mounted) setState(() {});
        });
      },
    );
  }
}