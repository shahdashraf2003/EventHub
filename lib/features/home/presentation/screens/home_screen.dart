import 'package:event_hub/features/event_details/presentation/screens/event_details_screen.dart';
import 'package:event_hub/features/events/presentation/screens/event_screen.dart';
import 'package:event_hub/features/filter/pressentation/screens/filter_bottom_sheet.dart';
import 'package:event_hub/features/home/presentation/cubit/home_cubit.dart';
import 'package:event_hub/features/home/presentation/screens/widgets/category_chip.dart';
import 'package:event_hub/features/home/presentation/screens/widgets/event_card.dart';
import 'package:event_hub/features/home/presentation/screens/widgets/home_app_bar.dart';
import 'package:event_hub/features/home/presentation/screens/widgets/home_bottom_nav_bar.dart';
import 'package:event_hub/features/home/presentation/screens/widgets/home_search_bar.dart';
import 'package:event_hub/features/home/presentation/screens/widgets/invite_friends_banner.dart';
import 'package:event_hub/features/home/presentation/screens/widgets/section_header.dart';
import 'package:event_hub/features/profile/presentation/screens/organizer_profile_screen.dart';
import 'package:event_hub/features/search/presentation/screens/search_screen.dart' show SearchScreen;
import 'package:event_hub/model/entities/event_model.dart';
import 'package:event_hub/model/entities/organizer_model.dart';
import 'package:event_hub/model/entities/review_model.dart';
import 'package:event_hub/model/repositories/ticketmaster_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_hub/features/map/presentation/screens/map_screen.dart'; // We will create this

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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(
        context.read<TicketmasterRepository>(),
      )..loadInitialData(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  void _onCategorySelected(BuildContext context, int index) {
    final state = context.read<HomeCubit>().state;
    if (index >= 0 && index < state.categories.length) {
      final category = state.categories[index];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EventsScreen(initialCategory: category),
        ),
      );
    }
  }

  void _onNavTap(BuildContext context, int index) {
    final cubit = context.read<HomeCubit>();
    if (index == cubit.state.navIndex) return;

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
        ).then((_) => cubit.changeNavIndex(0));
        return;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MapScreen()),
        ).then((_) => cubit.changeNavIndex(0));
        return;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EventsScreen()),
        ).then((_) => cubit.changeNavIndex(0));
        return;
    }

    cubit.changeNavIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      bottomNavigationBar: BlocBuilder<HomeCubit, HomeState>(
        buildWhen: (p, c) => p.navIndex != c.navIndex,
        builder: (context, state) {
          return HomeBottomNavBar(
            currentIndex: state.navIndex,
            onTap: (index) => _onNavTap(context, index),
          );
        },
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return RefreshIndicator(
            color: const Color(0xFF5669FF),
            onRefresh: () async {
              context.read<HomeCubit>().refreshData();
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
                    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
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
                              context.read<HomeCubit>().loadEvents(classificationId: catId);
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
                  child: state.categoriesStatus == HomeDataStatus.loading
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
                          categories: state.categories,
                          selectedIndex: state.selectedCategoryIndex,
                          onSelected: (index) => _onCategorySelected(context, index),
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
                SliverToBoxAdapter(child: _buildUpcomingSection(context, state)),
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
                SliverToBoxAdapter(child: _buildNearbySection(context, state)),
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUpcomingSection(BuildContext context, HomeState state) {
    if (state.eventsStatus == HomeDataStatus.loading) {
      return const SizedBox(
        height: 240,
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFF5669FF)),
        ),
      );
    }
    if (state.error != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          state.error!,
          style: const TextStyle(color: Colors.redAccent, fontSize: 13),
        ),
      );
    }
    if (state.upcomingEvents.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          'No upcoming events found.',
          style: TextStyle(color: Color(0xFF888888), fontSize: 14),
        ),
      );
    }
    return EventCardList(
      events: state.upcomingEvents,
      onEventTap: (event) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EventDetailsScreen(event: event),
          ),
        );
      },
    );
  }

  Widget _buildNearbySection(BuildContext context, HomeState state) {
    if (state.eventsStatus == HomeDataStatus.loading) {
      return const SizedBox(
        height: 100,
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFF5669FF)),
        ),
      );
    }
    if (state.nearbyEvents.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          'No nearby events found.',
          style: TextStyle(color: Color(0xFF888888), fontSize: 14),
        ),
      );
    }
    return EventCardList(
      events: state.nearbyEvents,
      onEventTap: (event) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EventDetailsScreen(event: event),
          ),
        );
      },
    );
  }
}