import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/controller/auth_controller.dart';
import 'package:metro/controller/cart_controller.dart';
import 'package:metro/controller/favorite_controller.dart';
import 'package:metro/models/product_model.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;
  final favoriteController = Get.put(FavoriteController());
  final CartController cartController = Get.put(CartController());
  final authController = Get.find<AuthController>();

  ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name, overflow: TextOverflow.ellipsis),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Stack(
              children: [
                Image.network(
                  product.imageUrl,
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
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 80,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                // Badges
                if (product.hasDiscount || product.hasFlashsale)
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (product.hasDiscount)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '-${product.discountPercentage.toStringAsFixed(2)}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        if (product.hasFlashsale) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              '⚡ FLASH SALE',
                              style: TextStyle(
                                color: Colors.white,
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
                    product.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Category & Rating
                  Row(
                    children: [
                      if (product.categoryName != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            product.categoryName!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue[700],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      if (product.rating != null) ...[
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          product.rating!.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Price Section
                  if (product.hasDiscount) ...[
                    Text(
                      product.formattedOriginalPrice,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.formattedPrice,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Hemat ${(product.originalPrice - product.priceAfterAllDiscount).toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ] else
                    Text(
                      product.formattedPrice,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),

                  const SizedBox(height: 16),

                  // Stock Info
                  Row(
                    children: [
                      const Text('Stok: ', style: TextStyle(fontSize: 14)),
                      Text(
                        product.stock > 0
                            ? '${product.stock} tersedia'
                            : 'Habis',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: product.stock > 0 ? Colors.green : Colors.red,
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
                    product.description.isNotEmpty
                        ? product.description
                        : 'Tidak ada deskripsi',
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Flash Sale Info
                  if (product.hasFlashsale && product.flashsaleName != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange[200]!),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.flash_on,
                            color: Colors.orange,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Flash Sale: ${product.flashsaleName}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

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
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(20),
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
                  onPressed: product.stock > 0
                      ? () async {
                          if (!authController.isLoggedIn) {
                            Get.snackbar(
                              'Autentikasi Diperlukan',
                              'Silakan login terlebih dahulu',
                            );
                            return;
                          }

                          await favoriteController.toggleFavorite(product.id);
                        }
                      : null,
                  icon: Icon(
                    favoriteController.isProductFavorited(product.id)
                        ? Icons.favorite
                        : Icons.favorite_border,
                  ),
                  label: Text(
                    favoriteController.isProductFavorited(product.id)
                        ? 'Hapus dari Favorit'
                        : 'Tambah ke Favorit',
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
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
                onPressed: product.stock > 0
                    ? () async {
                        await cartController.addToCart(product.id, quantity: 1);
                      }
                    : null,
                icon: const Icon(Icons.shopping_cart),
                label: const Text('Tambah ke Keranjang'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
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
}
