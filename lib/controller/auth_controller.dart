// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:metro/models/member_model.dart';
import 'package:metro/services/auth_service.dart';

class AuthController extends GetxController {
  final _currentUser = Rx<Member?>(null);
  final _isLoggedIn = false.obs;
  final _isLoading = false.obs;
  final _errorMessage = ''.obs;

  Member? get currentUser => _currentUser.value;
  bool get isLoggedIn => _isLoggedIn.value;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;

  @override
  void onInit() {
    super.onInit();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    _isLoading.value = true;
    try {
      if (AuthService.isLoggedIn) {
        final user = await AuthService.fetchCurrentMember();
        if (user != null) {
          _currentUser.value = user;
          _isLoggedIn.value = true;
          await _loadUserData();
        }
      }
    } catch (e) {
      print('Check login error: $e');
      _errorMessage.value = 'Gagal memeriksa status login';
    } finally {
      _isLoading.value = false;
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading.value = true;
    _errorMessage.value = '';
    try {
      if (email.isEmpty || password.isEmpty) {
        _errorMessage.value = 'Email dan password harus diisi';
        return false;
      }

      final success = await AuthService.login(email, password);
      if (success) {
        final user = await AuthService.fetchCurrentMember();
        _currentUser.value = user;
        _isLoggedIn.value = true;
        await _loadUserData();
        return true;
      } else {
        _errorMessage.value = 'Email, password salah atau Belum terverivikasi. Silahkan chek email';
        return false;
      }
    } catch (e) {
      print('Login error: $e');
      _errorMessage.value = 'Terjadi kesalahan saat login';
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<bool> loginWithGoogle() async {
    _isLoading.value = true;
    _errorMessage.value = '';
    try {
      final success = await AuthService.loginWithGoogle();
      if (success) {
        final user = await AuthService.fetchCurrentMember();
        _currentUser.value = user;
        _isLoggedIn.value = true;
        await _loadUserData();
        return true;
      } else {
        _errorMessage.value = 'Google login dibatalkan atau gagal';
        return false;
      }
    } catch (e) {
      print('Google login error: $e');
      _errorMessage.value = 'Terjadi kesalahan saat login dengan Google';
      return false;
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
    _errorMessage.value = '';
    try {
      if (firstName.isEmpty || email.isEmpty || password.isEmpty) {
        return {
          'success': false,
          'message': 'Nama depan, email, dan password harus diisi'
        };
      }

      if (password.length < 8) {
        return {
          'success': false,
          'message': 'Password minimal 8 karakter'
        };
      }

      final success = await AuthService.register(
        firstName,
        lastName,
        email,
        password,
      );

      if (success) {
        return {
          'success': true,
          'message': 'Registrasi berhasil. Silakan Check Email anda.'
        };
      } else {
        return {
          'success': false,
          'message': 'Registrasi gagal. Mungkin email sudah terdaftar.'
        };
      }
    } catch (e) {
      print('Register error: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan saat registrasi'
      };
    } finally {
      _isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    _isLoading.value = true;
    _errorMessage.value = '';
    try {
      if (email.isEmpty) {
        return {
          'success': false,
          'message': 'Email harus diisi'
        };
      }

      final result = await AuthService.forgotPassword(email);
      _errorMessage.value = result['message'] ?? '';
      return result;
    } catch (e) {
      print('Forgot password error: $e');
      _errorMessage.value = 'Terjadi kesalahan koneksi';
      return {
        'success': false,
        'message': 'Terjadi kesalahan koneksi'
      };
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
    _errorMessage.value = '';
    try {
      if (firstName.isEmpty || email.isEmpty) {
        return {
          'success': false,
          'message': 'Nama depan dan email harus diisi'
        };
      }

      if (password != null && password.isNotEmpty && password.length < 8) {
        return {
          'success': false,
          'message': 'Password baru minimal 8 karakter'
        };
      }

      final success = await AuthService.updateProfile(
        firstName,
        lastName,
        email,
        password: password,
      );

      if (success) {
        final user = await AuthService.fetchCurrentMember();
        _currentUser.value = user;
        return {
          'success': true,
          'message': 'Profil berhasil diperbarui'
        };
      } else {
        return {
          'success': false,
          'message': 'Gagal memperbarui profil'
        };
      }
    } catch (e) {
      print('Update profile error: $e');
      _errorMessage.value = 'Terjadi kesalahan saat memperbarui profil';
      return {
        'success': false,
        'message': 'Terjadi kesalahan saat memperbarui profil'
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
      _errorMessage.value = '';
      _clearUserData();
    } catch (e) {
      print('Logout error: $e');
      _errorMessage.value = 'Terjadi kesalahan saat logout';
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _loadUserData() async {
    // Implementasi loading data tambahan jika diperlukan
  }

  void _clearUserData() {
    // Implementasi clear data tambahan jika diperlukan
  }

  void clearError() {
    _errorMessage.value = '';
  }
}