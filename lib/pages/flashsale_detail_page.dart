import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/models/flashsale_model.dart';
import 'package:metro/models/product_model.dart';
import 'package:metro/services/api_service.dart';
import 'package:metro/routes/app_routes.dart';
import 'package:metro/theme/app_theme.dart';

class FlashsaleDetailPage extends StatefulWidget {
  const FlashsaleDetailPage({super.key});

  @override
  State<FlashsaleDetailPage> createState() => _FlashsaleDetailPageState();
}

class _FlashsaleDetailPageState extends State<FlashsaleDetailPage> {
  final int flashsaleId = Get.arguments as int;
  bool isLoading = true;
  String errorMessage = '';
  Flashsale? flashsale;
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    fetchFlashsaleDetail();
  }

  Future<void> fetchFlashsaleDetail() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      final response = await ApiService.getFlashSaleDetail(flashsaleId);

      if (response['success'] == true) {
        setState(() {
          flashsale = response['data'] as Flashsale;
          products = flashsale?.products ?? [];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = response['message'] ?? 'Gagal memuat data';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Terjadi kesalahan: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.accent,
        elevation: 1,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Flash Sale Detail',
          style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    errorMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: fetchFlashsaleDetail,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            )
          : flashsale == null
          ? const Center(child: Text('Data tidak ditemukan'))
          : RefreshIndicator(
              onRefresh: fetchFlashsaleDetail,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Flash Sale Image with Timer Status Overlay
                    Stack(
                      children: [
                        if (flashsale!.imageUrl.isNotEmpty)
                          Image.network(
                            flashsale!.imageUrl,
                            width: double.infinity,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stack) => Container(
                              height: 200,
                              color: AppColors.grey,
                              child: const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  size: 50,
                                  color: AppColors.grey,
                                ),
                              ),
                            ),
                          ),
                        // Timer Status Badge - Prominent Position
                        Positioned(
                          top: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: flashsale!.getTimerStatusColor(),
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.black.withAlpha(30),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _getTimerStatusIcon(flashsale!.timerStatus),
                                  color: AppColors.white,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  flashsale!.getTimerStatusText(),
                                  style: const TextStyle(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Flash Sale Info
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            flashsale!.nama,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Timer Status Card - Prominent Display
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  flashsale!.getTimerStatusColor(),
                                  flashsale!.getTimerStatusColor().withAlpha(70)
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: flashsale!
                                      .getTimerStatusColor()
                                      .withAlpha(50),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  _getTimerStatusIcon(flashsale!.timerStatus),
                                  color: AppColors.white,
                                  size: 48,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  flashsale!.getTimerStatusText(),
                                  style: const TextStyle(
                                    color: AppColors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _getTimerDescription(flashsale!.timerStatus),
                                  style: TextStyle(
                                    color: AppColors.white.withAlpha(90),
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Discount Info
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.orange.withAlpha(30),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.orange,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.orange,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.local_offer,
                                    color: AppColors.white,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Diskon Flash Sale',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${flashsale!.discountFlashSale}% OFF',
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.orange,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Time Period
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.grey.withAlpha(30),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.grey),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.blue.withAlpha(30),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.calendar_today,
                                        size: 20,
                                        color: AppColors.blue,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Mulai',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors.grey,
                                            ),
                                          ),
                                          Text(
                                            _formatDateTime(
                                              flashsale!.startTime,
                                            ),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 24),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.red.withAlpha(30),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.event_busy,
                                        size: 20,
                                        color: AppColors.red,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Berakhir',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors.grey,
                                            ),
                                          ),
                                          Text(
                                            _formatDateTime(flashsale!.endTime),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Description
                          if (flashsale!.description.isNotEmpty) ...[
                            const Text(
                              'Deskripsi',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              flashsale!.description,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.grey,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Products Section Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Produk Flash Sale',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.blue.withAlpha(30),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${products.length} Produk',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Products Grid
                    products.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.inventory_2_outlined,
                                    size: 64,
                                    color: AppColors.grey,
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Tidak ada produk dalam flash sale ini',
                                    style: TextStyle(
                                      color: AppColors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(16),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 0.65,
                                ),
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              final product = products[index];
                              return _buildProductCard(product);
                            },
                          ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.productdetailpage, arguments: product),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stack) => const Center(
                        child: Icon(
                          Icons.broken_image,
                          size: 50,
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                  ),
                  // Flash Sale Badge
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.red,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withAlpha(50),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        '-${flashsale!.discountFlashSale}%',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Product Info
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (product.categoryName != null)
                    Text(
                      product.categoryName!,
                      style: TextStyle(fontSize: 10, color: AppColors.grey),
                    ),
                  if (product.rating != null)
                    Row(
                      children: [
                        const Icon(Icons.star, size: 12, color: AppColors.yellow),
                        const SizedBox(width: 2),
                        Text(
                          product.rating!.toStringAsFixed(1),
                          style: const TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                  const SizedBox(height: 4),
                  // Price
                  Text(
                    product.formattedOriginalPrice,
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  Text(
                    product.formattedPrice,
                    style: const TextStyle(
                      color: AppColors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Stok: ${product.stock}',
                    style: TextStyle(
                      fontSize: 10,
                      color: product.stock > 0 ? AppColors.green : AppColors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getTimerStatusIcon(TimerStatus status) {
    switch (status) {
      case TimerStatus.upcoming:
        return Icons.schedule;
      case TimerStatus.ongoing:
        return Icons.flash_on;
      case TimerStatus.expired:
        return Icons.event_busy;
    }
  }

  String _getTimerDescription(TimerStatus status) {
    switch (status) {
      case TimerStatus.upcoming:
        return 'Flash sale belum dimulai';
      case TimerStatus.ongoing:
        return 'Buruan! Flash sale sedang berlangsung';
      case TimerStatus.expired:
        return 'Flash sale telah berakhir';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    const List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Ags',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];

    return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}, ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
