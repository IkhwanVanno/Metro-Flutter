import 'package:metro/models/product_model.dart';

class Category {
  final int id;
  final String name;
  final List<Product>? products;

  Category({required this.id, required this.name, this.products});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'] ?? '',
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
      // Hindari recursion
      'products': products?.map((p) => p.toJsonShort()).toList(),
    };
  }

  Map<String, dynamic> toJsonShort() {
    return {'id': id, 'name': name};
  }
}
