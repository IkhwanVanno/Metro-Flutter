class PaymentMethod {
  final String paymentMethod;
  final String paymentName;
  final String? paymentImage;
  final double totalFee;
  final String formattedFee;

  PaymentMethod({
    required this.paymentMethod,
    required this.paymentName,
    this.paymentImage,
    required this.totalFee,
    required this.formattedFee,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      paymentMethod: json['payment_method'] ?? '',
      paymentName: json['payment_name'] ?? '',
      paymentImage: json['payment_image'],
      totalFee: (json['total_fee'] as num?)?.toDouble() ?? 0.0,
      formattedFee: json['formatted_fee'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payment_method': paymentMethod,
      'payment_name': paymentName,
      'payment_image': paymentImage,
      'total_fee': totalFee,
      'formatted_fee': formattedFee,
    };
  }
}
