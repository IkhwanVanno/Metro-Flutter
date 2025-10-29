import 'package:metro/models/order_model.dart';

enum PaymentStatus { pending, success, failed }

class PaymentTransaction {
  final int id;
  final String paymentGateway;
  final String transactionID;
  final double amount;
  final PaymentStatus status;
  final String responseData;
  final DateTime createdAt;
  final Order? order;

  PaymentTransaction({
    required this.id,
    required this.paymentGateway,
    required this.transactionID,
    required this.amount,
    required this.status,
    required this.responseData,
    required this.createdAt,
    this.order,
  });

  factory PaymentTransaction.fromJson(Map<String, dynamic> json) {
    return PaymentTransaction(
      id: json['id'],
      paymentGateway: json['payment_gateway'],
      transactionID: json['transaction_id'],
      amount: (json['amount'] as num).toDouble(),
      status: _parseStatus(json['status']),
      responseData: json['response_data'],
      createdAt: DateTime.parse(json['created_at']),
      order: json['order'] != null ? Order.fromJson(json['order']) : null,
    );
  }

  static PaymentStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return PaymentStatus.pending;
      case 'success':
        return PaymentStatus.success;
      case 'failed':
        return PaymentStatus.failed;
      default:
        return PaymentStatus.pending;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'payment_gateway': paymentGateway,
      'transaction_id': transactionID,
      'amount': amount,
      'status': status.name,
      'response_data': responseData,
      'created_at': createdAt.toIso8601String(),
      'order': order?.toJson(),
    };
  }
}
