import 'dart:ui';

import 'package:metro/models/product_model.dart';

enum FlashsaleStatus { active, inactive }

enum TimerStatus { upcoming, ongoing, expired }

class Flashsale {
  final int id;
  final String nama;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final int discountFlashSale;
  final FlashsaleStatus status;
  final TimerStatus timerStatus;
  final String imageUrl;
  final List<Product>? products;

  Flashsale({
    required this.id,
    required this.nama,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.discountFlashSale,
    required this.status,
    required this.timerStatus,
    required this.imageUrl,
    this.products,
  });

  factory Flashsale.fromJson(Map<String, dynamic> json) {
    // Parse timer_status dari API
    TimerStatus parseTimerStatus(String? status) {
      switch (status?.toLowerCase()) {
        case 'upcoming':
          return TimerStatus.upcoming;
        case 'ongoing':
          return TimerStatus.ongoing;
        case 'expired':
          return TimerStatus.expired;
        default:
          return TimerStatus.expired;
      }
    }

    return Flashsale(
      id: json['id'],
      nama: json['name'] ?? '',
      description: json['description'] ?? '',
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      discountFlashSale: json['discount_flash_sale'] ?? 0,
      status: (json['status'] ?? 'inactive') == 'active'
          ? FlashsaleStatus.active
          : FlashsaleStatus.inactive,
      timerStatus: parseTimerStatus(json['timer_status']),
      imageUrl: json['image_url'] ?? '',
      products: json['products'] != null
          ? (json['products'] as List)
                .map((item) => Product.fromJson(item))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': nama,
      'description': description,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'discount_flash_sale': discountFlashSale,
      'status': status.name,
      'timer_status': timerStatus.name,
      'image_url': imageUrl,
      'products': products?.map((p) => p.toJsonShort()).toList(),
    };
  }

  Map<String, dynamic> toJsonShort() {
    return {
      'id': id,
      'name': nama,
      'discount_flash_sale': discountFlashSale,
      'image_url': imageUrl,
      'timer_status': timerStatus.name,
    };
  }

  // Helper methods untuk mendapatkan informasi timer
  String getTimerStatusText() {
    switch (timerStatus) {
      case TimerStatus.upcoming:
        return 'AKAN DATANG';
      case TimerStatus.ongoing:
        return 'SEDANG BERLANGSUNG';
      case TimerStatus.expired:
        return 'TELAH BERAKHIR';
    }
  }

  Color getTimerStatusColor() {
    switch (timerStatus) {
      case TimerStatus.upcoming:
        return const Color(0xFFFF9800); // Orange
      case TimerStatus.ongoing:
        return const Color(0xFF4CAF50); // Green
      case TimerStatus.expired:
        return const Color(0xFF9E9E9E); // Grey
    }
  }
}
