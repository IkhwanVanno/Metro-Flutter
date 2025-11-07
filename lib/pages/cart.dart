import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/controller/auth_controller.dart';
import 'package:metro/controller/cart_controller.dart';
import 'package:metro/pages/checkout.dart';
import 'package:metro/pages/product_detail_page.dart';
import 'package:metro/routes/app_routes.dart';
import 'package:metro/theme/app_theme.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final cartController = Get.put(CartController());
  final authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    if (authController.isLoggedIn) {
      cartController.fetchCartItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Keranjang Saya',
          style: TextStyle(color: AppColors.black),
        ),
        iconTheme: const IconThemeData(color: AppColors.black),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
      ),
      body: Obx(() {
        if (!authController.isLoggedIn) {
          return _buildLoginPrompt();
        } else {
          return _buildCartList();
        }
      }),

      bottomNavigationBar: Obx(() {
        if (!authController.isLoggedIn || cartController.carts.isEmpty) {
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
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Get.to(() => const CheckoutPage());
              },

              child: const Text(
                'Checkout',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
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
                color: AppColors.primary.withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_cart,
                size: 80,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Login Required',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Please login to view your cart products',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: AppColors.grey),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
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
                    color: AppColors.white,
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
                  style: TextStyle(color: AppColors.grey),
                ),
                TextButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.register);
                  },
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      color: AppColors.primary,
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

  Widget _buildCartList() {
    return RefreshIndicator(
      onRefresh: () async => await cartController.fetchCartItems(),
      child: Obx(() {
        if (cartController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (cartController.carts.isEmpty) {
          return const Center(
            child: Text(
              'Keranjang kamu masih kosong.',
              style: TextStyle(fontSize: 16, color: AppColors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: cartController.carts.length,
          itemBuilder: (context, index) {
            final cartItem = cartController.carts[index];
            final product = cartItem.product!;
            const double cardHeight = 150;

            return SizedBox(
              height: cardHeight,
              child: Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Get.to(() => ProductDetailPage(product: product));
                  },
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                        child: Image.network(
                          product.imageUrl,
                          width: 120,
                          height: cardHeight,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stack) =>
                              const Icon(Icons.broken_image, size: 80),
                        ),
                      ),

                      // ===== Informasi Produk =====
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Nama Produk
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

                              // Harga Produk
                              Text(
                                product.formattedPrice,
                                style: const TextStyle(
                                  color: AppColors.red,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 8),

                              // Rating & Stok
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: AppColors.yellow,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    product.rating?.toStringAsFixed(1) ?? '0.0',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    product.stock > 0
                                        ? 'Stok: ${product.stock}'
                                        : 'Stok habis',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: product.stock > 0
                                          ? AppColors.green
                                          : AppColors.red,
                                    ),
                                  ),
                                ],
                              ),

                              const Spacer(),

                              // ===== Tombol Tengah (Tambah / Kurang / Hapus) =====
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Tombol Kurang
                                  IconButton(
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                    ),
                                    onPressed: () {
                                      if (cartItem.quantity > 1) {
                                        cartController.updateCart(
                                          cartItem.id,
                                          cartItem.quantity - 1,
                                        );
                                      }
                                    },
                                  ),
                                  Text(
                                    '${cartItem.quantity}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    onPressed: () {
                                      cartController.updateCart(
                                        cartItem.id,
                                        cartItem.quantity + 1,
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: AppColors.red,
                                    ),
                                    onPressed: () {
                                      Get.defaultDialog(
                                        title: 'Hapus Produk',
                                        middleText:
                                            'Apakah kamu yakin ingin menghapus produk ini dari keranjang?',
                                        textCancel: 'Batal',
                                        textConfirm: 'Hapus',
                                        confirmTextColor: AppColors.white,
                                        buttonColor: AppColors.red,
                                        onConfirm: () {
                                          cartController.removeFromCart(
                                            cartItem.id,
                                          );
                                          Get.back();
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
