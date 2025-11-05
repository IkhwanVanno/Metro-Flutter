import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/controller/checkout_controller.dart';
import 'package:metro/pages/order_success_page.dart';
import 'package:metro/widgets/address_bottom_sheet.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final controller = Get.put(CheckoutController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.cartItems.isEmpty) {
          return const Center(child: Text('Keranjang kosong'));
        }

        return RefreshIndicator(
          onRefresh: () => controller.loadCheckoutData(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAddressSection(),
                const SizedBox(height: 16),
                _buildCartItemsSection(),
                const SizedBox(height: 16),
                _buildShippingSection(),
                const SizedBox(height: 16),
                _buildPaymentSection(),
                const SizedBox(height: 16),
                _buildSummarySection(),
                const SizedBox(height: 80),
              ],
            ),
          ),
        );
      }),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Alamat Pengiriman',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () => _showAddressBottomSheet(),
              child: const Text('Ubah'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Obx(() {
          final address = controller.selectedAddress.value;
          if (address == null) {
            return TextButton.icon(
              onPressed: () => _showAddressBottomSheet(),
              icon: const Icon(Icons.add),
              label: const Text('Tambah Alamat'),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                address.receiverName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(address.phoneNumber.toString()),
              const SizedBox(height: 4),
              Text(
                '${address.address}, ${address.districtName}, ${address.cityName}, ${address.provinceName} ${address.postalCode}',
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildCartItemsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Produk (${controller.totalItems.value} item)',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.cartItems.length > 3
              ? 3
              : controller.cartItems.length,
          separatorBuilder: (context, index) => const Divider(height: 24),
          itemBuilder: (context, index) {
            final item = controller.cartItems[index];
            return Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item['image_url'] ?? '',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) =>
                        const Icon(Icons.broken_image, size: 60),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['product_name'] ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${item['quantity']}x ${controller.formatCurrency((item['price'] as num?)?.toDouble() ?? 0)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  controller.formatCurrency(
                    (item['subtotal'] as num?)?.toDouble() ?? 0,
                  ),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            );
          },
        ),
        if (controller.cartItems.length > 3)
          Center(
            child: TextButton(
              onPressed: () {
                _showAllItemsDialog();
              },
              child: Text(
                'Lihat ${controller.cartItems.length - 3} produk lainnya',
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildShippingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Metode Pengiriman',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        // === Dropdown Pilih Kurir ===
        Obx(() {
          return DropdownButtonFormField<String>(
            isExpanded: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            hint: const Text('Pilih kurir pengiriman'),
            initialValue: controller.selectedCourier.value.isEmpty
                ? null
                : controller.selectedCourier.value,
            items: controller.couriers.map((courier) {
              return DropdownMenuItem<String>(
                value: courier,
                child: Text(courier.toUpperCase()),
              );
            }).toList(),
            onChanged: (value) async {
              if (value != null) {
                controller.selectedCourier.value = value;
                await controller.checkShippingCost();
              }
            },
          );
        }),

        const SizedBox(height: 16),

        // === Dropdown Pilih Layanan Ongkir ===
        Obx(() {
          if (controller.isLoadingShipping.value) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (controller.shippingCosts.isEmpty) {
            return const Text(
              'Pilih kurir untuk melihat opsi pengiriman',
              style: TextStyle(color: Colors.grey),
            );
          }

          return DropdownButtonFormField<int>(
            isExpanded: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            hint: const Text('Pilih layanan pengiriman'),
            initialValue: controller.selectedShippingIndex.value,
            items: List.generate(controller.shippingCosts.length, (index) {
              final shipping = controller.shippingCosts[index];
              return DropdownMenuItem<int>(
                value: index,
                child: Text(
                  '${controller.selectedCourier.value.toUpperCase()} ${shipping.service} - ${shipping.formattedCost} (${shipping.etd})',
                  style: const TextStyle(fontSize: 14),
                ),
              );
            }),
            onChanged: (value) {
              if (value != null) {
                controller.selectShippingCost(
                  controller.shippingCosts[value],
                  value,
                );
              } else {
                controller.selectedShippingCost.value = null;
                controller.selectedShippingIndex.value = null;
              }
            },
          );
        }),
      ],
    );
  }

  Widget _buildPaymentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Metode Pembayaran',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Obx(() {
          if (controller.isLoadingPayment.value) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (controller.paymentMethods.isEmpty) {
            return const Text(
              'Pilih metode pengiriman terlebih dahulu',
              style: TextStyle(color: Colors.grey),
            );
          }

          return DropdownButtonFormField<int>(
            initialValue: controller.selectedPaymentIndex.value,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              hintText: 'Pilih metode pembayaran',
            ),
            items: List.generate(controller.paymentMethods.length, (index) {
              final payment = controller.paymentMethods[index];
              return DropdownMenuItem<int>(
                value: index,
                child: Text(
                  payment.paymentName +
                      (payment.totalFee > 0
                          ? ' (+${payment.formattedFee})'
                          : ''),
                  style: const TextStyle(fontSize: 14),
                ),
              );
            }),
            onChanged: (value) {
              if (value != null) {
                controller.selectPaymentMethod(
                  controller.paymentMethods[value],
                  value,
                );
              }
            },
            validator: (value) {
              if (value == null) {
                return 'Pilih metode pembayaran';
              }
              return null;
            },
            hint: const Text('Pilih metode pembayaran'),
          );
        }),
      ],
    );
  }

  Widget _buildSummarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ringkasan Belanja',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildSummaryRow(
          'Total Harga',
          controller.formatCurrency(controller.originalTotal.value),
        ),
        if (controller.productDiscount.value > 0)
          _buildSummaryRow(
            'Diskon Produk',
            '-${controller.formatCurrency(controller.productDiscount.value)}',
            color: Colors.green,
          ),
        if (controller.flashsaleDiscount.value > 0)
          _buildSummaryRow(
            'Diskon Flash Sale',
            '-${controller.formatCurrency(controller.flashsaleDiscount.value)}',
            color: Colors.green,
          ),
        _buildSummaryRow(
          'Subtotal',
          controller.formatCurrency(controller.subtotal.value),
        ),
        Obx(() {
          final shipping = controller.selectedShippingCost.value;
          return _buildSummaryRow(
            'Ongkos Kirim',
            shipping != null ? shipping.formattedCost : '-',
          );
        }),
        Obx(() {
          final payment = controller.selectedPaymentMethod.value;
          if (payment != null && payment.totalFee > 0) {
            return _buildSummaryRow('Biaya Admin', payment.formattedFee);
          }
          return const SizedBox.shrink();
        }),
        const Divider(height: 24),
        Obx(() {
          final grandTotal = controller.calculateGrandTotal();
          return _buildSummaryRow(
            'Total Pembayaran',
            controller.formatCurrency(grandTotal),
            bold: true,
            color: Colors.red,
          );
        }),
      ],
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool bold = false,
    Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            fontSize: bold ? 16 : 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: bold ? FontWeight.bold : FontWeight.w600,
            fontSize: bold ? 16 : 14,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: SafeArea(
        child: Obx(() {
          final grandTotal = controller.calculateGrandTotal();
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Pembayaran',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    controller.formatCurrency(grandTotal),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: controller.isLoading.value
                      ? null
                      : _processCheckout,
                  child: controller.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Buat Pesanan',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  void _showAddressBottomSheet() {
    // Pastikan addresses sudah di-load
    if (controller.addresses.isEmpty && !controller.isLoadingAddresses.value) {
      controller.fetchAddresses();
    }

    Get.bottomSheet(
      AddressBottomSheet(controller: controller),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      isDismissible: true,
    );
  }

  void _showAllItemsDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Semua Produk (${controller.cartItems.length})',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const Divider(),
              SizedBox(
                height: 400,
                width: double.maxFinite,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: controller.cartItems.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 16),
                  itemBuilder: (context, index) {
                    final item = controller.cartItems[index];
                    return Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item['image_url'] ?? '',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stack) =>
                                const Icon(Icons.broken_image, size: 50),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['product_name'] ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 13),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${item['quantity']}x ${controller.formatCurrency((item['price'] as num?)?.toDouble() ?? 0)}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          controller.formatCurrency(
                            (item['subtotal'] as num?)?.toDouble() ?? 0,
                          ),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _processCheckout() async {
    final result = await controller.createOrder();

    if (result['success'] == true) {
      Get.off(
        () => OrderSuccessPage(
          orderId: result['order_id'],
          orderCode: result['order_code'],
          paymentUrl: result['payment_url'],
        ),
      );
    } else {
      Get.snackbar(
        'Gagal',
        result['message'] ?? 'Gagal membuat pesanan',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}
