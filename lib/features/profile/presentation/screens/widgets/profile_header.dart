import 'package:event_hub/core/app_colors.dart';
import 'package:event_hub/features/profile/presentation/screens/widgets/profile_action_button.dart';
import 'package:event_hub/models/organizer_model.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final OrganizerModel organizer;
  final bool isFollowing;
  final VoidCallback onFollowTap;
  final VoidCallback onMessageTap;

  const ProfileHeader({
    super.key,
    required this.organizer,
    required this.isFollowing,
    required this.onFollowTap,
    required this.onMessageTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        CircleAvatar(
          radius: 44,
          backgroundImage: AssetImage(organizer.avatar),
          backgroundColor: const Color(0xFFEEF0FF),
        ),
        const SizedBox(height: 14),
        Text(
          organizer.name,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _StatBadge(value: organizer.following, label: 'Following'),
            Container(
              width: 1,
              height: 28,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              color: const Color(0xFFE0E0E0),
            ),
            _StatBadge(value: organizer.followers, label: 'Followers'),
          ],
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            children: [
              Expanded(
                child: ProfileActionButton(
                  label: isFollowing ? 'Following' : 'Follow',
                  icon: Icons.person_add_alt_1_outlined,
                  isPrimary: true,
                  onTap: onFollowTap,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: ProfileActionButton(
                  label: 'Messages',
                  icon: Icons.chat_bubble_outline,
                  isPrimary: false,
                  onTap: onMessageTap,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _StatBadge extends StatelessWidget {
  final int value;
  final String label;

  const _StatBadge({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textGrey,
          ),
        ),
      ],
    );
  }
}
