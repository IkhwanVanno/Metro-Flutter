// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:metro/models/member_model.dart';
import 'package:metro/services/auth_service.dart';

class AuthController extends GetxController {
  final _currentUser = Rx<Member?>(null);
  final _isLoggedIn = false.obs;
  final _isLoading = false.obs;

  Member? get currentUser => _currentUser.value;
  bool get isLoggedIn => _isLoggedIn.value;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    _checkLoginStatus();
    // Listen to auth state changes
    AuthService.addAuthStateListener(_onAuthStateChanged);
  }

  @override
  void onClose() {
    AuthService.removeAuthStateListener(_onAuthStateChanged);
    super.onClose();
  }

  void _onAuthStateChanged() {
    _currentUser.value = AuthService.currentUser;
    _isLoggedIn.value = AuthService.isLoggedIn;
  }

  Future<void> _checkLoginStatus() async {
    _isLoading.value = true;
    try {
      if (AuthService.isLoggedIn) {
        final response = await AuthService.fetchCurrentMember();
        if (response['success'] == true) {
          final user = Member.fromJson(response['data']);
          _currentUser.value = user;
          _isLoggedIn.value = true;
        } else {
          _isLoggedIn.value = false;
        }
      }
    } catch (e) {
      print('Check login error: $e');
      _isLoggedIn.value = false;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    _isLoading.value = true;
    try {
      final response = await AuthService.login(email, password);

      if (response['success'] == true) {
        final user = Member.fromJson(response['user']);
        _currentUser.value = user;
        _isLoggedIn.value = true;
      }

      return response;
    } catch (e) {
      print('Login error: $e');
      return {'success': false, 'message': 'Terjadi kesalahan saat login'};
    } finally {
      _isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>> loginWithGoogle() async {
    _isLoading.value = true;
    try {
      final response = await AuthService.loginWithGoogle();

      if (response['success'] == true) {
        final user = Member.fromJson(response['user']);
        _currentUser.value = user;
        _isLoggedIn.value = true;
      }

      return response;
    } catch (e) {
      print('Google login error: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan saat login dengan Google',
      };
    } finally {
      _isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>> register(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    _isLoading.value = true;
    try {
      final response = await AuthService.register(
        firstName,
        lastName,
        email,
        password,
      );
      return response;
    } catch (e) {
      print('Register error: $e');
      return {'success': false, 'message': 'Terjadi kesalahan saat registrasi'};
    } finally {
      _isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    _isLoading.value = true;
    try {
      final response = await AuthService.forgotPassword(email);
      return response;
    } catch (e) {
      print('Forgot password error: $e');
      return {'success': false, 'message': 'Terjadi kesalahan koneksi'};
    } finally {
      _isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>> updateProfile(
    String firstName,
    String lastName,
    String email, {
    String? password,
  }) async {
    _isLoading.value = true;
    try {
      final response = await AuthService.updateProfile(
        firstName,
        lastName,
        email,
        password: password,
      );

      if (response['success'] == true) {
        final user = Member.fromJson(response['data']);
        _currentUser.value = user;
      }

      return response;
    } catch (e) {
      print('Update profile error: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan saat memperbarui profil',
      };
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> logout() async {
    _isLoading.value = true;
    try {
      await AuthService.logout();
      _currentUser.value = null;
      _isLoggedIn.value = false;
    } catch (e) {
      print('Logout error: $e');
    } finally {
      _isLoading.value = false;
    }
  }
}
