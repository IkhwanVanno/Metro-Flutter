class ShippingAddress {
  final int id;
  final String receiverName;
  final String phoneNumber;
  final String address;
  final String provinceId;
  final String provinceName;
  final String cityId;
  final String cityName;
  final String districtId;
  final String districtName;
  final String postalCode;
  final bool isDefault;

  ShippingAddress({
    required this.id,
    required this.receiverName,
    required this.phoneNumber,
    required this.address,
    required this.provinceId,
    required this.provinceName,
    required this.cityId,
    required this.cityName,
    required this.districtId,
    required this.districtName,
    required this.postalCode,
    required this.isDefault,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      id: _parseInt(json['id']),
      receiverName: json['receiver_name']?.toString() ?? '',
      phoneNumber: json['phone_number']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      provinceId: json['province_id']?.toString() ?? '',
      provinceName: json['province_name']?.toString() ?? '',
      cityId: json['city_id']?.toString() ?? '',
      cityName: json['city_name']?.toString() ?? '',
      districtId: json['district_id']?.toString() ?? '',
      districtName: json['district_name']?.toString() ?? '',
      postalCode: json['postal_code']?.toString() ?? '',
      isDefault: json['is_default'] == true || json['is_default'] == 1,
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'receiver_name': receiverName,
      'phone_number': phoneNumber,
      'address': address,
      'province_id': provinceId,
      'province_name': provinceName,
      'city_id': cityId,
      'city_name': cityName,
      'district_id': districtId,
      'district_name': districtName,
      'postal_code': postalCode,
      'is_default': isDefault,
    };
  }
  String get fullAddress =>
      '$address, $districtName, $cityName, $provinceName $postalCode';
      
  ShippingAddress copyWith({
    int? id,
    String? receiverName,
    String? phoneNumber,
    String? address,
    String? provinceId,
    String? provinceName,
    String? cityId,
    String? cityName,
    String? districtId,
    String? districtName,
    String? postalCode,
    bool? isDefault,
  }) {
    return ShippingAddress(
      id: id ?? this.id,
      receiverName: receiverName ?? this.receiverName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      provinceId: provinceId ?? this.provinceId,
      provinceName: provinceName ?? this.provinceName,
      cityId: cityId ?? this.cityId,
      cityName: cityName ?? this.cityName,
      districtId: districtId ?? this.districtId,
      districtName: districtName ?? this.districtName,
      postalCode: postalCode ?? this.postalCode,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
