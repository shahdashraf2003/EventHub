import 'package:event_hub/core/app_colors.dart';
import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final double rating;
  final double size;

  const StarRating({
    super.key,
    required this.rating,
    this.size = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (i) {
        return Icon(
          i < rating.floor()
              ? Icons.star
              : (i < rating ? Icons.star_half : Icons.star_border),
          size: size,
          color: AppColors.star,
        );
      }),
    );
  }
}
