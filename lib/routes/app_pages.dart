import 'package:get/get.dart';
import 'package:metro/pages/forgetpassword.dart';
import 'package:metro/pages/home.dart';
import 'package:metro/pages/login.dart';
import 'package:metro/pages/main_page.dart';
import 'package:metro/pages/register.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = AppRoutes.home;

  static final routes = [
    GetPage(name: AppRoutes.home, page: () => const Home()),
    GetPage(name: AppRoutes.login, page: () => const Login()),
    GetPage(name: AppRoutes.register, page: () => const Register()),
    GetPage(name: AppRoutes.forgetpassword, page: () => const Forgetpassword()),
    GetPage(name: AppRoutes.mainPage, page: () => const MainPage()),
  ];
}
