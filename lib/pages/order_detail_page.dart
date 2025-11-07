import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/controller/order_controller.dart';
import 'package:metro/models/order_detail_model.dart';
import 'package:metro/theme/app_theme.dart';
import 'package:metro/widgets/review_dialog.dart';

class OrderDetailPage extends StatefulWidget {
  final int orderId;

  const OrderDetailPage({super.key, required this.orderId});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  final controller = Get.find<OrderController>();
  OrderDetail? orderDetail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrderDetail();
  }

  Future<void> _loadOrderDetail() async {
    setState(() => isLoading = true);
    final detail = await controller.fetchOrderDetail(widget.orderId);
    setState(() {
      orderDetail = detail;
      isLoading = false;
    });
  }

  void _showReviewDialog(OrderItemDetail item) {
    showDialog(
      context: context,
      builder: (context) => ReviewDialog(
        orderId: widget.orderId,
        orderItemId: item.id,
        productName: item.productName,
        productImage: item.imageUrl,
      ),
    ).then((result) {
      if (result == true) {
        _loadOrderDetail();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Pesanan',
          style: TextStyle(color: AppColors.black),
        ),
        backgroundColor: AppColors.accent,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.black),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orderDetail == null
          ? const Center(child: Text('Detail pesanan tidak ditemukan'))
          : RefreshIndicator(
              onRefresh: _loadOrderDetail,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatusCard(),
                    const Divider(height: 24),
                    _buildOrderInfo(),
                    const SizedBox(height: 24),
                    _buildShippingAddress(),
                    const SizedBox(height: 24),
                    _buildOrderItems(),
                    const SizedBox(height: 24),
                    _buildPaymentSummary(),

                    // Invoice Card (untuk pesanan yang sudah dibayar)
                    if (orderDetail!.paymentStatus == 'paid') ...[
                      const SizedBox(height: 24),
                      _buildInvoiceCard(),
                    ],

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildInvoiceCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.receipt_long, color: AppColors.primary),
            const SizedBox(width: 8),
            const Text(
              'Invoice',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => controller.downloadInvoice(widget.orderId),
                icon: const Icon(Icons.download, size: 18),
                label: const Text('Download'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.blue,
                  side: const BorderSide(color: AppColors.blue),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => controller.sendInvoiceToEmail(widget.orderId),
                icon: const Icon(Icons.email, size: 18),
                label: const Text('Kirim Email'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.green,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusCard() {
    final statusColor = controller.getStatusColor(orderDetail!.status);
    final statusText = controller.getStatusText(orderDetail!.status);

    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.info_outline, color: statusColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status Pesanan',
                    style: TextStyle(fontSize: 12, color: AppColors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (orderDetail!.trackingNumber != null) ...[
          const Divider(height: 24),
          Row(
            children: [
              Icon(Icons.local_shipping, color: AppColors.grey, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nomor Resi',
                      style: TextStyle(fontSize: 12, color: AppColors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      orderDetail!.trackingNumber!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildOrderInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Informasi Pesanan',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildInfoRow('Kode Pesanan', orderDetail!.orderCode),
        _buildInfoRow('Tanggal', _formatDateTime(orderDetail!.createdAt)),
        _buildInfoRow('Metode Pembayaran', orderDetail!.paymentMethod),
        _buildInfoRow('Kurir', orderDetail!.shippingCourier),
      ],
    );
  }

  Widget _buildShippingAddress() {
    final address = orderDetail!.shippingAddress;
    if (address == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Alamat Pengiriman',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          address.receiverName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(address.phoneNumber),
        const SizedBox(height: 4),
        Text(address.fullAddress),
      ],
    );
  }

  Widget _buildOrderItems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Produk (${orderDetail!.items.length} item)',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: orderDetail!.items.length,
          separatorBuilder: (context, index) => const Divider(height: 24),
          itemBuilder: (context, index) {
            final item = orderDetail!.items[index];
            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item.imageUrl ?? '',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stack) => Container(
                          width: 80,
                          height: 80,
                          color: AppColors.grey,
                          child: const Icon(Icons.broken_image, size: 40),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.productName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${item.quantity}x ${controller.formatCurrency(item.price)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            controller.formatCurrency(item.subtotal),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (item.canBeReviewed && !item.hasReview) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _showReviewDialog(item),
                      icon: const Icon(Icons.rate_review, size: 18),
                      label: const Text('Beri Review'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.blue,
                        side: const BorderSide(color: AppColors.blue),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
                if (item.hasReview) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.green.withAlpha(25),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.green),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: AppColors.green,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Review telah diberikan',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildPaymentSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rincian Pembayaran',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildSummaryRow(
          'Total Harga',
          controller.formatCurrency(orderDetail!.originalTotalPrice),
        ),
        if (orderDetail!.totalProductDiscount > 0)
          _buildSummaryRow(
            'Diskon Produk',
            '-${controller.formatCurrency(orderDetail!.totalProductDiscount)}',
            color: AppColors.green,
          ),
        if (orderDetail!.totalFlashsaleDiscount > 0)
          _buildSummaryRow(
            'Diskon Flash Sale',
            '-${controller.formatCurrency(orderDetail!.totalFlashsaleDiscount)}',
            color: AppColors.green,
          ),
        _buildSummaryRow(
          'Subtotal',
          controller.formatCurrency(orderDetail!.totalPrice),
        ),
        _buildSummaryRow(
          'Ongkos Kirim',
          controller.formatCurrency(orderDetail!.shippingCost),
        ),
        if (orderDetail!.paymentFee > 0)
          _buildSummaryRow(
            'Biaya Admin',
            controller.formatCurrency(orderDetail!.paymentFee),
          ),
        const Divider(height: 24),
        _buildSummaryRow(
          'Total Pembayaran',
          controller.formatCurrency(orderDetail!.grandTotal),
          bold: true,
          color: AppColors.red,
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(label, style: TextStyle(color: AppColors.grey)),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool bold = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
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
      ),
    );
  }

  Widget _buildBottomBar() {
    if (orderDetail == null) return const SizedBox.shrink();
    final canBePaid = orderDetail?.canBePaid ?? false;
    final canBeCancelled = orderDetail?.canBeCancelled ?? false;

    if (!canBePaid && !canBeCancelled) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black,
            blurRadius: 4,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (canBeCancelled)
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Get.defaultDialog(
                      title: 'Batalkan Pesanan',
                      middleText:
                          'Apakah Anda yakin ingin membatalkan pesanan ini?',
                      textCancel: 'Tidak',
                      textConfirm: 'Ya, Batalkan',
                      confirmTextColor: AppColors.white,
                      buttonColor: AppColors.red,
                      onConfirm: () {
                        Get.back();
                        controller.cancelOrder(widget.orderId).then((_) {
                          Get.back();
                        });
                      },
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.red,
                    side: const BorderSide(color: AppColors.red),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Batalkan Pesanan'),
                ),
              ),
            if (canBePaid && canBeCancelled) const SizedBox(width: 12),
            if (canBePaid)
              Expanded(
                child: ElevatedButton(
                  onPressed: () => controller.initiatePayment(widget.orderId),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
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
          ],
        ),
      ),
    );
  }

  String _formatDateTime(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'Mei',
        'Jun',
        'Jul',
        'Agu',
        'Sep',
        'Okt',
        'Nov',
        'Des',
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}, ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateStr;
    }
  }
}
