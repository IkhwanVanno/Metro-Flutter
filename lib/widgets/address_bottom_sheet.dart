import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/controller/checkout_controller.dart';
import 'package:metro/models/shipping_address_model.dart';
import 'package:metro/theme/app_theme.dart';

class AddressBottomSheet extends StatelessWidget {
  final CheckoutController controller;

  const AddressBottomSheet({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    // Pastikan data alamat sudah di-load
    if (controller.addresses.isEmpty && !controller.isLoadingAddresses.value) {
      controller.fetchAddresses();
    }

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.grey,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pilih Alamat',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: () {
                    Get.back();
                    _showAddAddressDialog();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah'),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Address List
          Expanded(
            child: Obx(() {
              if (controller.isLoadingAddresses.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.addresses.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_off,
                          size: 80,
                          color: AppColors.grey,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Belum ada alamat tersimpan',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tambahkan alamat pengiriman Anda',
                          style: TextStyle(fontSize: 14, color: AppColors.grey),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            Get.back();
                            _showAddAddressDialog();
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Tambah Alamat'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.blue,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: controller.addresses.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final address = controller.addresses[index];
                  final isSelected =
                      controller.selectedAddress.value?.id == address.id;

                  return InkWell(
                    onTap: () {
                      controller.selectAddress(address);
                      Get.back();
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.grey,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: isSelected
                            ? AppColors.primary.withAlpha(30)
                            : AppColors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  address.receiverName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: AppColors.blue,
                                ),
                                tooltip: 'Edit Alamat',
                                onPressed: () {
                                  Get.back();
                                  _showAddAddressDialog(
                                    existingAddress: address,
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: AppColors.red,
                                ),
                                tooltip: 'Hapus Alamat',
                                onPressed: () {
                                  controller.deleteAddress(address.id);
                                },
                              ),

                              if (address.isDefault)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.green.withAlpha(30),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'Default',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: AppColors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              const SizedBox(width: 8),
                              if (isSelected)
                                const Icon(
                                  Icons.check_circle,
                                  color: AppColors.blue,
                                  size: 24,
                                ),
                            ],
                          ),

                          const SizedBox(height: 8),
                          Text(
                            address.phoneNumber.toString(),
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${address.address}, ${address.districtName}, ${address.cityName}, ${address.provinceName} ${address.postalCode}',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showAddAddressDialog({ShippingAddress? existingAddress}) {
    final formKey = GlobalKey<FormState>();
    final receiverController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();
    final postalCodeController = TextEditingController();

    final selectedProvinceId = Rx<String?>(null);
    final selectedProvinceName = Rx<String?>(null);
    final selectedCityId = Rx<String?>(null);
    final selectedCityName = Rx<String?>(null);
    final selectedDistrictId = Rx<String?>(null);
    final selectedDistrictName = Rx<String?>(null);
    final isDefault = false.obs;

    if (existingAddress != null) {
      receiverController.text = existingAddress.receiverName;
      phoneController.text = existingAddress.phoneNumber;
      addressController.text = existingAddress.address;
      postalCodeController.text = existingAddress.postalCode;
      selectedProvinceId.value = existingAddress.provinceId.toString();
      selectedProvinceName.value = existingAddress.provinceName;
      selectedCityId.value = existingAddress.cityId.toString();
      selectedCityName.value = existingAddress.cityName;
      selectedDistrictId.value = existingAddress.districtId.toString();
      selectedDistrictName.value = existingAddress.districtName;
      isDefault.value = existingAddress.isDefault;
    }

    // Load provinces on dialog open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchProvinces();
    });

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tambah Alamat Baru',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Get.back(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    controller: receiverController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Penerima',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Nomor Telepon',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      labelText: 'Alamat Lengkap',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.home),
                      hintText: 'Jalan, RT/RW, Kelurahan',
                    ),
                    maxLines: 3,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 12),

                  // Province Dropdown
                  Obx(() {
                    final provinceItems = controller.provinces
                        .map(
                          (p) => DropdownMenuItem<String>(
                            value: p.id,
                            child: Text(p.name),
                          ),
                        )
                        .toList();

                    return DropdownButtonFormField<String>(
                      isExpanded: true,
                      initialValue: selectedProvinceId.value,
                      items: provinceItems,
                      onChanged: (value) {
                        selectedProvinceId.value = value;
                        selectedProvinceName.value = controller.provinces
                            .firstWhere((p) => p.id == value)
                            .name;

                        // Reset turunan
                        selectedCityId.value = null;
                        selectedDistrictId.value = null;
                        controller.fetchCities(value!);
                      },
                      decoration: const InputDecoration(
                        labelText: 'Provinsi',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.map),
                      ),
                      validator: (value) =>
                          value == null ? 'Pilih provinsi' : null,
                      hint: const Text('Pilih Provinsi'),
                    );
                  }),

                  const SizedBox(height: 12),

                  // City Dropdown
                  Obx(() {
                    final cityItems = controller.cities
                        .map(
                          (c) => DropdownMenuItem<String>(
                            value: c.id,
                            child: Text(c.name),
                          ),
                        )
                        .toList();

                    return DropdownButtonFormField<String>(
                      isExpanded: true,
                      initialValue: selectedCityId.value,
                      items: cityItems,
                      onChanged: (value) {
                        selectedCityId.value = value;
                        selectedCityName.value = controller.cities
                            .firstWhere((c) => c.id == value)
                            .name;

                        // Reset district
                        selectedDistrictId.value = null;
                        controller.fetchDistricts(value!);
                      },
                      decoration: const InputDecoration(
                        labelText: 'Kota/Kabupaten',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_city),
                      ),
                      validator: (value) => value == null ? 'Pilih kota' : null,
                      hint: const Text('Pilih Kota'),
                    );
                  }),

                  const SizedBox(height: 12),

                  // District Dropdown
                  Obx(() {
                    final districtItems = controller.districts
                        .map(
                          (d) => DropdownMenuItem<String>(
                            value: d.id,
                            child: Text(d.name),
                          ),
                        )
                        .toList();

                    return DropdownButtonFormField<String>(
                      isExpanded: true,
                      initialValue: selectedDistrictId.value,
                      items: districtItems,
                      onChanged: (value) {
                        selectedDistrictId.value = value;
                        selectedDistrictName.value = controller.districts
                            .firstWhere((d) => d.id == value)
                            .name;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Kecamatan',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.place),
                      ),
                      validator: (value) =>
                          value == null ? 'Pilih kecamatan' : null,
                      hint: const Text('Pilih Kecamatan'),
                    );
                  }),

                  const SizedBox(height: 12),

                  TextFormField(
                    controller: postalCodeController,
                    decoration: const InputDecoration(
                      labelText: 'Kode Pos',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.local_post_office),
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 5,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 12),

                  Obx(
                    () => CheckboxListTile(
                      value: isDefault.value,
                      onChanged: (value) => isDefault.value = value ?? false,
                      title: const Text('Jadikan alamat utama'),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),

                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Get.back(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('Batal'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              final data = {
                                'receiver_name': receiverController.text,
                                'phone_number': phoneController.text,
                                'address': addressController.text,
                                'province_id': selectedProvinceId.value!,
                                'province_name': selectedProvinceName.value!,
                                'city_id': selectedCityId.value!,
                                'city_name': selectedCityName.value!,
                                'district_id': selectedDistrictId.value!,
                                'district_name': selectedDistrictName.value!,
                                'postal_code': postalCodeController.text,
                                'is_default': isDefault.value,
                              };

                              if (existingAddress != null) {
                                await controller.updateAddress(
                                  existingAddress.id,
                                  data,
                                );
                              } else {
                                await controller.addAddress(data);
                              }
                              Get.back();
                              if (Get.isBottomSheetOpen ?? false) {
                                Get.back();
                              }
                              Future.delayed(
                                const Duration(milliseconds: 300),
                                () {
                                  Get.bottomSheet(
                                    AddressBottomSheet(controller: controller),
                                    isScrollControlled: true,
                                    backgroundColor: AppColors.transparent,
                                    enableDrag: true,
                                    isDismissible: true,
                                  );
                                },
                              );
                            }
                          },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('Simpan Alamat'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
