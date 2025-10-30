import 'package:metro/models/product_model.dart';

enum FlashsaleStatus { active, inactive }

class Flashsale {
  final int id;
  final String nama;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final int discountFlashSale;
  final FlashsaleStatus status;
  final String imageUrl;
  final List<Product>? products;

  Flashsale({
    required this.id,
    required this.nama,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.discountFlashSale,
    required this.status,
    required this.imageUrl,
    this.products,
  });

  factory Flashsale.fromJson(Map<String, dynamic> json) {
    return Flashsale(
      id: json['id'],
      nama: json['nama'] ?? '',
      description: json['description'] ?? '',
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      discountFlashSale: json['discount_flash_sale'] ?? 0,
      status: (json['status'] ?? 'inactive') == 'active'
          ? FlashsaleStatus.active
          : FlashsaleStatus.inactive,
      imageUrl: json['image_url'] ?? '',
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
      'nama': nama,
      'description': description,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'discount_flash_sale': discountFlashSale,
      'status': status.name,
      'products': products?.map((p) => p.toJsonShort()).toList(),
    };
  }

  Map<String, dynamic> toJsonShort() {
    return {'id': id, 'nama': nama, 'discount_flash_sale': discountFlashSale};
  }
}
