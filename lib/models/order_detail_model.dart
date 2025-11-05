class OrderDetail {
  final int id;
  final String orderCode;
  final String status;
  final String paymentStatus;
  final double totalPrice;
  final double originalTotalPrice;
  final double totalProductDiscount;
  final double totalFlashsaleDiscount;
  final double shippingCost;
  final double paymentFee;
  final double grandTotal;
  final String paymentMethod;
  final String shippingCourier;
  final String? trackingNumber;
  final String createdAt;
  final String updatedAt;
  final String expiresAt;
  final bool isExpired;
  final bool canBePaid;
  final bool canBeCancelled;
  final bool canBeReviewed;
  final List<OrderItemDetail> items;
  final ShippingAddressInfo? shippingAddress;

  OrderDetail({
    required this.id,
    required this.orderCode,
    required this.status,
    required this.paymentStatus,
    required this.totalPrice,
    required this.originalTotalPrice,
    required this.totalProductDiscount,
    required this.totalFlashsaleDiscount,
    required this.shippingCost,
    required this.paymentFee,
    required this.grandTotal,
    required this.paymentMethod,
    required this.shippingCourier,
    this.trackingNumber,
    required this.createdAt,
    required this.updatedAt,
    required this.expiresAt,
    required this.isExpired,
    required this.canBePaid,
    required this.canBeCancelled,
    required this.canBeReviewed,
    required this.items,
    this.shippingAddress,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      id: json['id'] ?? 0,
      orderCode: json['order_code'] ?? '',
      status: json['status'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0.0,
      originalTotalPrice:
          (json['original_total_price'] as num?)?.toDouble() ?? 0.0,
      totalProductDiscount:
          (json['total_product_discount'] as num?)?.toDouble() ?? 0.0,
      totalFlashsaleDiscount:
          (json['total_flashsale_discount'] as num?)?.toDouble() ?? 0.0,
      shippingCost: (json['shipping_cost'] as num?)?.toDouble() ?? 0.0,
      paymentFee: (json['payment_fee'] as num?)?.toDouble() ?? 0.0,
      grandTotal: (json['grand_total'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: json['payment_method'] ?? '',
      shippingCourier: json['shipping_courier'] ?? '',
      trackingNumber: json['tracking_number'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      expiresAt: json['expires_at'] ?? '',
      isExpired: json['is_expired'] ?? false,
      canBePaid: json['can_be_paid'] ?? false,
      canBeCancelled: json['can_be_cancelled'] ?? false,
      canBeReviewed: json['can_be_reviewed'] ?? false,
      items:
          (json['items'] as List?)
              ?.map((item) => OrderItemDetail.fromJson(item))
              .toList() ??
          [],
      shippingAddress: json['shipping_address'] != null
          ? ShippingAddressInfo.fromJson(json['shipping_address'])
          : null,
    );
  }
}

class OrderItemDetail {
  final int id;
  final int productId;
  final String productName;
  final int quantity;
  final double price;
  final double subtotal;
  final double originalSubtotal;
  final double productDiscount;
  final double flashsaleDiscount;
  final String? imageUrl;
  final bool canBeReviewed;
  final bool hasReview;

  OrderItemDetail({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.subtotal,
    required this.originalSubtotal,
    required this.productDiscount,
    required this.flashsaleDiscount,
    this.imageUrl,
    required this.canBeReviewed,
    required this.hasReview,
  });

  factory OrderItemDetail.fromJson(Map<String, dynamic> json) {
    return OrderItemDetail(
      id: json['id'] ?? 0,
      productId: json['product_id'] ?? 0,
      productName: json['product_name'] ?? '',
      quantity: json['quantity'] ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      originalSubtotal: (json['original_subtotal'] as num?)?.toDouble() ?? 0.0,
      productDiscount: (json['product_discount'] as num?)?.toDouble() ?? 0.0,
      flashsaleDiscount:
          (json['flashsale_discount'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['image_url'],
      canBeReviewed: json['can_be_reviewed'] ?? false,
      hasReview: json['has_review'] ?? false,
    );
  }
}

class ShippingAddressInfo {
  final String receiverName;
  final String phoneNumber;
  final String address;
  final String cityName;
  final String districtName;
  final String provinceName;
  final String postalCode;

  ShippingAddressInfo({
    required this.receiverName,
    required this.phoneNumber,
    required this.address,
    required this.cityName,
    required this.districtName,
    required this.provinceName,
    required this.postalCode,
  });

  factory ShippingAddressInfo.fromJson(Map<String, dynamic> json) {
    return ShippingAddressInfo(
      receiverName: json['receiver_name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      address: json['address'] ?? '',
      cityName: json['city_name'] ?? '',
      districtName: json['district_name'] ?? '',
      provinceName: json['province_name'] ?? '',
      postalCode: json['postal_code'] ?? '',
    );
  }

  String get fullAddress =>
      '$address, $districtName, $cityName, $provinceName $postalCode';
}

class OrderSummary {
  final int id;
  final String orderCode;
  final String status;
  final String paymentStatus;
  final double totalPrice;
  final double shippingCost;
  final double paymentFee;
  final double grandTotal;
  final String paymentMethod;
  final String shippingCourier;
  final String? trackingNumber;
  final String createdAt;
  final String expiresAt;
  final bool isExpired;
  final bool canBePaid;
  final bool canBeCancelled;

  OrderSummary({
    required this.id,
    required this.orderCode,
    required this.status,
    required this.paymentStatus,
    required this.totalPrice,
    required this.shippingCost,
    required this.paymentFee,
    required this.grandTotal,
    required this.paymentMethod,
    required this.shippingCourier,
    this.trackingNumber,
    required this.createdAt,
    required this.expiresAt,
    required this.isExpired,
    required this.canBePaid,
    required this.canBeCancelled,
  });

  factory OrderSummary.fromJson(Map<String, dynamic> json) {
    return OrderSummary(
      id: json['id'] ?? 0,
      orderCode: json['order_code'] ?? '',
      status: json['status'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0.0,
      shippingCost: (json['shipping_cost'] as num?)?.toDouble() ?? 0.0,
      paymentFee: (json['payment_fee'] as num?)?.toDouble() ?? 0.0,
      grandTotal: (json['grand_total'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: json['payment_method'] ?? '',
      shippingCourier: json['shipping_courier'] ?? '',
      trackingNumber: json['tracking_number'],
      createdAt: json['created_at'] ?? '',
      expiresAt: json['expires_at'] ?? '',
      isExpired: json['is_expired'] ?? false,
      canBePaid: json['can_be_paid'] ?? false,
      canBeCancelled: json['can_be_cancelled'] ?? false,
    );
  }
}
