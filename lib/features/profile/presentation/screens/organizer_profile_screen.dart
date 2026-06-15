
import 'package:event_hub/core/app_colors.dart';
import 'package:event_hub/features/profile/presentation/screens/widgets/about_tab_view.dart';
import 'package:event_hub/features/profile/presentation/screens/widgets/event_tab_view.dart';
import 'package:event_hub/features/profile/presentation/screens/widgets/profile_header.dart';
import 'package:event_hub/features/profile/presentation/screens/widgets/profile_tab_bar.dart';
import 'package:event_hub/features/profile/presentation/screens/widgets/reviews_tab_view.dart';
import 'package:event_hub/model/entities/event_model.dart';
import 'package:event_hub/model/entities/organizer_model.dart';
import 'package:event_hub/model/entities/review_model.dart';
import 'package:flutter/material.dart';

class OrganizerProfileScreen extends StatefulWidget {
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
  State<OrganizerProfileScreen> createState() =>
      _OrganizerProfileScreenState();
}

class _OrganizerProfileScreenState extends State<OrganizerProfileScreen> {
  int _tabIndex = 0;
  bool _isFollowing = false;

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
            icon: const Icon(Icons.more_vert, color: AppColors.textDark),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: AppColors.white,
              child: ProfileHeader(
                organizer: widget.organizer,
                isFollowing: _isFollowing,
                onFollowTap: () =>
                    setState(() => _isFollowing = !_isFollowing),
                onMessageTap: () {},
              ),
            ),
            ProfileTabBar(
              selectedIndex: _tabIndex,
              onTabChanged: (i) => setState(() => _tabIndex = i),
            ),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: _buildTabContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_tabIndex) {
      case 0:
        return AboutTabView(
          key: const ValueKey(0),
          organizer: widget.organizer,
        );
      case 1:
        return EventTabView(
          key: const ValueKey(1),
          events: widget.events,
        );
      case 2:
        return ReviewsTabView(
          key: const ValueKey(2),
          reviews: widget.reviews,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
