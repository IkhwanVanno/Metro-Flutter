import 'package:metro/models/cart_item_model.dart';
import 'package:metro/models/category_model.dart';
import 'package:metro/models/eventshop_model.dart';
import 'package:metro/models/favorite_model.dart';
import 'package:metro/models/flashsale_model.dart';

class Product {
  final int id;
  final String name;
  final int stock;
  final int weight;
  final int price;
  final int discountPrice;
  final String description;
  final String image;
  final Category? category;
  final Flashsale? flashsale;
  final Eventshop? eventshop;
  final List<CartItem>? cartItems;
  final List<Favorite>? favorites;

  Product({
    required this.id,
    required this.name,
    required this.stock,
    required this.weight,
    required this.price,
    required this.discountPrice,
    required this.description,
    required this.image,
    this.category,
    this.flashsale,
    this.eventshop,
    this.cartItems,
    this.favorites,
  });

  // Parsing dari JSON ke Model
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'] ?? '',
      stock: json['stock'] ?? 0,
      weight: json['weight'] ?? 0,
      price: json['price'] ?? 0,
      discountPrice: json['discount_price'] ?? 0,
      description: json['description'] ?? '',
      image: json['image_url'] ?? '',
      category: json['category'] != null
          ? Category.fromJson(json['category'])
          : null,
      flashsale: json['flashsale'] != null
          ? Flashsale.fromJson(json['flashsale'])
          : null,
      eventshop: json['eventshop'] != null
          ? Eventshop.fromJson(json['eventshop'])
          : null,
      cartItems: json['cart_items'] != null
          ? (json['cart_items'] as List)
                .map((item) => CartItem.fromJson(item))
                .toList()
          : null,
      favorites: json['favorites'] != null
          ? (json['favorites'] as List)
                .map((item) => Favorite.fromJson(item))
                .toList()
          : null,
    );
  }

  // Convert Model ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'stock': stock,
      'weight': weight,
      'price': price,
      'discount_price': discountPrice,
      'description': description,
      'image_url': image,
      'category': category?.toJsonShort(),
      'flashsale': flashsale?.toJsonShort(),
      'eventshop': eventshop?.toJsonShort(),
      'cart_items': cartItems?.map((item) => item.toJsonShort()).toList(),
      'favorites': favorites?.map((item) => item.toJsonShort()).toList(),
    };
  }

  // Versi singkat untuk menghindari infinite loop
  Map<String, dynamic> toJsonShort() {
    return {'id': id, 'name': name, 'price': price, 'image_url': image};
  }
}
