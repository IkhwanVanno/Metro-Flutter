import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/controller/product_controller.dart';
import 'package:metro/routes/app_routes.dart';
import 'package:metro/theme/app_theme.dart';

class SearchResultPage extends StatelessWidget {
  const SearchResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController(), permanent: true);
    final searchController = TextEditingController();
    searchController.text = controller.searchQuery.value;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 1,
        title: TextField(
          controller: searchController,
          autofocus: false,
          decoration: InputDecoration(
            hintText: 'Cari produk...',
            border: InputBorder.none,
            suffixIcon: Obx(
              () => controller.searchQuery.value.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                        controller.clearSearch();
                      },
                    )
                  : const SizedBox.shrink(),
            ),
          ),
          onChanged: (value) => controller.searchProducts(value),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort, color: AppColors.black),
            onSelected: controller.sortProducts,
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'Terbaru', child: Text('Terbaru')),
              const PopupMenuItem(
                value: 'Termurah',
                child: Text('Harga Terendah'),
              ),
              const PopupMenuItem(
                value: 'Termahal',
                child: Text('Harga Tertinggi'),
              ),
              const PopupMenuItem(value: 'Nama A-Z', child: Text('Nama A-Z')),
              const PopupMenuItem(value: 'Nama Z-A', child: Text('Nama Z-A')),
              const PopupMenuItem(
                value: 'Rating Tertinggi',
                child: Text('Rating Tertinggi'),
              ),
            ],
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 60, color: AppColors.red),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.red),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => controller.fetchProducts(),
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          );
        }

        final results = controller.filteredProducts;

        if (results.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 80, color: AppColors.grey),
                const SizedBox(height: 16),
                Text(
                  controller.searchQuery.value.isNotEmpty
                      ? 'Tidak ada produk dengan kata kunci "${controller.searchQuery.value}"'
                      : 'Tidak ada produk ditemukan',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: AppColors.grey),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Search Info & Sort Info
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: AppColors.grey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${results.length} produk ditemukan',
                    style: const TextStyle(fontSize: 13),
                  ),
                  Obx(
                    () => Text(
                      'Urut: ${controller.sortOption.value}',
                      style: TextStyle(fontSize: 13, color: AppColors.black),
                    ),
                  ),
                ],
              ),
            ),
            // Product Grid
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => controller.refreshProducts(),
                child: GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.65,
                  ),
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final product = results[index];
                    return GestureDetector(
                      onTap: () => Get.toNamed(
                        AppRoutes.productdetailpage,
                        arguments: product,
                      ),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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
                                      errorBuilder: (_, __, ___) =>
                                          const Center(
                                            child: Icon(
                                              Icons.broken_image,
                                              size: 40,
                                              color: AppColors.grey,
                                            ),
                                          ),
                                      loadingBuilder: (_, child, progress) {
                                        if (progress == null) return child;
                                        return const Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
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
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
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
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
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
                                              product.rating!.toStringAsFixed(
                                                1,
                                              ),
                                              style: const TextStyle(
                                                fontSize: 10,
                                              ),
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
                  },
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
