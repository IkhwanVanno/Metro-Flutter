import 'package:get/get.dart';
import 'package:metro/pages/cart.dart';
import 'package:metro/pages/favorite.dart';
import 'package:metro/pages/forgetpassword.dart';
import 'package:metro/pages/login.dart';
import 'package:metro/pages/main_page.dart';
import 'package:metro/pages/order.dart';
import 'package:metro/pages/product_detail_page.dart';
import 'package:metro/pages/profile.dart';
import 'package:metro/pages/register.dart';
import 'package:metro/pages/search_result_page.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = AppRoutes.mainPage;

  static final routes = [
    GetPage(name: AppRoutes.mainPage, page: () => const MainPage()),
    GetPage(name: AppRoutes.login, page: () => const Login()),
    GetPage(name: AppRoutes.register, page: () => const Register()),
    GetPage(name: AppRoutes.forgetpassword, page: () => const Forgetpassword()),
    GetPage(name: AppRoutes.profile, page: () => const ProfilePage()),
    GetPage(name: AppRoutes.orderpage, page: () => const OrderPage()),
    GetPage(name: AppRoutes.cartpage, page: () => const CartPage()),
    GetPage(name: AppRoutes.favoritepage, page: () => const FavoritePage()),
    GetPage(name: AppRoutes.searchresultpage, page: () => SearchResultPage()),
    GetPage(
      name: AppRoutes.productdetailpage,
      page: () => ProductDetailPage(product: Get.arguments),
    ),
  ];
}
