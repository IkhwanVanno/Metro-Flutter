class Review {
  final int id;
  final int rating;
  final String message;
  final String createdAt;
  final String authorName;
  final String formattedDate;

  Review({
    required this.id,
    required this.rating,
    required this.message,
    required this.createdAt,
    required this.authorName,
    required this.formattedDate,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? 0,
      rating: json['rating'] ?? 0,
      message: json['message'] ?? '',
      createdAt: json['created_at'] ?? '',
      authorName: json['author_name'] ?? 'Anonymous',
      formattedDate: json['formatted_date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rating': rating,
      'message': message,
      'created_at': createdAt,
      'author_name': authorName,
      'formatted_date': formattedDate,
    };
  }
}
