import 'package:get/get.dart';
import 'package:metro/models/product_model.dart';
import 'package:metro/services/api_service.dart';

class ProductController extends GetxController {
  var isLoading = false.obs;
  var products = <Product>[].obs;
  var filteredProducts = <Product>[].obs;
  var searchQuery = ''.obs;
  var sortOption = 'Terbaru'.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading(true);
      errorMessage('');

      final response = await ApiService.getProducts(
        limit: 100,
      );

      print('Fetch products response: $response');

      if (response['success'] == true) {
        final productList = response['data'] as List<Product>;
        products.assignAll(productList);
        filteredProducts.assignAll(productList);

        print('Products loaded: ${products.length} items'); 
      } else {
        errorMessage(response['message'] ?? 'Gagal mengambil produk');
        print('Fetch products failed: ${response['message']}');
      }
    } catch (e, stackTrace) {
      errorMessage('Terjadi kesalahan: ${e.toString()}');
      print("Fetch products error: $e");
      print("Stack trace: $stackTrace");
    } finally {
      isLoading(false);
    }
  }

  void searchProducts(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredProducts.assignAll(products);
    } else {
      filteredProducts.assignAll(
        products
            .where(
              (p) =>
                  p.name.toLowerCase().contains(query.toLowerCase()) ||
                  p.description.toLowerCase().contains(query.toLowerCase()) ||
                  (p.categoryName?.toLowerCase().contains(
                        query.toLowerCase(),
                      ) ??
                      false),
            )
            .toList(),
      );
    }

    // Apply current sort after search
    sortProducts(sortOption.value);
  }

  void sortProducts(String option) {
    sortOption.value = option;
    List<Product> sorted = List.from(filteredProducts);

    switch (option) {
      case 'Termurah':
        sorted.sort(
          (a, b) => a.priceAfterAllDiscount.compareTo(b.priceAfterAllDiscount),
        );
        break;
      case 'Termahal':
        sorted.sort(
          (a, b) => b.priceAfterAllDiscount.compareTo(a.priceAfterAllDiscount),
        );
        break;
      case 'Nama A-Z':
        sorted.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Nama Z-A':
        sorted.sort((a, b) => b.name.compareTo(a.name));
        break;
      case 'Rating Tertinggi':
        sorted.sort((a, b) {
          final ratingA = a.rating ?? 0;
          final ratingB = b.rating ?? 0;
          return ratingB.compareTo(ratingA);
        });
        break;
      case 'Terbaru':
      default:
        break;
    }

    filteredProducts.assignAll(sorted);
  }

  void clearSearch() {
    searchQuery.value = '';
    filteredProducts.assignAll(products);
    sortProducts(sortOption.value);
  }

  // Refresh products
  Future<void> refreshProducts() async {
    await fetchProducts();
  }
}
