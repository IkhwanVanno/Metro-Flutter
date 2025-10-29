import 'package:metro/models/member_model.dart';
import 'package:metro/models/product_model.dart';

class CartItem {
  final int id;
  final int quantity;
  final Member? member;
  final Product? product;

  CartItem({
    required this.id,
    required this.quantity,
    this.member,
    this.product,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      quantity: json['quantity'] ?? 0,
      member: json['member'] != null ? Member.fromJson(json['member']) : null,
      product: json['product'] != null
          ? Product.fromJson(json['product'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      'member': member?.toJson(),
      'product': product?.toJson(),
    };
  }

  // Versi singkat untuk Product agar tidak infinite loop
  Map<String, dynamic> toJsonShort() {
    return {
      'id': id,
      'quantity': quantity,
      'member_id': member?.id,
      'product_id': product?.id,
    };
  }
}
