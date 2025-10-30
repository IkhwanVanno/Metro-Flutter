import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:metro/controller/product_controller.dart';
import 'package:metro/controller/siteconfig_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import '../routes/app_routes.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final siteController = Get.put(SiteconfigController());

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!siteController.hasShownPopup.value) {
        if (siteController.popupAds.isNotEmpty) {
          siteController.hasShownPopup.value = true;
          _showSequentialPopups(siteController);
        } else {
          ever(siteController.popupAds, (ads) {
            if (ads.isNotEmpty && !siteController.hasShownPopup.value) {
              siteController.hasShownPopup.value = true;
              _showSequentialPopups(siteController);
            }
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Obx(() {
          final site = siteController.siteConfig.value;
          return AppBar(
            backgroundColor: Colors.white,
            elevation: 1,
            titleSpacing: 0,
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 12.0),
                  child: site != null && site.logoUrl.isNotEmpty
                      ? Image.network(
                          site.logoUrl,
                          height: 36,
                          fit: BoxFit.contain,
                        )
                      : const Text(
                          'Home',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed(
                        AppRoutes.searchresultpage,
                      ); // arahkan ke halaman pencarian
                    },
                    child: Container(
                      height: 38,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.search, color: Colors.grey),
                          SizedBox(width: 6),
                          Text(
                            'Cari produk...',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.black,
                  ),
                  onPressed: () => Get.toNamed(AppRoutes.cartpage),
                ),
                IconButton(
                  icon: const Icon(Icons.favorite_border, color: Colors.black),
                  onPressed: () => Get.toNamed(AppRoutes.favoritepage),
                ),
              ],
            ),
          );
        }),
      ),
      body: Obx(() {
        if (siteController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (siteController.errorMessage.isNotEmpty) {
          return Center(child: Text(siteController.errorMessage.value));
        }

        final site = siteController.siteConfig.value;
        final carousels = siteController.carousels;
        final eventShop = siteController.eventShops;
        final flashSale = siteController.flashSales;

        return ListView(
          padding: const EdgeInsets.all(8),
          children: [
            if (carousels.isNotEmpty)
              CarouselSlider(
                options: CarouselOptions(
                  height: 80,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.9,
                ),
                items: carousels.map((item) {
                  return Builder(
                    builder: (BuildContext context) => ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: GestureDetector(
                        onTap: () async {
                          if (item.link.isNotEmpty) {
                            try {
                              final Uri url = Uri.parse(item.link);
                              if (!await launchUrl(
                                url,
                                mode: LaunchMode.externalApplication,
                              )) {
                                Get.snackbar(
                                  'Error',
                                  'Tidak dapat membuka tautan',
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              }
                            } catch (e) {
                              Get.snackbar(
                                'Error',
                                'Tautan tidak valid: ${item.link}',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            }
                          }
                        },
                        child: Image.network(
                          item.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(Icons.broken_image),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            const SizedBox(height: 20),
            if (site != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  site.aboutTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  site.aboutDescription,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSubAboutText(
                    site.subAbout1Title,
                    site.subAbout1Description,
                  ),
                  _buildSubAboutText(
                    site.subAbout2Title,
                    site.subAbout2Description,
                  ),
                  _buildSubAboutText(
                    site.subAbout3Title,
                    site.subAbout3Description,
                  ),
                  _buildSubAboutText(
                    site.subAbout4Title,
                    site.subAbout4Description,
                  ),
                ],
              ),
            ],
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Flash Sale',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ),
            CarouselSlider(
              options: CarouselOptions(
                height: 80,
                autoPlay: false,
                enlargeCenterPage: true,
                viewportFraction: 0.9,
              ),
              items: flashSale.map((item) {
                return ClipRRect(
                  child: Image.network(
                    item.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Event Shop',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ),
            CarouselSlider(
              options: CarouselOptions(
                height: 180,
                autoPlay: false,
                enlargeCenterPage: true,
                viewportFraction: 0.9,
              ),
              items: eventShop.map((item) {
                return ClipRRect(
                  child: Image.network(
                    item.image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Produk Terbaru',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Bagian Product Grid di Home Page
            GetX<ProductController>(
              init: ProductController(),
              builder: (controller) {
                if (controller.isLoading.value) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (controller.errorMessage.isNotEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            controller.errorMessage.value,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () => controller.fetchProducts(),
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (controller.products.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text('Tidak ada produk tersedia'),
                    ),
                  );
                }

                // Batasi jumlah produk yang ditampilkan di home (max 6)
                final displayProducts = controller.products.take(6).toList();

                return Column(
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(8),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 0.65,
                          ),
                      itemCount: displayProducts.length,
                      itemBuilder: (context, index) {
                        final product = displayProducts[index];
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
                                // Product Image
                                Expanded(
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                              top: Radius.circular(12),
                                            ),
                                        child: Image.network(
                                          product.imageUrl,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          loadingBuilder:
                                              (context, child, progress) {
                                                if (progress == null) {
                                                  return child;
                                                }
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              },
                                          errorBuilder:
                                              (context, error, stack) =>
                                                  const Center(
                                                    child: Icon(
                                                      Icons.broken_image,
                                                      size: 50,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
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
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              '-${product.discountPercentage.toStringAsFixed(2)}%',
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
                                              color: Colors.orange,
                                              borderRadius:
                                                  BorderRadius.circular(4),
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
                                // Product Info
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Product Name
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
                                      // Category & Rating
                                      if (product.categoryName != null)
                                        Text(
                                          product.categoryName!,
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      if (product.rating != null)
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.star,
                                              size: 12,
                                              color: Colors.amber,
                                            ),
                                            const SizedBox(width: 2),
                                            Text(
                                              product.rating!.toStringAsFixed(
                                                1,
                                              ),
                                              style: const TextStyle(
                                                fontSize: 11,
                                              ),
                                            ),
                                          ],
                                        ),
                                      const SizedBox(height: 4),
                                      // Price
                                      if (product.hasDiscount) ...[
                                        Text(
                                          product.formattedOriginalPrice,
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey[600],
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                        Text(
                                          product.formattedPrice,
                                          style: const TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ] else
                                        Text(
                                          product.formattedPrice,
                                          style: const TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      // Stock Info
                                      Text(
                                        'Stok: ${product.stock}',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: product.stock > 0
                                              ? Colors.green
                                              : Colors.red,
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
                    // Tombol Lihat Semua Produk
                    if (controller.products.length > 6)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () =>
                                Get.toNamed(AppRoutes.searchresultpage),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: const BorderSide(color: Colors.blue),
                            ),
                            child: const Text('Lihat Semua Produk'),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSubAboutText(String title, String description) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Text(
              title,
              textAlign: TextAlign.start,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  // Show Pop-Up
  void _showSequentialPopups(SiteconfigController controller) async {
    for (var popup in controller.popupAds) {
      await Get.dialog(
        Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                color: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (popup.link.isNotEmpty) {
                          await _openUrl(popup.link);
                        }
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          popup.image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text(
                        'Tutup',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        barrierDismissible: true,
      );
    }
  }

  Future<void> _openUrl(String url) async {
    try {
      final uri = Uri.tryParse(url);
      if (uri == null) {
        Get.snackbar(
          'Error',
          'URL tidak valid',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Error',
          'Tidak dapat membuka tautan $url',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}
