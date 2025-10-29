class Carousel {
  final int id;
  final String name;
  final String link;
  final String imageUrl;

  Carousel({
    required this.id,
    required this.name,
    required this.link,
    required this.imageUrl,
  });

  factory Carousel.fromJson(Map<String, dynamic> json) {
    return Carousel(
      id: json['id'],
      name: json['name'] ?? '',
      link: json['link'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }
}
