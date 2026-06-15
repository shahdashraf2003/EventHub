class ReviewModel {
  final String reviewerName;
  final String reviewerAvatar;
  final double rating;
  final String comment;
  final String date;

  const ReviewModel({
    required this.reviewerName,
    required this.reviewerAvatar,
    required this.rating,
    required this.comment,
    required this.date,
  });
}
