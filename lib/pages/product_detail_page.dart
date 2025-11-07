import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/controller/auth_controller.dart';
import 'package:metro/controller/cart_controller.dart';
import 'package:metro/controller/favorite_controller.dart';
import 'package:metro/controller/review_controller.dart';
import 'package:metro/models/product_model.dart';
import 'package:metro/theme/app_theme.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final favoriteController = Get.put(FavoriteController());
  final cartController = Get.put(CartController());
  final reviewController = Get.put(ReviewController());
  final authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    // Load reviews when page opens
    reviewController.fetchProductReviews(widget.product.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name, overflow: TextOverflow.ellipsis),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Stack(
              children: [
                Image.network(
                  widget.product.imageUrl,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return SizedBox(
                      height: 300,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: progress.expectedTotalBytes != null
                              ? progress.cumulativeBytesLoaded /
                                    progress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stack) => Container(
                    height: 300,
                    color: AppColors.grey,
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 80,
                        color: AppColors.grey,
                      ),
                    ),
                  ),
                ),
                // Badges
                if (widget.product.hasDiscount || widget.product.hasFlashsale)
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.product.hasDiscount)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '-${widget.product.discountPercentage.toStringAsFixed(0)}%',
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        if (widget.product.hasFlashsale) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.orange,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              '⚡ FLASH SALE',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
              ],
            ),

            // Product Info Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    widget.product.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Category & Rating
                  Row(
                    children: [
                      if (widget.product.categoryName != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.blue,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            widget.product.categoryName!,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      if (widget.product.rating != null) ...[
                        const Icon(Icons.star, size: 16, color: AppColors.yellow,),
                        const SizedBox(width: 4),
                        Text(
                          widget.product.rating!.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Obx(() {
                          final reviewCount = reviewController.reviews.length;
                          return Text(
                            '($reviewCount review${reviewCount > 1 ? 's' : ''})',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.grey,
                            ),
                          );
                        }),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Price Section
                  if (widget.product.hasDiscount) ...[
                    Text(
                      widget.product.formattedOriginalPrice,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.product.formattedPrice,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.red,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Hemat ${(widget.product.originalPrice - widget.product.priceAfterAllDiscount).toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ] else
                    Text(
                      widget.product.formattedPrice,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.red,
                      ),
                    ),

                  const SizedBox(height: 16),

                  // Stock Info
                  Row(
                    children: [
                      const Text('Stok: ', style: TextStyle(fontSize: 14)),
                      Text(
                        widget.product.stock > 0
                            ? '${widget.product.stock} tersedia'
                            : 'Habis',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: widget.product.stock > 0
                              ? Colors.green
                              : AppColors.red,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Description Section
                  const Text(
                    'Deskripsi Produk',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.description.isNotEmpty
                        ? widget.product.description
                        : 'Tidak ada deskripsi',
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.black,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Flash Sale Info
                  if (widget.product.hasFlashsale &&
                      widget.product.flashsaleName != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.orange,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.orange),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.flash_on,
                            color: AppColors.orange,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Flash Sale: ${widget.product.flashsaleName}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 24),

                  // Reviews Section
                  _buildReviewsSection(),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
      // Bottom Action Button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.grey,
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Add To Favorite Button
            Expanded(
              child: Obx(() {
                return ElevatedButton.icon(
                  onPressed: widget.product.stock > 0
                      ? () async {
                          if (!authController.isLoggedIn) {
                            Get.snackbar(
                              'Autentikasi Diperlukan',
                              'Silakan login terlebih dahulu',
                            );
                            return;
                          }

                          await favoriteController.toggleFavorite(
                            widget.product.id,
                          );
                        }
                      : null,
                  icon: Icon(
                    favoriteController.isProductFavorited(widget.product.id)
                        ? Icons.favorite
                        : Icons.favorite_border,
                  ),
                  label: Text(
                    favoriteController.isProductFavorited(widget.product.id)
                        ? 'Hapus dari Favorit'
                        : 'Tambah ke Favorit',
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: AppColors.red,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(width: 12),
            // Add to Cart Button
            Expanded(
              child: ElevatedButton.icon(
                onPressed: widget.product.stock > 0
                    ? () async {
                        await cartController.addToCart(
                          widget.product.id,
                          quantity: 1,
                        );
                      }
                    : null,
                icon: const Icon(Icons.shopping_cart),
                label: const Text('Tambah ke Keranjang'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: AppColors.blue,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsSection() {
    return Obx(() {
      if (reviewController.isLoading.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: CircularProgressIndicator(),
          ),
        );
      }

      final reviews = reviewController.reviews;
      final averageRating = reviewController.getAverageRating();
      final ratingDistribution = reviewController.getRatingDistribution();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reviews Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Ulasan Produk',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              if (reviews.isNotEmpty)
                TextButton(
                  onPressed: () {
                    // Show all reviews in dialog or new page
                    _showAllReviewsDialog();
                  },
                  child: const Text('Lihat Semua'),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Rating Summary
          if (reviews.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.grey.withAlpha(50),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // Average Rating
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text(
                          averageRating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            return Icon(
                              index < averageRating.round()
                                  ? Icons.star
                                  : Icons.star_border,
                              color: AppColors.yellow,
                              size: 20,
                            );
                          }),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${reviews.length} ulasan',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Rating Distribution
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: List.generate(5, (index) {
                        final star = 5 - index;
                        final count = ratingDistribution[star] ?? 0;
                        final percentage = reviews.isNotEmpty
                            ? (count / reviews.length) * 100
                            : 0.0;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              Text(
                                '$star',
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.star,
                                size: 12,
                                color: AppColors.yellow,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: LinearProgressIndicator(
                                  value: percentage / 100,
                                  backgroundColor: AppColors.grey,
                                  valueColor: const AlwaysStoppedAnimation(
                                    AppColors.yellow,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '$count',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.grey,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Reviews List (Show first 3)
          if (reviews.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.rate_review_outlined,
                      size: 48,
                      color: AppColors.grey,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Belum ada ulasan',
                      style: TextStyle(color: AppColors.grey),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reviews.length > 3 ? 3 : reviews.length,
              separatorBuilder: (context, index) => const Divider(height: 24),
              itemBuilder: (context, index) {
                final review = reviews[index];
                return _buildReviewItem(review);
              },
            ),
        ],
      );
    });
  }

  Widget _buildReviewItem(review) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.blue.withAlpha(25),
              child: Text(
                review.authorName[0].toUpperCase(),
                style: TextStyle(
                  color: AppColors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.authorName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      ...List.generate(5, (index) {
                        return Icon(
                          index < review.rating
                              ? Icons.star
                              : Icons.star_border,
                          size: 16,
                          color: AppColors.yellow,
                        );
                      }),
                      const SizedBox(width: 8),
                      Text(
                        review.formattedDate,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(review.message, style: const TextStyle(fontSize: 14, height: 1.5)),
      ],
    );
  }

  void _showAllReviewsDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Title
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Semua Ulasan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Reviews List
              Expanded(
                child: Obx(() {
                  final reviews = reviewController.reviews;
                  return ListView.separated(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: reviews.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 24),
                    itemBuilder: (context, index) {
                      final review = reviews[index];
                      return _buildReviewItem(review);
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
