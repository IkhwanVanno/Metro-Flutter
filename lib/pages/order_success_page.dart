import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/pages/order_detail_page.dart';
import 'package:metro/routes/app_routes.dart';
import 'package:metro/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderSuccessPage extends StatelessWidget {
  final int orderId;
  final String orderCode;
  final String? paymentUrl;

  const OrderSuccessPage({
    super.key,
    required this.orderId,
    required this.orderCode,
    this.paymentUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.green.withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  size: 80,
                  color: AppColors.green,
                ),
              ),
              const SizedBox(height: 32),

              // Success Message
              const Text(
                'Pesanan Berhasil Dibuat!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Order Code
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.grey.withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  orderCode,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Information Text
              Text(
                'Silakan selesaikan pembayaran untuk memproses pesanan Anda',
                style: TextStyle(fontSize: 16, color: AppColors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Payment Button
              if (paymentUrl != null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final url = Uri.parse(paymentUrl!);

                      if (await canLaunchUrl(url)) {
                        await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      } else {
                        Get.snackbar(
                          'Error',
                          'Tidak dapat membuka halaman pembayaran',
                          backgroundColor: AppColors.red,
                          colorText: AppColors.white,
                        );
                      }
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Bayar Sekarang',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 12),

              // View Order Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Get.off(() => OrderDetailPage(orderId: orderId));
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Lihat Detail Pesanan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Back to Home Button
              TextButton(
                onPressed: () {
                  Get.offAllNamed(AppRoutes.mainPage);
                },
                child: const Text(
                  'Kembali ke Beranda',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
