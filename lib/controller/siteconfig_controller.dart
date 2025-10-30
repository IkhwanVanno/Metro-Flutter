import 'package:get/get.dart';
import 'package:metro/models/eventshop_model.dart';
import 'package:metro/models/flashsale_model.dart';
import 'package:metro/models/popupad_model.dart';
import 'package:metro/models/siteconfig_model.dart';
import 'package:metro/models/carousel_model.dart';
import 'package:metro/services/api_service.dart';

class SiteconfigController extends GetxController {
  var siteConfig = Rxn<SiteConfig>();
  var carousels = <Carousel>[].obs;
  var eventShops = <Eventshop>[].obs;
  var popupAds = <Popupad>[].obs;
  var flashSales = <Flashsale>[].obs;
  var hasShownPopup = false.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Fetch Site Config
      final siteConfigResponse = await ApiService.getSiteConfig();
      if (siteConfigResponse['success'] == true) {
        siteConfig.value = siteConfigResponse['data'];
      } else {
        errorMessage.value =
            siteConfigResponse['message'] ?? 'Gagal memuat konfigurasi situs';
      }

      // Fetch Carousels
      final carouselResponse = await ApiService.getCarousels();
      if (carouselResponse['success'] == true) {
        carousels.assignAll(carouselResponse['data']);
      } else {
        errorMessage.value =
            carouselResponse['message'] ?? 'Gagal memuat carousel';
      }

      // Fetch Event Shops
      final eventShopResponse = await ApiService.getEventShops();
      if (eventShopResponse['success'] == true) {
        eventShops.assignAll(eventShopResponse['data']);
      } else {
        errorMessage.value =
            eventShopResponse['message'] ?? 'Gagal memuat event shops';
      }

      // Fetch Pop-Up
      final popupResponse = await ApiService.getPopupAds();
      if (popupResponse['success'] == true) {
        popupAds.assignAll(popupResponse['data']);
      } else {
        errorMessage.value =
            popupResponse['message'] ?? 'Gagal memuat Pop-Up';
            print('data');
      }

      // Fetch FlashSale
      final flashsaleResponse = await ApiService.getFlashSales();
      if (flashsaleResponse['success'] == true) {
        flashSales.assignAll(flashsaleResponse['data']);
      } else {
        errorMessage.value =
            flashsaleResponse['message'] ?? 'Gagal memuat Flash Sale';
            print('data');
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
