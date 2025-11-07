import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/models/eventshop_model.dart';
import 'package:metro/models/product_model.dart';
import 'package:metro/services/api_service.dart';
import 'package:metro/routes/app_routes.dart';
import 'package:metro/theme/app_theme.dart';

class EventshopDetailPage extends StatefulWidget {
  const EventshopDetailPage({super.key});

  @override
  State<EventshopDetailPage> createState() => _EventshopDetailPageState();
}

class _EventshopDetailPageState extends State<EventshopDetailPage> {
  final int eventshopId = Get.arguments as int;
  bool isLoading = true;
  String errorMessage = '';
  Eventshop? eventshop;
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    fetchEventshopDetail();
  }

  Future<void> fetchEventshopDetail() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      final response = await ApiService.getEventShopDetail(eventshopId);

      if (response['success'] == true) {
        setState(() {
          eventshop = response['data'] as Eventshop;
          products = eventshop?.products ?? [];
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
        backgroundColor: AppColors.primary,
        elevation: 1,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Event Shop Detail',
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
                    onPressed: fetchEventshopDetail,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            )
          : eventshop == null
          ? const Center(child: Text('Data tidak ditemukan'))
          : RefreshIndicator(
              onRefresh: fetchEventshopDetail,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Event Shop Image
                    if (eventshop!.image.isNotEmpty)
                      Image.network(
                        eventshop!.image,
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stack) => Container(
                          height: 250,
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

                    // Event Shop Info
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            eventshop!.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Event Period
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.blue.withAlpha(30),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.blue,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.event,
                                      size: 20,
                                      color: AppColors.blue,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Periode Event',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 16),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      size: 16,
                                      color: AppColors.grey,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Mulai: ${_formatDate(eventshop!.startDate)}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      size: 16,
                                      color: AppColors.grey,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Berakhir: ${_formatDate(eventshop!.endDate)}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                _buildEventStatus(),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Description
                          if (eventshop!.description.isNotEmpty) ...[
                            const Text(
                              'Deskripsi Event',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              eventshop!.description,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.grey,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Link
                          if (eventshop!.link.isNotEmpty) ...[
                            OutlinedButton.icon(
                              onPressed: () {
                                // Implement URL launcher here if needed
                                Get.snackbar(
                                  'Info',
                                  'Link: ${eventshop!.link}',
                                  snackPosition: SnackPosition.TOP,
                                );
                              },
                              icon: const Icon(Icons.link),
                              label: const Text('Kunjungi Link Event'),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 45),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Products Section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Produk Event',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${products.length} Produk',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Products Grid
                    products.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(32.0),
                            child: Center(
                              child: Text(
                                'Tidak ada produk dalam event ini',
                                style: TextStyle(color: AppColors.grey),
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

  Widget _buildEventStatus() {
    final now = DateTime.now();
    final isActive =
        now.isAfter(eventshop!.startDate) && now.isBefore(eventshop!.endDate);
    final isUpcoming = now.isBefore(eventshop!.startDate);
    // final isEnded = now.isAfter(eventshop!.endDate);

    Color statusColor;
    String statusText;
    IconData statusIcon;

    if (isActive) {
      statusColor = AppColors.green;
      statusText = 'SEDANG BERLANGSUNG';
      statusIcon = Icons.check_circle;
    } else if (isUpcoming) {
      statusColor = AppColors.orange;
      statusText = 'AKAN DATANG';
      statusIcon = Icons.schedule;
    } else {
      statusColor = AppColors.red;
      statusText = 'TELAH BERAKHIR';
      statusIcon = Icons.cancel;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: 16, color: AppColors.white),
          const SizedBox(width: 6),
          Text(
            statusText,
            style: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
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
            // Thumbnail seragam
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                color: Colors.grey[200],
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Center(
                        child: Icon(
                          Icons.broken_image,
                          size: 40,
                          color: AppColors.grey,
                        ),
                      ),
                      loadingBuilder: (_, child, progress) {
                        if (progress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        );
                      },
                    ),
                  ),

                  // Discount Badge
                  if (product.hasDiscount)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '-${product.discountPercentage.toStringAsFixed(0)}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  // Flash Sale Badge
                  if (product.hasFlashsale)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.orange,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          '⚡ FLASH',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Text area seragam & rapih
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama produk
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Category + Rating baris
                  Row(
                    children: [
                      // Category
                      if (product.categoryName != null)
                        Expanded(
                          child: Text(
                            product.categoryName!,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.grey,
                            ),
                          ),
                        ),

                      // Rating
                      if (product.rating != null)
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 12,
                              color: AppColors.yellow,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              product.rating!.toStringAsFixed(1),
                              style: const TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Harga
                  if (product.hasDiscount) ...[
                    Text(
                      product.formattedOriginalPrice,
                      style: TextStyle(
                        decoration: TextDecoration.lineThrough,
                        fontSize: 10,
                        color: AppColors.grey,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      product.formattedPrice,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.red,
                        height: 1,
                      ),
                    ),
                  ] else ...[
                    Text(
                      product.formattedPrice,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.red,
                        height: 1,
                      ),
                    ),
                  ],

                  const SizedBox(height: 6),

                  // Stock Info
                  Text(
                    'Stok: ${product.stock}',
                    style: TextStyle(
                      fontSize: 10,
                      color: product.stock > 0
                          ? AppColors.green
                          : AppColors.red,
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
