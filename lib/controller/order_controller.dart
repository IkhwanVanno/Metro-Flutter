import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/models/order_detail_model.dart';
import 'package:metro/services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderController extends GetxController {
  var orders = <OrderSummary>[].obs;
  var isLoading = false.obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var selectedStatus = 'all'.obs;

  final List<String> statusFilters = [
    'all',
    'pending',
    'pending_payment',
    'paid',
    'processing',
    'shipped',
    'completed',
    'cancelled',
  ];

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders({bool showLoading = true}) async {
    try {
      if (showLoading) isLoading(true);

      final response = await ApiService.getOrders(
        status: selectedStatus.value == 'all' ? null : selectedStatus.value,
        page: currentPage.value,
        limit: 20,
      );

      if (response['success'] == true) {
        final data = response['data'] as List;
        orders.value = data.map((item) => OrderSummary.fromJson(item)).toList();

        if (response['meta'] != null) {
          totalPages.value = response['meta']['total_pages'] ?? 1;
        }
      } else {
        orders.clear();
      }
    } catch (e) {
      print('Error fetching orders: $e');
      Get.snackbar(
        'Error',
        'Gagal memuat pesanan',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      if (showLoading) isLoading(false);
    }
  }

  Future<OrderDetail?> fetchOrderDetail(int orderId) async {
    try {
      final response = await ApiService.getOrderDetail(orderId);

      if (response['success'] == true) {
        return OrderDetail.fromJson(response['data']);
      }

      Get.snackbar(
        'Error',
        response['message'] ?? 'Gagal memuat detail pesanan',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return null;
    } catch (e) {
      print('Error fetching order detail: $e');
      Get.snackbar(
        'Error',
        'Gagal memuat detail pesanan',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return null;
    }
  }

  Future<void> cancelOrder(int orderId) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final response = await ApiService.cancelOrder(orderId);

      Get.back(); // Close loading dialog

      if (response['success'] == true) {
        Get.snackbar(
          'Berhasil',
          response['message'] ?? 'Pesanan berhasil dibatalkan',
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        await fetchOrders(showLoading: false);
        return;
      }

      Get.snackbar(
        'Gagal',
        response['message'] ?? 'Gagal membatalkan pesanan',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.back();
      print('Error cancelling order: $e');
      Get.snackbar(
        'Error',
        'Gagal membatalkan pesanan',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> markAsCompleted(int orderId) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final response = await ApiService.markOrderAsCompleted(orderId);

      Get.back();

      if (response['success'] == true) {
        Get.snackbar(
          'Berhasil',
          response['message'] ?? 'Pesanan berhasil diselesaikan',
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        await fetchOrders(showLoading: false);
        return;
      }

      Get.snackbar(
        'Gagal',
        response['message'] ?? 'Gagal menyelesaikan pesanan',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.back();
      print('Error marking order as completed: $e');
      Get.snackbar(
        'Error',
        'Gagal menyelesaikan pesanan',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> initiatePayment(int orderId) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final response = await ApiService.initiatePayment(orderId);

      Get.back();

      if (response['success'] == true) {
        final paymentUrl = response['data']['payment_url'];

        if (paymentUrl != null && paymentUrl.isNotEmpty) {
          final url = Uri.parse(paymentUrl);

          if (await canLaunchUrl(url)) {
            await launchUrl(
              url,
              mode: LaunchMode.externalApplication,
            );
          } else {
            Get.snackbar(
              'Error',
              'Tidak dapat membuka halaman pembayaran',
              backgroundColor: Colors.red.shade600,
              colorText: Colors.white,
              snackPosition: SnackPosition.TOP,
            );
          }
          return;
        }

        Get.snackbar(
          'Error',
          'Payment URL tidak ditemukan',
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      Get.snackbar(
        'Gagal',
        response['message'] ?? 'Gagal memproses pembayaran',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.back();
      print('Error initiating payment: $e');
      Get.snackbar(
        'Error',
        'Gagal memproses pembayaran',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  void filterByStatus(String status) {
    selectedStatus.value = status;
    currentPage.value = 1;
    fetchOrders();
  }

  void nextPage() {
    if (currentPage.value < totalPages.value) {
      currentPage.value++;
      fetchOrders();
    }
  }

  void previousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      fetchOrders();
    }
  }

  Future<void> refreshOrders() async {
    currentPage.value = 1;
    await fetchOrders(showLoading: false);
  }

  String getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Menunggu';
      case 'pending_payment':
        return 'Menunggu Pembayaran';
      case 'paid':
        return 'Dibayar';
      case 'processing':
        return 'Diproses';
      case 'shipped':
        return 'Dikirim';
      case 'completed':
        return 'Selesai';
      case 'cancelled':
        return 'Dibatalkan';
      default:
        return status;
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
      case 'pending_payment':
        return Colors.orange;
      case 'paid':
      case 'processing':
        return Colors.blue;
      case 'shipped':
        return Colors.purple;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String formatCurrency(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }
}
