import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/models/order_detail_model.dart';
import 'package:metro/services/api_service.dart';
import 'package:metro/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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
        backgroundColor: AppColors.red,
        colorText: AppColors.white,
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
        backgroundColor: AppColors.red,
        colorText: AppColors.white,
        snackPosition: SnackPosition.TOP,
      );
      return null;
    } catch (e) {
      print('Error fetching order detail: $e');
      Get.snackbar(
        'Error',
        'Gagal memuat detail pesanan',
        backgroundColor: AppColors.red,
        colorText: AppColors.white,
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

      Get.back();

      if (response['success'] == true) {
        Get.snackbar(
          'Berhasil',
          response['message'] ?? 'Pesanan berhasil dibatalkan',
          backgroundColor: AppColors.green,
          colorText: AppColors.white,
          snackPosition: SnackPosition.TOP,
        );
        await fetchOrders(showLoading: false);
        return;
      }

      Get.snackbar(
        'Gagal',
        response['message'] ?? 'Gagal membatalkan pesanan',
        backgroundColor: AppColors.red,
        colorText: AppColors.white,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.back();
      print('Error cancelling order: $e');
      Get.snackbar(
        'Error',
        'Gagal membatalkan pesanan',
        backgroundColor: AppColors.red,
        colorText: AppColors.white,
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
          backgroundColor: AppColors.green,
          colorText: AppColors.white,
          snackPosition: SnackPosition.TOP,
        );
        await fetchOrders(showLoading: false);
        return;
      }

      Get.snackbar(
        'Gagal',
        response['message'] ?? 'Gagal menyelesaikan pesanan',
        backgroundColor: AppColors.red,
        colorText: AppColors.white,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.back();
      print('Error marking order as completed: $e');
      Get.snackbar(
        'Error',
        'Gagal menyelesaikan pesanan',
        backgroundColor: AppColors.red,
        colorText: AppColors.white,
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
            await launchUrl(url, mode: LaunchMode.externalApplication);
          } else {
            Get.snackbar(
              'Error',
              'Tidak dapat membuka halaman pembayaran',
              backgroundColor: AppColors.red,
              colorText: AppColors.white,
              snackPosition: SnackPosition.TOP,
            );
          }
          return;
        }

        Get.snackbar(
          'Error',
          'Payment URL tidak ditemukan',
          backgroundColor: AppColors.red,
          colorText: AppColors.white,
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      Get.snackbar(
        'Gagal',
        response['message'] ?? 'Gagal memproses pembayaran',
        backgroundColor: AppColors.red,
        colorText: AppColors.white,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.back();
      print('Error initiating payment: $e');
      Get.snackbar(
        'Error',
        'Gagal memproses pembayaran',
        backgroundColor: AppColors.red,
        colorText: AppColors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> downloadInvoice(int orderId) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      final response = await ApiService.downloadInvoice(orderId);

      Get.back();

      if (response['success'] == true) {
        final pdfBase64 = response['data']['pdf_base64'];
        final fileName = response['data']['file_name'];
        final pdfBytes = base64Decode(pdfBase64);

        final savedPath = await _savePdfFile(pdfBytes, fileName);

        if (savedPath != null) {
          Get.snackbar(
            'Berhasil',
            'Invoice berhasil diunduh ke folder Download',
            backgroundColor: AppColors.green,
            colorText: AppColors.white,
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 4),
          );
        }
        return;
      }

      Get.snackbar(
        'Gagal',
        response['message'] ?? 'Gagal mengunduh invoice',
        backgroundColor: AppColors.red,
        colorText: AppColors.white,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.back();
      print('Error downloading invoice: $e');
      Get.snackbar(
        'Error',
        'Gagal mengunduh invoice: ${e.toString()}',
        backgroundColor: AppColors.red,
        colorText: AppColors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<String?> _savePdfFile(List<int> bytes, String fileName) async {
    try {
      Directory? directory;

      if (Platform.isAndroid) {
        if (await _requestStoragePermission()) {
          directory = await getExternalStorageDirectory();
          final downloadPath = '/storage/emulated/0/Download';
          directory = Directory(downloadPath);

          if (!await directory.exists()) {
            await directory.create(recursive: true);
          }
        } else {
          Get.snackbar(
            'Permission Denied',
            'Izin penyimpanan diperlukan untuk menyimpan file',
            backgroundColor: AppColors.orange,
            colorText: AppColors.white,
            snackPosition: SnackPosition.TOP,
          );
          return null;
        }
      } else if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory != null) {
        final filePath = '${directory.path}/$fileName';
        final file = File(filePath);
        await file.writeAsBytes(bytes);
        return filePath;
      }
      return null;
    } catch (e) {
      print('Error saving PDF file: $e');
      return null;
    }
  }

  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      if (await Permission.storage.isDenied) {
        final status = await Permission.manageExternalStorage.request();
        return status.isGranted;
      }
      return true;
    }
    return true;
  }

  Future<void> sendInvoiceToEmail(int orderId) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final response = await ApiService.sendInvoice(orderId);

      Get.back();

      if (response['success'] == true) {
        Get.snackbar(
          'Berhasil',
          response['message'] ?? 'Invoice berhasil dikirim ke email Anda',
          backgroundColor: AppColors.green,
          colorText: AppColors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 4),
        );
        return;
      }

      Get.snackbar(
        'Gagal',
        response['message'] ?? 'Gagal mengirim invoice ke email',
        backgroundColor: AppColors.red,
        colorText: AppColors.white,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.back();
      print('Error sending invoice to email: $e');
      Get.snackbar(
        'Error',
        'Gagal mengirim invoice ke email',
        backgroundColor: AppColors.red,
        colorText: AppColors.white,
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
        return AppColors.orange;
      case 'paid':
      case 'processing':
        return AppColors.blue;
      case 'shipped':
        return AppColors.purple;
      case 'completed':
        return AppColors.green;
      case 'cancelled':
        return AppColors.red;
      default:
        return AppColors.grey;
    }
  }

  String formatCurrency(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }
}
