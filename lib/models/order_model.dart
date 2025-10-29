import 'package:metro/models/member_model.dart';
import 'package:metro/models/order_item_model.dart';
import 'package:metro/models/payment_transaction_model.dart';
import 'package:metro/models/shipping_address_model.dart';

enum OrderStatus {
  pending,
  pendingpayment,
  paid,
  processing,
  shipped,
  completed,
  cancelled,
}

enum PaymentStatus { unpaid, paid, failed, refunded }

class Order {
  final int id;
  final String orderCode;
  final OrderStatus status;
  final double totalPrice;
  final double shippingCost;
  final double paymentFee;
  final String paymentMethod;
  final PaymentStatus paymentStatus;
  final String shippingCourier;
  final String trackingNumber;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime expiresAt;
  final bool stockReduced;
  final Member? member;
  final ShippingAddress? shippingAddress;
  final List<OrderItem>? orderItems;
  final List<PaymentTransaction>? paymentTransactions;

  Order({
    required this.id,
    required this.orderCode,
    required this.status,
    required this.totalPrice,
    required this.shippingCost,
    required this.paymentFee,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.shippingCourier,
    required this.trackingNumber,
    required this.createdAt,
    required this.updatedAt,
    required this.expiresAt,
    required this.stockReduced,
    this.member,
    this.shippingAddress,
    this.orderItems,
    this.paymentTransactions,
  });

  // Factory untuk parsing JSON dari API
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      orderCode: json['order_code'] ?? '',
      status: _parseOrderStatus(json['status']),
      totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0.0,
      shippingCost: (json['shipping_cost'] as num?)?.toDouble() ?? 0.0,
      paymentFee: (json['payment_fee'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: json['payment_method'] ?? '',
      paymentStatus: _parsePaymentStatus(json['payment_status']),
      shippingCourier: json['shipping_courier'] ?? '',
      trackingNumber: json['tracking_number'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      expiresAt: DateTime.tryParse(json['expires_at'] ?? '') ?? DateTime.now(),
      stockReduced: json['stock_reduced'] ?? false,

      // Relasi
      member: json['member'] != null ? Member.fromJson(json['member']) : null,
      shippingAddress: json['shipping_address'] != null
          ? ShippingAddress.fromJson(json['shipping_address'])
          : null,
      orderItems: json['order_items'] != null
          ? (json['order_items'] as List)
                .map((item) => OrderItem.fromJson(item))
                .toList()
          : null,
      paymentTransactions: json['payment_transactions'] != null
          ? (json['payment_transactions'] as List)
                .map((tx) => PaymentTransaction.fromJson(tx))
                .toList()
          : null,
    );
  }

  static OrderStatus _parseOrderStatus(String? value) {
    switch (value?.toLowerCase()) {
      case 'pending':
        return OrderStatus.pending;
      case 'pendingpayment':
        return OrderStatus.pendingpayment;
      case 'paid':
        return OrderStatus.paid;
      case 'processing':
        return OrderStatus.processing;
      case 'shipped':
        return OrderStatus.shipped;
      case 'completed':
        return OrderStatus.completed;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }

  static PaymentStatus _parsePaymentStatus(String? value) {
    switch (value?.toLowerCase()) {
      case 'unpaid':
        return PaymentStatus.unpaid;
      case 'paid':
        return PaymentStatus.paid;
      case 'failed':
        return PaymentStatus.failed;
      case 'refunded':
        return PaymentStatus.refunded;
      default:
        return PaymentStatus.unpaid;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_code': orderCode,
      'status': status.name,
      'total_price': totalPrice,
      'shipping_cost': shippingCost,
      'payment_fee': paymentFee,
      'payment_method': paymentMethod,
      'payment_status': paymentStatus.name,
      'shipping_courier': shippingCourier,
      'tracking_number': trackingNumber,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'expires_at': expiresAt.toIso8601String(),
      'stock_reduced': stockReduced,
      'member': member?.toJson(),
      'shipping_address': shippingAddress?.toJson(),
      'order_items': orderItems?.map((item) => item.toJson()).toList(),
      'payment_transactions': paymentTransactions
          ?.map((tx) => tx.toJson())
          .toList(),
    };
  }
}
