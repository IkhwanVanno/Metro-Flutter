import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:metro/controller/siteconfig_controller.dart';
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
                  child: Container(
                    height: 38,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        hintStyle: const TextStyle(fontSize: 14),
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
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
                    Image.network(popup.image, fit: BoxFit.cover),
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
}
