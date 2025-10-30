class Product {
  final int id;
  final String name;
  final int stock;
  final double priceAfterAllDiscount;
  final double originalPrice;
  final String description;
  final String imageUrl;
  final String? categoryName;
  final double? rating;
  final bool hasFlashsale;
  final String? flashsaleName;

  Product({
    required this.id,
    required this.name,
    required this.stock,
    required this.priceAfterAllDiscount,
    required this.originalPrice,
    required this.description,
    required this.imageUrl,
    this.categoryName,
    this.rating,
    this.hasFlashsale = false,
    this.flashsaleName,
  });

  // Parsing dari JSON ke Model (sesuai dengan API response)
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      stock: json['stock'] ?? 0,
      priceAfterAllDiscount: parseDouble(json['price_after_all_discount']),
      originalPrice: parseDouble(json['original_price']),
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
      categoryName: json['category'] as String?,
      rating: json['rating'] != null ? parseDouble(json['rating']) : null,
      hasFlashsale: json['has_flashsale'] ?? false,
      flashsaleName: json['flashsale_name'] as String?,
    );
  }

  // Helper method untuk parsing double
  static double parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  // Convert Model ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'stock': stock,
      'price_after_all_discount': priceAfterAllDiscount,
      'original_price': originalPrice,
      'description': description,
      'image_url': imageUrl,
      'category': categoryName,
      'rating': rating,
      'has_flashsale': hasFlashsale,
      'flashsale_name': flashsaleName,
    };
  }

  // Versi singkat untuk menghindari infinite loop
  Map<String, dynamic> toJsonShort() {
    return {
      'id': id,
      'name': name,
      'price_after_all_discount': priceAfterAllDiscount,
      'image_url': imageUrl,
    };
  }

  // Format harga untuk tampilan
  String get formattedPrice {
    return 'Rp ${priceAfterAllDiscount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  String get formattedOriginalPrice {
    return 'Rp ${originalPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  // Cek apakah ada diskon
  bool get hasDiscount => originalPrice > priceAfterAllDiscount;

  // Hitung persentase diskon
  double get discountPercentage {
    if (!hasDiscount) return 0.0;
    return ((originalPrice - priceAfterAllDiscount) / originalPrice) * 100;
  }
}
