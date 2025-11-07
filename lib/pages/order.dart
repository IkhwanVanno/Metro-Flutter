import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/controller/auth_controller.dart';
import 'package:metro/controller/order_controller.dart';
import 'package:metro/pages/order_detail_page.dart';
import 'package:metro/routes/app_routes.dart';
import 'package:metro/theme/app_theme.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final controller = Get.put(OrderController());
  final authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    if (authController.isLoggedIn) {
      controller.fetchOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pesanan Saya',
          style: TextStyle(color: AppColors.black),
        ),
        backgroundColor: AppColors.primary,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.black),
      ),
      body: Obx(() {
        if (!authController.isLoggedIn) {
          return _buildLoginPrompt();
        }

        return Column(
          children: [
            _buildStatusFilter(),
            Expanded(child: _buildOrderList()),
          ],
        );
      }),
    );
  }

  Widget _buildLoginPrompt() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_bag,
                size: 80,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Login Required',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Please login to view your orders',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: AppColors.grey),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () => Get.toNamed(AppRoutes.login),
                child: const Text(
                  'Login Now',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusFilter() {
    return Container(
      height: 50,
      color: AppColors.white,
      child: Obx(() {
        final selectedStatus = controller.selectedStatus.value;
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemCount: controller.statusFilters.length,
          itemBuilder: (context, index) {
            final status = controller.statusFilters[index];
            final isSelected = selectedStatus == status;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: FilterChip(
                label: Text(_getFilterLabel(status)),
                selected: isSelected,
                onSelected: (selected) => controller.filterByStatus(status),
                backgroundColor: AppColors.grey.withAlpha(25),
                selectedColor: AppColors.secondary.withAlpha(25),
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.primary : AppColors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildOrderList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.orders.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                size: 80,
                color: AppColors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                'Belum ada pesanan',
                style: TextStyle(fontSize: 16, color: AppColors.grey),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () => controller.refreshOrders(),
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.orders.length,
          itemBuilder: (context, index) {
            final order = controller.orders[index];
            return _buildOrderCard(order);
          },
        ),
      );
    });
  }

  Widget _buildOrderCard(order) {
    final statusColor = controller.getStatusColor(order.status);
    final statusText = controller.getStatusText(order.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Get.to(() => OrderDetailPage(orderId: order.id)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.orderCode,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(order.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withAlpha(30),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),

              // Payment Info
              Row(
                children: [
                  Icon(Icons.payment, size: 16, color: AppColors.black),
                  const SizedBox(width: 8),
                  Text(
                    order.paymentMethod,
                    style: TextStyle(fontSize: 13, color: AppColors.black),
                  ),
                  const Spacer(),
                  Text(
                    controller.formatCurrency(order.grandTotal),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.red,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Shipping Info
              Row(
                children: [
                  Icon(
                    Icons.local_shipping,
                    size: 16,
                    color: AppColors.black,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    order.shippingCourier,
                    style: TextStyle(fontSize: 13, color: AppColors.black),
                  ),
                  if (order.trackingNumber != null) ...[
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        '• ${order.trackingNumber}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),

              // Action Buttons
              if (order.canBePaid || order.canBeCancelled) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (order.canBeCancelled)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _showCancelDialog(order.id),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.red,
                            side: const BorderSide(color: AppColors.red),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Batalkan'),
                        ),
                      ),
                    if (order.canBePaid && order.canBeCancelled)
                      const SizedBox(width: 8),
                    if (order.canBePaid)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => controller.initiatePayment(order.id),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Bayar Sekarang',
                            style: TextStyle(color: AppColors.white),
                          ),
                        ),
                      ),
                  ],
                ),
              ],

              // Completed Button
              if (order.status == 'shipped') ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _showCompletedDialog(order.id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Pesanan Diterima',
                      style: TextStyle(color: AppColors.white),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showCancelDialog(int orderId) {
    Get.defaultDialog(
      title: 'Batalkan Pesanan',
      middleText: 'Apakah Anda yakin ingin membatalkan pesanan ini?',
      textCancel: 'Tidak',
      textConfirm: 'Ya, Batalkan',
      confirmTextColor: AppColors.white,
      buttonColor: AppColors.red,
      onConfirm: () {
        Get.back();
        controller.cancelOrder(orderId);
      },
    );
  }

  void _showCompletedDialog(int orderId) {
    Get.defaultDialog(
      title: 'Konfirmasi Penerimaan',
      middleText: 'Apakah pesanan sudah Anda terima dengan baik?',
      textCancel: 'Belum',
      textConfirm: 'Ya, Sudah',
      confirmTextColor: AppColors.white,
      buttonColor: AppColors.green,
      onConfirm: () {
        Get.back();
        controller.markAsCompleted(orderId);
      },
    );
  }

  String _getFilterLabel(String status) {
    switch (status) {
      case 'all':
        return 'Semua';
      case 'pending':
        return 'Menunggu';
      case 'pending_payment':
        return 'Pembayaran';
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

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateStr;
    }
  }
}
