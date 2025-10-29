import 'package:metro/models/product_model.dart';

class Eventshop {
  final int id;
  final String name;
  final String description;
  final String link;
  final DateTime startDate;
  final DateTime endDate;
  final String image;
  final List<Product>? products;

  Eventshop({
    required this.id,
    required this.name,
    required this.description,
    required this.link,
    required this.startDate,
    required this.endDate,
    required this.image,
    this.products,
  });

  factory Eventshop.fromJson(Map<String, dynamic> json) {
    return Eventshop(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      link: json['link'] ?? '',
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      image: json['image_url'] ?? '',
      products: json['products'] != null
          ? (json['products'] as List)
                .map((item) => Product.fromJson(item))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'link': link,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'image_url': image,
      'products': products?.map((p) => p.toJsonShort()).toList(),
    };
  }

  Map<String, dynamic> toJsonShort() {
    return {'id': id, 'name': name, 'link': link, 'image_url': image};
  }
}
