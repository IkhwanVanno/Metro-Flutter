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
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      link: json['link_url'] ?? '',
      status: (json['active'] == 1),
      sortOrder: json['sort_order'] ?? 0,
      image: json['image_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'link_url': link,
      'active': status ? 1 : 0,
      'sort_order': sortOrder,
      'image_url': image,
    };
  }
}
