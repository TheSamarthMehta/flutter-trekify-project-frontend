// lib/models/review_model.dart

class Review {
  final String userName;
  final int rating; // Rating out of 5
  final String comment;
  final DateTime timestamp;

  Review({
    required this.userName,
    required this.rating,
    required this.comment,
    required this.timestamp,
  });
}