import 'package:event_hub/features/profile/presentation/screens/widgets/review_card.dart';
import 'package:event_hub/model/entities/review_model.dart';
import 'package:flutter/material.dart';

class ReviewsTabView extends StatelessWidget {
  final List<ReviewModel> reviews;

  const ReviewsTabView({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      itemCount: reviews.length,
      itemBuilder: (_, i) => ReviewCard(review: reviews[i]),
    );
  }
}
