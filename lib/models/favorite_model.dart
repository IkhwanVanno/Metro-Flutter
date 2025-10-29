import 'package:metro/models/member_model.dart';
import 'package:metro/models/product_model.dart';

class Favorite {
  final int id;
  final Member? member;
  final Product? product;

  Favorite({required this.id, this.member, this.product});

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      id: json['id'],
      member: json['member'] != null ? Member.fromJson(json['member']) : null,
      product: json['product'] != null
          ? Product.fromJson(json['product'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'member': member?.toJson(), 'product': product?.toJson()};
  }

  // Versi singkat untuk hindari loop
  Map<String, dynamic> toJsonShort() {
    return {'id': id, 'member_id': member?.id, 'product_id': product?.id};
  }
}
