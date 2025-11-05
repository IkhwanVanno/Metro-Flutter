import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/controller/auth_controller.dart';
import 'package:metro/controller/favorite_controller.dart';
import 'package:metro/models/product_model.dart';
import 'package:metro/pages/product_detail_page.dart';
import 'package:metro/routes/app_routes.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final favoriteController = Get.put(FavoriteController());
  final authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    if (authController.isLoggedIn) {
      favoriteController.fetchFavorites();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorit Saya',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: Obx(() {
        if (!authController.isLoggedIn) {
          return _buildLoginPrompt();
        }
        return _buildFavoriteList();
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
                color: Colors.blue.withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border,
                size: 80,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Login Required',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Please login to view your favorite products',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  Get.toNamed(AppRoutes.login);
                },
                child: const Text(
                  'Login Now',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account? ",
                  style: TextStyle(color: Colors.grey),
                ),
                TextButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.register);
                  },
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteList() {
    return RefreshIndicator(
      onRefresh: () async => await favoriteController.fetchFavorites(),
      child: Obx(() {
        if (favoriteController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final favorites = favoriteController.favorites;
        if (favorites.isEmpty) {
          return const Center(
            child: Text(
              'Belum ada produk favorit',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final fav = favorites[index];
            final Product? product = fav.product;

            if (product == null) {
              return const SizedBox();
            }

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Get.to(
                    () => ProductDetailPage(product: product),
                  )!.then((_) => favoriteController.fetchFavorites());
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                      child: Image.network(
                        product.imageUrl,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stack) =>
                            const Icon(Icons.broken_image, size: 80),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              product.formattedPrice,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  product.rating?.toStringAsFixed(1) ?? '0.0',
                                  style: const TextStyle(fontSize: 13),
                                ),
                                const Spacer(),
                                Text(
                                  product.stock > 0
                                      ? 'Stok: ${product.stock}'
                                      : 'Stok habis',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: product.stock > 0
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.redAccent,
                      ),
                      onPressed: () {
                        Get.defaultDialog(
                          title: 'Hapus Favorit',
                          middleText:
                              'Apakah kamu yakin ingin menghapus produk ini?',
                          textCancel: 'Batal',
                          textConfirm: 'Hapus',
                          confirmTextColor: Colors.white,
                          buttonColor: Colors.redAccent,
                          onConfirm: () {
                            favoriteController.removeFromFavorite(fav.id);
                            Get.back();
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
