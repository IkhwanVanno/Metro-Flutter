import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/models/cart_item_model.dart';
import 'package:metro/models/product_model.dart';
import 'package:metro/services/api_service.dart';

class CartController extends GetxController {
  var carts = <CartItem>[].obs;
  var isLoading = false.obs;

  Future<void> fetchCartItems() async {
    try {
      isLoading(true);
      carts.clear();

      final response = await ApiService.getCart();
      if (response['success'] == true && response['data'] != null) {
        final items = response['data']['items'] as List? ?? [];

        carts.value = items.map((item) {
          return CartItem(
            id: item['id'],
            quantity: item['quantity'] ?? 0,
            product: Product(
              id: item['product_id'] ?? 0,
              name: item['product_name'] ?? '',
              stock: item['stock'] ?? 0,
              rating: Product.parseDouble(item['rating']),
              priceAfterAllDiscount: Product.parseDouble(item['price']),
              originalPrice: Product.parseDouble(item['original_price']),
              description: item['description'] ?? '',
              imageUrl: item['image_url'] ?? '',
            ),
          );
        }).toList();
      } else {
        carts.clear();
      }
    } catch (e, st) {
      print('Error fetchCarts: $e');
      print(st);
    } finally {
      isLoading(false);
    }
  }

  Future<void> addToCart(int productId, {int quantity = 1}) async {
    final response = await ApiService.addToCart(productId, quantity);
    if (response['success'] == true) {
      await fetchCartItems();
      Get.snackbar(
        'Berhasil',
        'Produk berhasil ditambahkan ke keranjang.',
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        icon: const Icon(Icons.check, color: Colors.white),
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(10),
      );
    } else {
      Get.snackbar(
        'Gagal',
        response['message'] ?? 'Gagal menambahkan produk ke keranjang.',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(10),
      );
    }
  }

  Future<void> updateCart(int cartId, int quantity) async {
    final response = await ApiService.updateCartItem(cartId, quantity);
    if (response['success'] == true) {
      await fetchCartItems();
      Get.snackbar(
        'Berhasil',
        'Jumlah produk di keranjang berhasil diperbarui.',
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        icon: const Icon(Icons.check, color: Colors.white),
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(10),
      );
    } else {
      Get.snackbar(
        'Gagal',
        response['message'] ?? 'Gagal memperbarui jumlah produk di keranjang.',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(10),
      );
    }
  }

  Future<void> removeFromCart(int cartId) async {
    final response = await ApiService.removeFromCart(cartId);
    if (response['success'] == true) {
      await fetchCartItems();
      Get.snackbar(
        'Berhasil',
        'Produk berhasil dihapus dari keranjang.',
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        icon: const Icon(Icons.check, color: Colors.white),
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(10),
      );
    } else {
      Get.snackbar(
        'Gagal',
        response['message'] ?? 'Gagal menghapus produk dari keranjang.',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(10),
      );
    }
  }

  Future<void> clearCart() async {
    final response = await ApiService.clearCart();
    if (response['success'] == true) {
      carts.clear();
      Get.snackbar(
        'Berhasil',
        'Keranjang berhasil dikosongkan.',
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        icon: const Icon(Icons.check, color: Colors.white),
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(10),
      );
    } else {
      Get.snackbar(
        'Gagal',
        response['message'] ?? 'Gagal mengosongkan keranjang.',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(10),
      );
    }
  }
}
