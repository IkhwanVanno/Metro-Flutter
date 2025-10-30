import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:metro/config/app_config.dart';
import 'package:metro/models/carousel_model.dart';
import 'package:metro/models/category_model.dart';
import 'package:metro/models/eventshop_model.dart';
import 'package:metro/models/flashsale_model.dart';
import 'package:metro/models/popupad_model.dart';
import 'package:metro/models/product_model.dart';
import 'package:metro/models/review_model.dart';
import 'package:metro/models/shipping_address_model.dart';
import 'package:metro/models/siteconfig_model.dart';
import 'package:metro/services/session_manager.dart';

class ApiService {
  // ==================== CATALOG ====================

  /// GET /api/siteconfig
  static Future<Map<String, dynamic>> getSiteConfig() async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/siteconfig');
      final response = await http.get(
        url,
        headers: SessionManager.getHeaders(),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'statusCode': response.statusCode,
          'success': true,
          'data': SiteConfig.fromJson(data['data']),
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': data['error'] ?? 'Gagal mengambil konfigurasi site',
        };
      }
    } catch (e) {
      print('Get site config error: $e');
      return {
        'statusCode': 500,
        'success': false,
        'message': 'Terjadi kesalahan koneksi',
      };
    }
  }

  /// GET /api/carousel
  static Future<Map<String, dynamic>> getCarousels() async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/carousel');
      final response = await http.get(
        url,
        headers: SessionManager.getHeaders(),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        List<Carousel> carousels = (data['data'] as List)
            .map((item) => Carousel.fromJson(item))
            .toList();

        return {
          'statusCode': response.statusCode,
          'success': true,
          'data': carousels,
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': data['error'] ?? 'Gagal mengambil carousel',
        };
      }
    } catch (e) {
      print('Get carousels error: $e');
      return {
        'statusCode': 500,
        'success': false,
        'message': 'Terjadi kesalahan koneksi',
      };
    }
  }

  /// GET /api/popupad
  static Future<Map<String, dynamic>> getPopupAds() async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/popupad');
      final response = await http.get(
        url,
        headers: SessionManager.getHeaders(),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        List<Popupad> popupAds = (data['data'] as List)
            .map((item) => Popupad.fromJson(item))
            .toList();

        return {
          'statusCode': response.statusCode,
          'success': true,
          'data': popupAds,
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': data['error'] ?? 'Gagal mengambil popup ads',
        };
      }
    } catch (e) {
      print('Get popup ads error: $e');
      return {
        'statusCode': 500,
        'success': false,
        'message': 'Terjadi kesalahan koneksi',
      };
    }
  }

  /// GET /api/eventshops
  static Future<Map<String, dynamic>> getEventShops() async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/eventshops');
      final response = await http.get(
        url,
        headers: SessionManager.getHeaders(),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        List<Eventshop> eventShops = (data['data'] as List)
            .map((item) => Eventshop.fromJson(item))
            .toList();

        return {
          'statusCode': response.statusCode,
          'success': true,
          'data': eventShops,
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': data['error'] ?? 'Gagal mengambil event shops',
        };
      }
    } catch (e) {
      print('Get event shops error: $e');
      return {
        'statusCode': 500,
        'success': false,
        'message': 'Terjadi kesalahan koneksi',
      };
    }
  }

  /// GET /api/eventshop/{id}
  static Future<Map<String, dynamic>> getEventShopDetail(int id) async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/eventshop/$id');
      final response = await http.get(
        url,
        headers: SessionManager.getHeaders(),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'statusCode': response.statusCode,
          'success': true,
          'data': Eventshop.fromJson(data['data']),
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': data['error'] ?? 'Gagal mengambil detail event shop',
        };
      }
    } catch (e) {
      print('Get event shop detail error: $e');
      return {
        'statusCode': 500,
        'success': false,
        'message': 'Terjadi kesalahan koneksi',
      };
    }
  }

  /// GET /api/flashsales
  static Future<Map<String, dynamic>> getFlashSales() async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/flashsales');
      final response = await http.get(
        url,
        headers: SessionManager.getHeaders(),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        List<Flashsale> flashSales = (data['data'] as List)
            .map((item) => Flashsale.fromJson(item))
            .toList();

        return {
          'statusCode': response.statusCode,
          'success': true,
          'data': flashSales,
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': data['error'] ?? 'Gagal mengambil flash sales',
        };
      }
    } catch (e) {
      print('Get flash sales error: $e');
      return {
        'statusCode': 500,
        'success': false,
        'message': 'Terjadi kesalahan koneksi',
      };
    }
  }

  /// GET /api/flashsale/{id}
  static Future<Map<String, dynamic>> getFlashSaleDetail(int id) async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/flashsale/$id');
      final response = await http.get(
        url,
        headers: SessionManager.getHeaders(),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'statusCode': response.statusCode,
          'success': true,
          'data': Flashsale.fromJson(data['data']),
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': data['error'] ?? 'Gagal mengambil detail flash sale',
        };
      }
    } catch (e) {
      print('Get flash sale detail error: $e');
      return {
        'statusCode': 500,
        'success': false,
        'message': 'Terjadi kesalahan koneksi',
      };
    }
  }

  /// GET /api/category
  static Future<Map<String, dynamic>> getCategories() async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/category');
      final response = await http.get(
        url,
        headers: SessionManager.getHeaders(),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        List<Category> categories = (data['data'] as List)
            .map((item) => Category.fromJson(item))
            .toList();

        return {
          'statusCode': response.statusCode,
          'success': true,
          'data': categories,
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': data['error'] ?? 'Gagal mengambil kategori',
        };
      }
    } catch (e) {
      print('Get categories error: $e');
      return {
        'statusCode': 500,
        'success': false,
        'message': 'Terjadi kesalahan koneksi',
      };
    }
  }

  /// GET /api/products
  static Future<Map<String, dynamic>> getProducts({
    String? search,
    int? category,
    double? minPrice,
    double? maxPrice,
    String? stock,
    String? sort,
    int? rating,
    int page = 1,
    int limit = 100,
  }) async {
    try {
      Map<String, String> queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (category != null) queryParams['category'] = category.toString();
      if (minPrice != null) queryParams['min_price'] = minPrice.toString();
      if (maxPrice != null) queryParams['max_price'] = maxPrice.toString();
      if (stock != null) queryParams['stock'] = stock;
      if (sort != null) queryParams['sort'] = sort;
      if (rating != null) queryParams['rating'] = rating.toString();

      final url = Uri.parse(
        '${AppConfig.baseUrl}/products',
      ).replace(queryParameters: queryParams);

      final response = await http.get(
        url,
        headers: SessionManager.getHeaders(),
      );

      if (response.body.isEmpty) {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': 'Response kosong dari server',
        };
      }

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        // Validasi data adalah List
        if (data['data'] is! List) {
          print('Error: data is not a List, it is ${data['data'].runtimeType}');
          return {
            'statusCode': response.statusCode,
            'success': false,
            'message': 'Format data tidak valid',
          };
        }

        List<Product> products = [];

        // Parse setiap item dengan error handling
        for (var item in data['data']) {
          try {
            if (item is Map<String, dynamic>) {
              products.add(Product.fromJson(item));
            } else {
              print(
                'Warning: Item bukan Map<String, dynamic>: ${item.runtimeType}',
              );
            }
          } catch (e) {
            print('Error parsing product item: $e');
            print('Item: $item');
          }
        }

        return {
          'statusCode': response.statusCode,
          'success': true,
          'data': products,
          'meta': data['meta'] ?? {},
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': data['error'] ?? 'Gagal mengambil produk',
        };
      }
    } catch (e, stackTrace) {
      print('Get products error: $e');
      print('Stack trace: $stackTrace');
      return {
        'statusCode': 500,
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }

  /// GET /api/product/{id}
  static Future<Map<String, dynamic>> getProductDetail(int id) async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/product/$id');
      final response = await http.get(
        url,
        headers: SessionManager.getHeaders(),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'statusCode': response.statusCode,
          'success': true,
          'data': Product.fromJson(data['data']),
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': data['error'] ?? 'Gagal mengambil detail produk',
        };
      }
    } catch (e) {
      print('Get product detail error: $e');
      return {
        'statusCode': 500,
        'success': false,
        'message': 'Terjadi kesalahan koneksi',
      };
    }
  }

  // ==================== CART ====================

  /// GET /api/cart
  static Future<Map<String, dynamic>> getCart() async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/cart');
      final response = await http.get(
        url,
        headers: SessionManager.getHeaders(),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'statusCode': response.statusCode,
          'success': true,
          'data': data['data'],
        };
      } else if (response.statusCode == 401) {
        return {
          'statusCode': 401,
          'success': false,
          'message': 'Sesi telah berakhir',
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': data['error'] ?? 'Gagal mengambil keranjang',
        };
      }
    } catch (e) {
      print('Get cart error: $e');
      return {
        'statusCode': 500,
        'success': false,
        'message': 'Terjadi kesalahan koneksi',
      };
    }
  }

  /// POST /api/cart/add
  static Future<Map<String, dynamic>> addToCart(
    int productId,
    int quantity,
  ) async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/cart/add');
      final response = await http.post(
        url,
        headers: SessionManager.getHeaders(),
        body: jsonEncode({'product_id': productId, 'quantity': quantity}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 && data['success'] == true) {
        return {
          'statusCode': response.statusCode,
          'success': true,
          'message': data['message'] ?? 'Produk berhasil ditambahkan',
          'data': data['data'],
        };
      } else if (response.statusCode == 401) {
        return {
          'statusCode': 401,
          'success': false,
          'message': 'Sesi telah berakhir',
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': data['error'] ?? 'Gagal menambahkan ke keranjang',
        };
      }
    } catch (e) {
      print('Add to cart error: $e');
      return {
        'statusCode': 500,
        'success': false,
        'message': 'Terjadi kesalahan koneksi',
      };
    }
  }

  /// PUT /api/cart/update/{id}
  static Future<Map<String, dynamic>> updateCartItem(
    int cartItemId,
    int quantity,
  ) async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/cart/update/$cartItemId');
      final response = await http.put(
        url,
        headers: SessionManager.getHeaders(),
        body: jsonEncode({'quantity': quantity}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'statusCode': response.statusCode,
          'success': true,
          'message': data['message'] ?? 'Keranjang berhasil diupdate',
          'data': data['data'],
        };
      } else if (response.statusCode == 401) {
        return {
          'statusCode': 401,
          'success': false,
          'message': 'Sesi telah berakhir',
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': data['error'] ?? 'Gagal mengupdate keranjang',
        };
      }
    } catch (e) {
      print('Update cart item error: $e');
      return {
        'statusCode': 500,
        'success': false,
        'message': 'Terjadi kesalahan koneksi',
      };
    }
  }

  /// DELETE /api/cart/remove/{id}
  static Future<Map<String, dynamic>> removeFromCart(int cartItemId) async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/cart/remove/$cartItemId');
      final response = await http.delete(
        url,
        headers: SessionManager.getHeaders(),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'statusCode': response.statusCode,
          'success': true,
          'message': data['message'] ?? 'Item berhasil dihapus',
        };
      } else if (response.statusCode == 401) {
        return {
          'statusCode': 401,
          'success': false,
          'message': 'Sesi telah berakhir',
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': data['error'] ?? 'Gagal menghapus item',
        };
      }
    } catch (e) {
      print('Remove from cart error: $e');
      return {
        'statusCode': 500,
        'success': false,
        'message': 'Terjadi kesalahan koneksi',
      };
    }
  }

  /// DELETE /api/cart/clear
  static Future<Map<String, dynamic>> clearCart() async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/cart/clear');
      final response = await http.delete(
        url,
        headers: SessionManager.getHeaders(),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'statusCode': response.statusCode,
          'success': true,
          'message': data['message'] ?? 'Keranjang berhasil dikosongkan',
        };
      } else if (response.statusCode == 401) {
        return {
          'statusCode': 401,
          'success': false,
          'message': 'Sesi telah berakhir',
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': data['error'] ?? 'Gagal mengosongkan keranjang',
        };
      }
    } catch (e) {
      print('Clear cart error: $e');
      return {
        'statusCode': 500,
        'success': false,
        'message': 'Terjadi kesalahan koneksi',
      };
    }
  }

  // ==================== FAVORITES ====================

  /// GET /api/favorites
  static Future<Map<String, dynamic>> getFavorites() async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/favorites');
      final response = await http.get(
        url,
        headers: SessionManager.getHeaders(),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'statusCode': response.statusCode,
          'success': true,
          'data': data['data'],
          'total': data['total'],
        };
      } else if (response.statusCode == 401) {
        return {
          'statusCode': 401,
          'success': false,
          'message': 'Sesi telah berakhir',
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': data['error'] ?? 'Gagal mengambil favorit',
        };
      }
    } catch (e) {
      print('Get favorites error: $e');
      return {
        'statusCode': 500,
        'success': false,
        'message': 'Terjadi kesalahan koneksi',
      };
    }
  }

  /// POST /api/favorites/add
  static Future<Map<String, dynamic>> addToFavorites(int productId) async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/favorites/add');
      final response = await http.post(
        url,
        headers: SessionManager.getHeaders(),
        body: jsonEncode({'product_id': productId}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 && data['success'] == true) {
        return {
          'statusCode': response.statusCode,
          'success': true,
          'message':
              data['message'] ?? 'Produk berhasil ditambahkan ke favorit',
          'data': data['data'],
        };
      } else if (response.statusCode == 401) {
        return {
          'statusCode': 401,
          'success': false,
          'message': 'Sesi telah berakhir',
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': data['error'] ?? 'Gagal menambahkan ke favorit',
        };
      }
    } catch (e) {
      print('Add to favorites error: $e');
      return {
        'statusCode': 500,
        'success': false,
        'message': 'Terjadi kesalahan koneksi',
      };
    }
  }

  /// DELETE /api/favorites/remove/{id}
  static Future<Map<String, dynamic>> removeFromFavorites(
    int favoriteId,
  ) async {
    try {
      final url = Uri.parse(
        '${AppConfig.baseUrl}/favorites/remove/$favoriteId',
      );
      final response = await http.delete(
        url,
        headers: SessionManager.getHeaders(),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'statusCode': response.statusCode,
          'success': true,
          'message': data['message'] ?? 'Produk berhasil dihapus dari favorit',
        };
      } else if (response.statusCode == 401) {
        return {
          'statusCode': 401,
          'success': false,
          'message': 'Sesi telah berakhir',
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': data['error'] ?? 'Gagal menghapus dari favorit',
        };
      }
    } catch (e) {
      print('Remove from favorites error: $e');
      return {
        'statusCode': 500,
        'success': false,
        'message': 'Terjadi kesalahan koneksi',
      };
    }
  }

  /// GET /api/favorites/check/{product_id}
  static Future<Map<String, dynamic>> checkFavorite(int productId) async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/favorites/check/$productId');
      final response = await http.get(
        url,
        headers: SessionManager.getHeaders(),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'statusCode': response.statusCode,
          'success': true,
          'is_favorited': data['is_favorited'],
          'favorite_id': data['favorite_id'],
        };
      } else if (response.statusCode == 401) {
        return {
          'statusCode': 401,
          'success': false,
          'message': 'Sesi telah berakhir',
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': data['error'] ?? 'Gagal mengecek favorit',
        };
      }
    } catch (e) {
      print('Check favorite error: $e');
      return {
        'statusCode': 500,
        'success': false,
        'message': 'Terjadi kesalahan koneksi',
      };
    }
  }

  // ==================== ADDRESS ====================

  /// GET /api/addresses
  static Future<Map<String, dynamic>> getAddresses() async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/addresses');
      final response = await http.get(
        url,
        headers: SessionManager.getHeaders(),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        List<ShippingAddress> addresses = (data['data'] as List)
            .map((item) => ShippingAddress.fromJson(item))
            .toList();

        return {
          'statusCode': response.statusCode,
          'success': true,
          'data': addresses,
        };
      } else if (response.statusCode == 401) {
        return {
          'statusCode': 401,
          'success': false,
          'message': 'Sesi telah berakhir',
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': data['error'] ?? 'Gagal mengambil alamat',
        };
      }
    } catch (e) {
      print('Get addresses error: $e');
      return {
        'statusCode': 500,
        'success': false,
        'message': 'Terjadi kesalahan koneksi',
      };
    }
  }

  /// POST /api/addresses/add
  static Future<Map<String, dynamic>> addAddress({
    required String receiverName,
    required String phoneNumber,
    required String address,
    required String provinceId,
    required String provinceName,
    required String cityId,
    required String cityName,
    required String districtId,
    required String districtName,
    required String postalCode,
    bool isDefault = false,
  }) async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/addresses/add');
      final response = await http.post(
        url,
        headers: SessionManager.getHeaders(),
        body: jsonEncode({
          'receiver_name': receiverName,
          'phone_number': phoneNumber,
          'address': address,
          'province_id': provinceId,
          'province_name': provinceName,
          'city_id': cityId,
          'city_name': cityName,
          'district_id': districtId,
          'district_name': districtName,
          'postal_code': postalCode,
          'is_default': isDefault,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 && data['success'] == true) {
        return {
          'statusCode': response.statusCode,
          'success': true,
          'message': data['message'] ?? 'Alamat berhasil ditambahkan',
          'data': data['data'],
        };
      } else if (response.statusCode == 401) {
        return {
          'statusCode': 401,
          'success': false,
          'message': 'Sesi telah berakhir',
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': data['error'] ?? 'Gagal menambahkan alamat',
        };
      }
    } catch (e) {
      print('Add address error: $e');
      return {
        'statusCode': 500,
        'success': false,
        'message': 'Terjadi kesalahan koneksi',
      };
    }
  }

  /// PUT /api/addresses/update/{id}
  static Future<Map<String, dynamic>> updateAddress(
    int addressId,
    Map<String, dynamic> addressData,
  ) async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/addresses/update/$addressId');
      final response = await http.put(
        url,
        headers: SessionManager.getHeaders(),
        body: jsonEncode(addressData),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'statusCode': response.statusCode,
          'success': true,
          'message': data['message'] ?? 'Alamat berhasil diupdate',
        };
      } else if (response.statusCode == 401) {
        return {
          'statusCode': 401,
          'success': false,
          'message': 'Sesi telah berakhir',
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': data['error'] ?? 'Gagal mengupdate alamat',
        };
      }
    } catch (e) {
      print('Update address error: $e');
      return {
        'statusCode': 500,
        'success': false,
        'message': 'Terjadi kesalahan koneksi',
      };
    }
  }

  /// DELETE /api/addresses/delete/{id}
  static Future<Map<String, dynamic>> deleteAddress(int addressId) async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/addresses/delete/$addressId');
      final response = await http.delete(
        url,
        headers: SessionManager.getHeaders(),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'statusCode': response.statusCode,
          'success': true,
          'message': data['message'] ?? 'Alamat berhasil dihapus',
        };
      } else if (response.statusCode == 401) {
        return {
          'statusCode': 401,
          'success': false,
          'message': 'Sesi telah berakhir',
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': data['error'] ?? 'Gagal menghapus alamat',
        };
      }
    } catch (e) {
      print('Delete address error: $e');
      return {
        'statusCode': 500,
        'success': false,
        'message': 'Terjadi kesalahan koneksi',
      };
    }
  }

  // ==================== SHIPPING ====================

  /// GET /api/shipping/provinces
  static Future<Map<String, dynamic>> getProvinces() async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/shipping/provinces');
      final response = await http.get(
        url,
        headers: SessionManager.getHeaders(),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'statusCode': response.statusCode,
          'success': true,
          'data': data['data'],
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': data['error'] ?? 'Gagal mengambil provinsi',
        };
      }
    } catch (e) {
      print('Get provinces error: $e');
      return {
        'statusCode': 500,
        'success': false,
        'message': 'Terjadi kesalahan koneksi',
      };
    }
  }

  /// GET /api/shipping/cities/{province_id}
  static Future<Map<String, dynamic>> getCities(String provinceId) async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/shipping/cities/$provinceId');
      final response = await http.get(
        url,
        headers: SessionManager.getHeaders(),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'statusCode': response.statusCode,
          'success': true,
          'data': data['data'],
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': data['error'] ?? 'Gagal mengambil kota',
        };
      }
    } catch (e) {
      print('Get cities error: $e');
      return {
        'statusCode': 500,
        'success': false,
        'message': 'Terjadi kesalahan koneksi',
      };
    }
  }

  /// GET /api/shipping/districts/{city_id}
  static Future<Map<String, dynamic>> getDistricts(String cityId) async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/shipping/districts/$cityId');
      final response = await http.get(
        url,
        headers: SessionManager.getHeaders(),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'statusCode': response.statusCode,
          'success': true,
          'data': data['data'],
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': data['error'] ?? 'Gagal mengambil kecamatan',
        };
      }
    } catch (e) {
      print('Get districts error: $e');
      return {
        'statusCode': 500,
        'success': false,
        'message': 'Terjadi kesalahan koneksi',
      };
    }
  }

  /// POST /api/shipping/check-ongkir
  static Future<Map<String, dynamic>> checkOngkir({
    required String destination,
    required int weight,
    required String courier,
  }) async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/shipping/check-ongkir');
      final response = await http.post(
        url,
        headers: SessionManager.getHeaders(),
        body: jsonEncode({
          'destination': destination,
          'weight': weight,
          'courier': courier,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'statusCode': response.statusCode,
          'success': true,
          'data': data['data'],
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': data['error'] ?? 'Gagal mengecek ongkir',
        };
      }
    } catch (e) {
      print('Check ongkir error: $e');
      return {
        'statusCode': 500,
        'success': false,
        'message': 'Terjadi kesalahan koneksi',
      };
    }
  }

  // ==================== ORDER ====================

  /// GET /api/orders
  static Future<Map<String, dynamic>> getOrders({
    String? status,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      Map<String, String> queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }

      final url = Uri.parse(
        '${AppConfig.baseUrl}/orders',
      ).replace(queryParameters: queryParams);

      final response = await http.get(
        url,
        headers: SessionManager.getHeaders(),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'statusCode': response.statusCode,
          'success': true,
          'data': data['data'],
          'meta': data['meta'],
        };
      } else if (response.statusCode == 401) {
        return {
          'statusCode': 401,
          'success': false,
          'message': 'Sesi telah berakhir',
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': data['error'] ?? 'Gagal mengambil pesanan',
        };
      }
    } catch (e) {
      print('Get orders error: $e');
      return {
        'statusCode': 500,
        'success': false,
        'message': 'Terjadi kesalahan koneksi',
      };
    }
  }

  /// GET /api/orders/{id}
  static Future<Map<String, dynamic>> getOrderDetail(int orderId) async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/orders/$orderId');
      final response = await http.get(
        url,
        headers: SessionManager.getHeaders(),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'statusCode': response.statusCode,
          'success': true,
          'data': data['data'],
        };
      } else if (response.statusCode == 401) {
        return {
          'statusCode': 401,
          'success': false,
          'message': 'Sesi telah berakhir',
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': data['error'] ?? 'Gagal mengambil detail pesanan',
        };
      }
    } catch (e) {
      print('Get order detail error: $e');
      return {
        'statusCode': 500,
        'success': false,
        'message': 'Terjadi kesalahan koneksi',
      };
    }
  }

  /// POST /api/orders/create
  static Future<Map<String, dynamic>> createOrder({
    required int addressId,
    required String paymentMethod,
    required double shippingCost,
    required String courierService,
  }) async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/orders/create');
      final response = await http.post(
        url,
        headers: SessionManager.getHeaders(),
        body: jsonEncode({
          'address_id': addressId,
          'payment_method': paymentMethod,
          'shipping_cost': shippingCost,
          'courier_service': courierService,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 && data['success'] == true) {
        return {
          'statusCode': response.statusCode,
          'success': true,
          'message': data['message'] ?? 'Pesanan berhasil dibuat',
          'data': data['data'],
        };
      } else if (response.statusCode == 401) {
        return {
          'statusCode': 401,
          'success': false,
          'message': 'Sesi telah berakhir',
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': data['error'] ?? 'Gagal membuat pesanan',
        };
      }
    } catch (e) {
      print('Create order error: $e');
      return {
        'statusCode': 500,
        'success': false,
        'message': 'Terjadi kesalahan koneksi',
      };
    }
  }

  /// POST /api/orders/cancel/{id}
  static Future<Map<String, dynamic>> cancelOrder(int orderId) async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/orders/cancel/$orderId');
      final response = await http.post(
        url,
        headers: SessionManager.getHeaders(),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'statusCode': response.statusCode,
          'success': true,
          'message': data['message'] ?? 'Pesanan berhasil dibatalkan',
        };
      } else if (response.statusCode == 401) {
        return {
          'statusCode': 401,
          'success': false,
          'message': 'Sesi telah berakhir',
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': data['error'] ?? 'Gagal membatalkan pesanan',
        };
      }
    } catch (e) {
      print('Cancel order error: $e');
      return {
        'statusCode': 500,
        'success': false,
        'message': 'Terjadi kesalahan koneksi',
      };
    }
  }

  /// POST /api/orders/complete/{id}
  static Future<Map<String, dynamic>> markOrderAsCompleted(int orderId) async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/orders/complete/$orderId');
      final response = await http.post(
        url,
        headers: SessionManager.getHeaders(),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'statusCode': response.statusCode,
          'success': true,
          'message': data['message'] ?? 'Pesanan berhasil diselesaikan',
        };
      } else if (response.statusCode == 401) {
        return {
          'statusCode': 401,
          'success': false,
          'message': 'Sesi telah berakhir',
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': data['error'] ?? 'Gagal menyelesaikan pesanan',
        };
      }
    } catch (e) {
      print('Mark order as completed error: $e');
      return {
        'statusCode': 500,
        'success': false,
        'message': 'Terjadi kesalahan koneksi',
      };
    }
  }

  // ==================== PAYMENT ====================

  /// GET /api/payment/methods
  static Future<Map<String, dynamic>> getPaymentMethods({
    double amount = 10000,
  }) async {
    try {
      final url = Uri.parse(
        '${AppConfig.baseUrl}/payment/methods',
      ).replace(queryParameters: {'amount': amount.toString()});

      final response = await http.get(
        url,
        headers: SessionManager.getHeaders(),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'statusCode': response.statusCode,
          'success': true,
          'data': data['data'],
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': data['error'] ?? 'Gagal mengambil metode pembayaran',
        };
      }
    } catch (e) {
      print('Get payment methods error: $e');
      return {
        'statusCode': 500,
        'success': false,
        'message': 'Terjadi kesalahan koneksi',
      };
    }
  }

  /// POST /api/payment/initiate/{order_id}
  static Future<Map<String, dynamic>> initiatePayment(int orderId) async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/payment/initiate/$orderId');
      final response = await http.post(
        url,
        headers: SessionManager.getHeaders(),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'statusCode': response.statusCode,
          'success': true,
          'message': data['message'] ?? 'Pembayaran berhasil diinisiasi',
          'data': data['data'],
        };
      } else if (response.statusCode == 401) {
        return {
          'statusCode': 401,
          'success': false,
          'message': 'Sesi telah berakhir',
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': data['error'] ?? 'Gagal menginisiasi pembayaran',
        };
      }
    } catch (e) {
      print('Initiate payment error: $e');
      return {
        'statusCode': 500,
        'success': false,
        'message': 'Terjadi kesalahan koneksi',
      };
    }
  }

  // ==================== REVIEW ====================

  /// POST /api/reviews/submit
  static Future<Map<String, dynamic>> submitReview({
    required int orderId,
    required int orderItemId,
    required int rating,
    required String message,
    bool showName = true,
  }) async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/reviews/submit');
      final response = await http.post(
        url,
        headers: SessionManager.getHeaders(),
        body: jsonEncode({
          'order_id': orderId,
          'order_item_id': orderItemId,
          'rating': rating,
          'message': message,
          'show_name': showName,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 && data['success'] == true) {
        return {
          'statusCode': response.statusCode,
          'success': true,
          'message': data['message'] ?? 'Review berhasil dikirim',
          'data': data['data'],
        };
      } else if (response.statusCode == 401) {
        return {
          'statusCode': 401,
          'success': false,
          'message': 'Sesi telah berakhir',
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': data['error'] ?? 'Gagal mengirim review',
        };
      }
    } catch (e) {
      print('Submit review error: $e');
      return {
        'statusCode': 500,
        'success': false,
        'message': 'Terjadi kesalahan koneksi',
      };
    }
  }

  /// GET /api/reviews/product/{product_id}
  static Future<Map<String, dynamic>> getProductReviews(
    int productId, {
    int page = 1,
    int limit = 10,
  }) async {
    try {
      Map<String, String> queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      final url = Uri.parse(
        '${AppConfig.baseUrl}/reviews/product/$productId',
      ).replace(queryParameters: queryParams);

      final response = await http.get(
        url,
        headers: SessionManager.getHeaders(),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        List<Review> reviews = (data['data'] as List)
            .map((item) => Review.fromJson(item))
            .toList();

        return {
          'statusCode': response.statusCode,
          'success': true,
          'data': reviews,
          'meta': data['meta'],
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': data['error'] ?? 'Gagal mengambil review',
        };
      }
    } catch (e) {
      print('Get product reviews error: $e');
      return {
        'statusCode': 500,
        'success': false,
        'message': 'Terjadi kesalahan koneksi',
      };
    }
  }

  // ==================== MEMBERSHIP ====================

  /// GET /api/membership/info
  static Future<Map<String, dynamic>> getMembershipInfo() async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/membership/info');
      final response = await http.get(
        url,
        headers: SessionManager.getHeaders(),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'statusCode': response.statusCode,
          'success': true,
          'data': data['data'],
        };
      } else if (response.statusCode == 401) {
        return {
          'statusCode': 401,
          'success': false,
          'message': 'Sesi telah berakhir',
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': data['error'] ?? 'Gagal mengambil info membership',
        };
      }
    } catch (e) {
      print('Get membership info error: $e');
      return {
        'statusCode': 500,
        'success': false,
        'message': 'Terjadi kesalahan koneksi',
      };
    }
  }

  /// GET /api/membership/progress
  static Future<Map<String, dynamic>> getMembershipProgress() async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/membership/progress');
      final response = await http.get(
        url,
        headers: SessionManager.getHeaders(),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'statusCode': response.statusCode,
          'success': true,
          'data': data['data'],
        };
      } else if (response.statusCode == 401) {
        return {
          'statusCode': 401,
          'success': false,
          'message': 'Sesi telah berakhir',
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': data['error'] ?? 'Gagal mengambil progress membership',
        };
      }
    } catch (e) {
      print('Get membership progress error: $e');
      return {
        'statusCode': 500,
        'success': false,
        'message': 'Terjadi kesalahan koneksi',
      };
    }
  }

  // ==================== INVOICE ====================

  /// GET /api/invoice/download/{order_id}
  static Future<Map<String, dynamic>> downloadInvoice(int orderId) async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/invoice/download/$orderId');
      final response = await http.get(
        url,
        headers: SessionManager.getHeaders(),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'statusCode': response.statusCode,
          'success': true,
          'data': data['data'],
        };
      } else if (response.statusCode == 401) {
        return {
          'statusCode': 401,
          'success': false,
          'message': 'Sesi telah berakhir',
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': data['error'] ?? 'Gagal mengunduh invoice',
        };
      }
    } catch (e) {
      print('Download invoice error: $e');
      return {
        'statusCode': 500,
        'success': false,
        'message': 'Terjadi kesalahan koneksi',
      };
    }
  }

  /// POST /api/invoice/send/{order_id}
  static Future<Map<String, dynamic>> sendInvoice(int orderId) async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/invoice/send/$orderId');
      final response = await http.post(
        url,
        headers: SessionManager.getHeaders(),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'statusCode': response.statusCode,
          'success': true,
          'message': data['message'] ?? 'Invoice berhasil dikirim ke email',
        };
      } else if (response.statusCode == 401) {
        return {
          'statusCode': 401,
          'success': false,
          'message': 'Sesi telah berakhir',
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': data['message'] ?? 'Gagal mengirim invoice',
        };
      }
    } catch (e) {
      print('Send invoice error: $e');
      return {
        'statusCode': 500,
        'success': false,
        'message': 'Terjadi kesalahan koneksi',
      };
    }
  }
}
