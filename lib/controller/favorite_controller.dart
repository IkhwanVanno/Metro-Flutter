import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/models/favorite_model.dart';
import 'package:metro/models/product_model.dart';
import 'package:metro/services/api_service.dart';
import 'package:metro/theme/app_theme.dart';

class FavoriteController extends GetxController {
  var favorites = <Favorite>[].obs;
  var isLoading = false.obs;

  Future<void> fetchFavorites() async {
    try {
      isLoading(true);
      favorites.clear();

      final response = await ApiService.getFavorites();
      if (response['success'] == true && response['data'] != null) {
        final List data = response['data'];

        favorites.value = data.map((item) {
          return Favorite(
            id: item['id'],
            product: Product(
              id: item['product_id'] ?? 0,
              name: item['product_name'] ?? '',
              stock: item['stock'] ?? 0,
              priceAfterAllDiscount: Product.parseDouble(item['price'] ?? 0),
              originalPrice: Product.parseDouble(item['original_price'] ?? 0),
              description: item['description'] ?? '',
              imageUrl: item['image_url'] ?? '',
              categoryName: item['category_name'],
              rating: item['rating'] != null
                  ? Product.parseDouble(item['rating'])
                  : 0,
              hasFlashsale: item['has_flashsale'] ?? false,
              flashsaleName: item['flashsale_name'],
            ),
          );
        }).toList();
      } else {
        favorites.clear();
      }
    } catch (e, st) {
      print('Error fetchFavorites: $e');
      print(st);
    } finally {
      isLoading(false);
    }
  }

  Future<Map<String, dynamic>> checkFavorite(int productId) async {
    final response = await ApiService.checkFavorite(productId);
    return response;
  }

  Future<void> addToFavorite(int productId) async {
    final response = await ApiService.addToFavorites(productId);
    if (response['success'] == true) {
      await fetchFavorites();
      Get.snackbar(
        'Berhasil',
        response['message'] ?? 'Produk ditambahkan ke favorit',
        backgroundColor: AppColors.green,
        colorText: AppColors.white,
        icon: const Icon(Icons.check_circle, color: AppColors.white),
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(10),
      );
    } else {
      Get.snackbar(
        'Gagal',
        response['message'] ?? 'Gagal menambahkan produk ke favorit',
        backgroundColor: AppColors.red,
        colorText: AppColors.white,
        icon: const Icon(Icons.error, color: AppColors.white),
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(10),
      );
    }
  }

  Future<void> removeFromFavorite(int favoriteId) async {
    final response = await ApiService.removeFromFavorites(favoriteId);
    if (response['success'] == true) {
      favorites.removeWhere((fav) => fav.id == favoriteId);
      Get.snackbar(
        'Berhasil',
        response['message'] ?? 'Produk dihapus dari favorit',
        backgroundColor: AppColors.green,
        colorText: AppColors.white,
        icon: const Icon(Icons.check_circle, color: AppColors.white),
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(10),
      );
    } else {
      Get.snackbar(
        'Gagal',
        response['message'] ?? 'Gagal menghapus produk dari favorit',
        backgroundColor: AppColors.red,
        colorText: AppColors.white,
        icon: const Icon(Icons.error, color: AppColors.white),
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(10),
      );
    }
  }

  Future<void> toggleFavorite(int productId) async {
    final check = await checkFavorite(productId);
    if (check['is_favorited'] == true) {
      final favId = check['favorite_id'];
      await removeFromFavorite(favId);
    } else {
      await addToFavorite(productId);
    }
  }

  bool isProductFavorited(int productId) {
    return favorites.any((fav) => fav.product?.id == productId);
  }
}
