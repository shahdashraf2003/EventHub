import 'package:event_hub/core/app_colors.dart';
import 'package:event_hub/core/services/shared_prefs_service.dart';
import 'package:event_hub/features/authentication/presentation/screens/signin_screen.dart';
import 'package:event_hub/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:event_hub/features/profile/presentation/screens/widgets/about_tab_view.dart';
import 'package:event_hub/features/profile/presentation/screens/widgets/event_tab_view.dart';
import 'package:event_hub/features/profile/presentation/screens/widgets/profile_header.dart';
import 'package:event_hub/features/profile/presentation/screens/widgets/profile_tab_bar.dart';
import 'package:event_hub/features/profile/presentation/screens/widgets/reviews_tab_view.dart';
import 'package:event_hub/model/entities/event_model.dart';
import 'package:event_hub/model/entities/organizer_model.dart';
import 'package:event_hub/model/entities/review_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrganizerProfileScreen extends StatelessWidget {
  final OrganizerModel organizer;
  final List<EventModel> events;
  final List<ReviewModel> reviews;

  const OrganizerProfileScreen({
    super.key,
    required this.organizer,
    required this.events,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(),
      child: _ProfileView(
        organizer: organizer,
        events: events,
        reviews: reviews,
      ),
    );
  }
}

class _ProfileView extends StatelessWidget {
  final OrganizerModel organizer;
  final List<EventModel> events;
  final List<ReviewModel> reviews;

  const _ProfileView({
    required this.organizer,
    required this.events,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.textDark),
            onPressed: () async {
              await SharedPrefsService.setLoggedIn(false);
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: AppColors.white,
                  child: ProfileHeader(
                    organizer: organizer,
                    isFollowing: state.isFollowing,
                    onFollowTap: () => context.read<ProfileCubit>().toggleFollowing(),
                    onMessageTap: () {},
                  ),
                ),
                ProfileTabBar(
                  selectedIndex: state.tabIndex,
                  onTabChanged: (i) => context.read<ProfileCubit>().setTabIndex(i),
                ),
                const Divider(height: 1, color: Color(0xFFEEEEEE)),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: _buildTabContent(state.tabIndex),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabContent(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return AboutTabView(
          key: const ValueKey(0),
          organizer: organizer,
        );
      case 1:
        return EventTabView(
          key: const ValueKey(1),
          events: events,
        );
      case 2:
        return ReviewsTabView(
          key: const ValueKey(2),
          reviews: reviews,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
