class Popupad {
  final int id;
  final String title;
  final String link;
  final bool status;
  final int sortOrder;
  final String image;

  Popupad({
    required this.id,
    required this.title,
    required this.link,
    required this.status,
    required this.sortOrder,
    required this.image,
  });

  factory Popupad.fromJson(Map<String, dynamic> json) {
    return Popupad(
      id: json['id'],
      title: json['title'] ?? '',
      link: json['link_url'] ?? '',
      status: json['active'] ?? 0,
      sortOrder: json['sort_order'] ?? '',
      image: json['image_url'] ?? '',
    );
  }
}
