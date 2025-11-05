class ShippingCost {
  final String name;
  final String code;
  final String service;
  final String description;
  final double cost;
  final String etd;
  final String formattedCost;

  ShippingCost({
    required this.name,
    required this.code,
    required this.service,
    required this.description,
    required this.cost,
    required this.etd,
    required this.formattedCost,
  });

  factory ShippingCost.fromJson(Map<String, dynamic> json) {
    double parsedCost = _parseDouble(json['cost']);
    String parsedEtd = json['etd']?.toString() ?? '';

    return ShippingCost(
      name: json['name']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      service: json['service']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      cost: parsedCost,
      etd: parsedEtd,
      formattedCost: _formatCurrency(parsedCost),
    );
  }

  // Helper untuk parsing double
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  // Helper untuk format currency
  static String _formatCurrency(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'service': service,
      'description': description,
      'cost': cost,
      'etd': etd,
      'formatted_cost': formattedCost,
    };
  }
}
