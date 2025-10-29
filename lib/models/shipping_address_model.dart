import 'package:metro/models/member_model.dart';
import 'package:metro/models/order_model.dart';

class ShippingAddress {
  final int id;
  final String receiverName;
  final int phoneNumber;
  final String address;
  final String provinceName;
  final int provinceId;
  final String cityName;
  final int cityId;
  final String districtName;
  final int districtId;
  final String postalCode;
  final bool isDefault;
  final Member? member;
  final List<Order>? orders;

  ShippingAddress({
    required this.id,
    required this.receiverName,
    required this.phoneNumber,
    required this.address,
    required this.provinceName,
    required this.provinceId,
    required this.cityName,
    required this.cityId,
    required this.districtName,
    required this.districtId,
    required this.postalCode,
    required this.isDefault,
    this.member,
    this.orders,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      id: json['id'],
      receiverName: json['receiver_name'] ?? '',
      phoneNumber: json['phone_number'] ?? 0,
      address: json['address'] ?? '',
      provinceName: json['province_name'] ?? '',
      provinceId: json['province_id'] ?? 0,
      cityName: json['city_name'] ?? '',
      cityId: json['city_id'] ?? 0,
      districtName: json['district_name'] ?? '',
      districtId: json['district_id'] ?? 0,
      postalCode: json['postal_code'] ?? '',
      isDefault: json['is_default'] ?? false,
      member: json['member'] != null ? Member.fromJson(json['member']) : null,
      orders: json['orders'] != null
          ? (json['orders'] as List)
                .map((item) => Order.fromJson(item))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'receiver_name': receiverName,
      'phone_number': phoneNumber,
      'address': address,
      'province_name': provinceName,
      'province_id': provinceId,
      'city_name': cityName,
      'city_id': cityId,
      'district_name': districtName,
      'district_id': districtId,
      'postal_code': postalCode,
      'is_default': isDefault,
      'member': member?.toJson(),
      'orders': orders?.map((order) => order.toJson()).toList(),
    };
  }
}
