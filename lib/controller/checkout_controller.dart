import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:group_button/group_button.dart';
import 'package:metro/models/city_model.dart';
import 'package:metro/models/distric_model.dart';
import 'package:metro/models/payment_method_model.dart';
import 'package:metro/models/province_model.dart';
import 'package:metro/models/shipping_address_model.dart';
import 'package:metro/models/shipping_cost_model.dart';
import 'package:metro/services/api_service.dart';

class CheckoutController extends GetxController {
  // Group Button Controllers
  final shippingGroupController = GroupButtonController();
  final paymentGroupController = GroupButtonController();

  // Cart summary
  var cartItems = <Map<String, dynamic>>[].obs;
  var totalItems = 0.obs;
  var totalWeight = 0.obs;
  var originalTotal = 0.0.obs;
  var productDiscount = 0.0.obs;
  var flashsaleDiscount = 0.0.obs;
  var subtotal = 0.0.obs;

  // Address
  var addresses = <ShippingAddress>[].obs;
  var selectedAddress = Rx<ShippingAddress?>(null);
  var isLoadingAddresses = false.obs;

  // Shipping
  var provinces = <Province>[].obs;
  var cities = <City>[].obs;
  var districts = <District>[].obs;
  var shippingCosts = <ShippingCost>[].obs;
  var selectedShippingCost = Rx<ShippingCost?>(null);
  var selectedShippingIndex = Rx<int?>(null);
  var isLoadingShipping = false.obs;

  // Courier
  var couriers = [
    'jne',
    'sicepat',
    'ide',
    'sap',
    'jnt',
    'ninja',
    'tiki',
    'lion',
    'anteraja',
    'pos',
    'ncs',
    'rex',
    'rpx',
    'sentral',
    'star',
    'wahana',
    'dse',
  ].obs;
  var selectedCourier = ''.obs;

  // Payment
  var paymentMethods = <PaymentMethod>[].obs;
  var selectedPaymentMethod = Rx<PaymentMethod?>(null);
  var selectedPaymentIndex = Rx<int?>(null);
  var isLoadingPayment = false.obs;

  // General
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCheckoutData();
  }

  @override
  void onClose() {
    shippingGroupController.dispose();
    paymentGroupController.dispose();
    super.onClose();
  }

  Future<void> loadCheckoutData() async {
    isLoading(true);
    await Future.wait([fetchCartSummary(), fetchAddresses()]);
    if (addresses.isNotEmpty) {
      final defaultAddress = addresses.firstWhereOrNull(
        (addr) => addr.isDefault,
      );
      selectedAddress.value = defaultAddress ?? addresses.first;
      await checkShippingCost();
      await fetchPaymentMethods();
    }
    isLoading(false);
  }

  // ========== CART ==========
  Future<void> fetchCartSummary() async {
    try {
      final response = await ApiService.getCart();
      if (response['success'] == true && response['data'] != null) {
        final data = response['data'];
        cartItems.value = List<Map<String, dynamic>>.from(data['items'] ?? []);

        final summary = data['summary'];
        totalItems.value = summary['total_items'] ?? 0;
        totalWeight.value = summary['total_weight'] ?? 0;
        originalTotal.value =
            (summary['original_total'] as num?)?.toDouble() ?? 0.0;
        productDiscount.value =
            (summary['product_discount'] as num?)?.toDouble() ?? 0.0;
        flashsaleDiscount.value =
            (summary['flashsale_discount'] as num?)?.toDouble() ?? 0.0;
        subtotal.value = (summary['subtotal'] as num?)?.toDouble() ?? 0.0;
      }
    } catch (e) {
      print('Error fetching cart summary: $e');
    }
  }

  // ========== ADDRESS ==========
  Future<void> fetchAddresses() async {
    try {
      isLoadingAddresses(true);
      final response = await ApiService.getAddresses();

      if (response['success'] == true) {
        addresses.value = response['data'] as List<ShippingAddress>;
      } else {
        print('Failed to load addresses: ${response['message']}');
      }
    } catch (e) {
      print('Error fetching addresses: $e');
    } finally {
      isLoadingAddresses(false);
    }
  }

  Future<void> fetchProvinces() async {
    try {
      provinces.clear();
      final response = await ApiService.getProvinces();
      if (response['success'] == true) {
        provinces.value = (response['data'] as List)
            .map((item) => Province.fromJson(item))
            .toList();
      }
    } catch (e) {
      print('Error fetching provinces: $e');
      Get.snackbar(
        'Error',
        'Gagal memuat provinsi',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> fetchCities(String provinceId) async {
    try {
      cities.clear();
      districts.clear();
      final response = await ApiService.getCities(provinceId);
      if (response['success'] == true) {
        cities.value = (response['data'] as List)
            .map((item) => City.fromJson(item))
            .toList();
      }
    } catch (e) {
      print('Error fetching cities: $e');
      Get.snackbar(
        'Error',
        'Gagal memuat kota',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> fetchDistricts(String cityId) async {
    try {
      districts.clear();
      final response = await ApiService.getDistricts(cityId);
      if (response['success'] == true) {
        districts.value = (response['data'] as List)
            .map((item) => District.fromJson(item))
            .toList();
      }
    } catch (e) {
      print('Error fetching districts: $e');
      Get.snackbar(
        'Error',
        'Gagal memuat kecamatan',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> addAddress(Map<String, dynamic> addressData) async {
    try {
      final response = await ApiService.addAddress(
        receiverName: addressData['receiver_name'],
        phoneNumber: addressData['phone_number'],
        address: addressData['address'],
        provinceId: addressData['province_id'],
        provinceName: addressData['province_name'],
        cityId: addressData['city_id'],
        cityName: addressData['city_name'],
        districtId: addressData['district_id'],
        districtName: addressData['district_name'],
        postalCode: addressData['postal_code'],
        isDefault: addressData['is_default'] ?? false,
      );

      if (response['success'] == true) {
        await fetchAddresses();
        if (addresses.isNotEmpty) {
          final newAddress = addresses.last;
          selectedAddress.value = newAddress;
          await checkShippingCost();
        }

        Get.snackbar(
          'Berhasil',
          'Alamat berhasil ditambahkan',
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      throw Exception(response['message'] ?? 'Gagal menambahkan alamat');
    } catch (e) {
      Get.snackbar(
        'Gagal',
        e.toString(),
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> updateAddress(int id, Map<String, dynamic> data) async {
    try {
      isLoadingAddresses.value = true;
      final response = await ApiService.updateAddress(id, data);

      if (response['success'] == true) {
        await fetchAddresses();
        Get.snackbar('Berhasil', response['message'] ?? 'Alamat berhasil diperbarui');
      } else {
        Get.snackbar('Gagal', response['message'] ?? 'Gagal memperbarui alamat');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoadingAddresses.value = false;
    }
  }

  Future<void> deleteAddress(int id) async {
    try {
      isLoadingAddresses.value = true;
      final response = await ApiService.deleteAddress(id);

      if (response['success'] == true) {
        addresses.removeWhere((a) => a.id == id);
        Get.snackbar('Berhasil', response['message'] ?? 'Alamat berhasil dihapus');
      } else {
        Get.snackbar('Gagal', response['message'] ?? 'Gagal menghapus alamat');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoadingAddresses.value = false;
    }
  }

  void selectAddress(ShippingAddress address) {
    selectedAddress.value = address;
    selectedShippingCost.value = null;
    selectedShippingIndex.value = null;
    shippingGroupController.unselectAll();

    // Reset payment selection
    selectedPaymentMethod.value = null;
    selectedPaymentIndex.value = null;
    paymentGroupController.unselectAll();

    checkShippingCost();
  }

  // ========== SHIPPING ==========
  Future<void> checkShippingCost() async {
    if (selectedAddress.value == null || totalWeight.value == 0) {
      print(
        'Cannot check shipping: address=${selectedAddress.value != null}, weight=$totalWeight',
      );
      return;
    }

    try {
      isLoadingShipping(true);
      shippingCosts.clear();
      selectedShippingCost.value = null;
      selectedShippingIndex.value = null;
      shippingGroupController.unselectAll();

      final response = await ApiService.checkOngkir(
        destination: selectedAddress.value!.districtId.toString(),
        weight: totalWeight.value,
        courier: selectedCourier.value.isNotEmpty
            ? selectedCourier.value
            : 'jne',
      );

      if (response['success'] == true && response['data'] != null) {
        final data = response['data'];

        if (data is List && data.isNotEmpty) {
          shippingCosts.value = data
              .map((item) => ShippingCost.fromJson(item))
              .toList();
        } else {
          throw Exception('Data ongkir kosong atau format tidak sesuai');
        }

        if (shippingCosts.isEmpty) {
          throw Exception('Tidak ada layanan pengiriman tersedia');
        }
      } else {
        throw Exception(response['message'] ?? 'Gagal mengecek ongkir');
      }
    } catch (e) {
      print('Error checking shipping cost: $e');
      Get.snackbar(
        'Error',
        'Gagal mengecek ongkir: ${e.toString()}',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoadingShipping(false);
    }
  }

  void selectShippingCost(ShippingCost cost, int index) {
    selectedShippingCost.value = cost;
    selectedShippingIndex.value = index;

    // Reset payment selection dan fetch ulang
    selectedPaymentMethod.value = null;
    selectedPaymentIndex.value = null;

    // Update payment methods dengan grand total baru
    fetchPaymentMethods();
  }

  // ========== PAYMENT ==========
  Future<void> fetchPaymentMethods() async {
    try {
      isLoadingPayment(true);
      final amount = calculateGrandTotal();

      final response = await ApiService.getPaymentMethods(amount: amount);

      if (response['success'] == true) {
        paymentMethods.value = (response['data'] as List)
            .map((item) => PaymentMethod.fromJson(item))
            .toList();

        // Reset payment selection
        selectedPaymentMethod.value = null;
        selectedPaymentIndex.value = null;
        paymentGroupController.unselectAll();
      }
    } catch (e) {
      print('Error fetching payment methods: $e');
    } finally {
      isLoadingPayment(false);
    }
  }

  void selectPaymentMethod(PaymentMethod method, int index) {
    selectedPaymentMethod.value = method;
    selectedPaymentIndex.value = index;
  }

  // ========== CALCULATION ==========
  double calculateGrandTotal() {
    double total = subtotal.value;

    if (selectedShippingCost.value != null) {
      final dynamic costRaw = selectedShippingCost.value!.cost;
      double shippingCostDouble;
      if (costRaw is num) {
        shippingCostDouble = (costRaw).toDouble();
      } else {
        shippingCostDouble = double.tryParse(costRaw?.toString() ?? '') ?? 0.0;
      }
      total += shippingCostDouble;
    }

    if (selectedPaymentMethod.value != null) {
      final dynamic feeRaw = selectedPaymentMethod.value!.totalFee;
      double feeDouble;
      if (feeRaw is num) {
        feeDouble = (feeRaw).toDouble();
      } else {
        feeDouble = double.tryParse(feeRaw?.toString() ?? '') ?? 0.0;
      }
      total += feeDouble;
    }

    return total;
  }

  // ========== CREATE ORDER ==========
  Future<Map<String, dynamic>> createOrder() async {
    if (selectedAddress.value == null) {
      return {'success': false, 'message': 'Pilih alamat pengiriman'};
    }

    if (selectedShippingCost.value == null) {
      return {'success': false, 'message': 'Pilih metode pengiriman'};
    }

    if (selectedPaymentMethod.value == null) {
      return {'success': false, 'message': 'Pilih metode pembayaran'};
    }

    try {
      isLoading(true);

      final response = await ApiService.createOrder(
        addressId: selectedAddress.value!.id,
        paymentMethod: selectedPaymentMethod.value!.paymentMethod,
        shippingCost: selectedShippingCost.value!.cost,
        courierService: 'JNE ${selectedShippingCost.value!.service}',
      );

      if (response['success'] == true) {
        final orderId = response['data']['order_id'];

        // Initiate payment
        final paymentResponse = await ApiService.initiatePayment(orderId);

        if (paymentResponse['success'] == true) {
          return {
            'success': true,
            'order_id': orderId,
            'order_code': response['data']['order_code'],
            'payment_url': paymentResponse['data']['payment_url'],
          };
        }

        return paymentResponse;
      }

      return response;
    } catch (e) {
      print('Error creating order: $e');
      return {'success': false, 'message': 'Gagal membuat pesanan'};
    } finally {
      isLoading(false);
    }
  }

  // ========== HELPERS ==========
  String formatCurrency(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }
}
