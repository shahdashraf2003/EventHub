import 'package:event_hub/core/app_colors.dart';
import 'package:event_hub/model/entities/organizer_model.dart';
import 'package:flutter/material.dart';

class AboutTabView extends StatelessWidget {
  final OrganizerModel organizer;

  const AboutTabView({super.key, required this.organizer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            organizer.about,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textGrey,
              height: 1.65,
            ),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () {},
            child: const Text(
              'Read More',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
