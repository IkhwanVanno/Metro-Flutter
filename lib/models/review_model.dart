import 'package:metro/models/member_model.dart';
import 'package:metro/models/product_model.dart';

class Review {
  final int id;
  final String rating;
  final String message;
  final DateTime createdAt;
  final bool showName;
  final Member? member;
  final Product? product;

  Review({
    required this.id,
    required this.rating,
    required this.message,
    required this.createdAt,
    required this.showName,
    this.member,
    this.product,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      rating: json['rating'] ?? '',
      message: json['message'] ?? '',
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      showName: json['show_name'] ?? false,
    );
  }
}
