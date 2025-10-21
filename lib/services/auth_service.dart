// ignore_for_file: prefer_final_fields

import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:metro/config/app_config.dart';
import 'package:metro/models/member_model.dart';
import 'package:metro/services/session_manager.dart';

class AuthService {
  static Member? _currentUser;
  static List<Function()> _authStateListeners = [];
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  static Member? get currentUser => _currentUser;
  static bool get isLoggedIn =>
      SessionManager.isLoggedIn && _currentUser != null;

  static void addAuthStateListener(Function() listener) {
    if (!_authStateListeners.contains(listener)) {
      _authStateListeners.add(listener);
    }
  }

  static void removeAuthStateListener(Function() listener) {
    _authStateListeners.remove(listener);
  }

  static set onAuthStateChanged(Function()? callback) {
    if (callback != null) {
      addAuthStateListener(callback);
    }
  }

  static Future<void> init() async {
    await SessionManager.init();

    if (SessionManager.isLoggedIn) {
      final userData = SessionManager.currentUser;
      if (userData != null) {
        try {
          _currentUser = Member.fromJson(userData);
          await fetchCurrentMember();
          _notifyAllAuthStateListeners();
        } catch (e) {
          print('Session invalid, logging out: $e');
          await logout();
        }
      }
    }
  }

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/login');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        _currentUser = Member.fromJson(data['user']);
        final cookie = response.headers['set-cookie'];
        await SessionManager.saveSession(data['user'], cookie);
        _notifyAllAuthStateListeners();

        return {
          'statusCode': response.statusCode,
          'success': true,
          'message': data['message'] ?? 'Login berhasil',
          'user': data['user'],
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': data['error'] ?? data['message'] ?? 'Login gagal',
        };
      }
    } catch (e) {
      print('Login error: $e');
      return {
        'statusCode': 500,
        'success': false,
        'message': 'Terjadi kesalahan koneksi',
      };
    }
  }

  static Future<Map<String, dynamic>> loginWithGoogle() async {
    try {
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return {
          'statusCode': 401,
          'success': false,
          'message': 'Login Google dibatalkan',
        };
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final url = Uri.parse('${AppConfig.baseUrl}/google-auth');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'id_token': googleAuth.idToken,
          'access_token': googleAuth.accessToken,
          'email': googleUser.email,
          'display_name': googleUser.displayName,
          'photo_url': googleUser.photoUrl,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        _currentUser = Member.fromJson(data['user']);
        final cookie = response.headers['set-cookie'];
        await SessionManager.saveSession(data['user'], cookie);
        _notifyAllAuthStateListeners();

        return {
          'statusCode': response.statusCode,
          'success': true,
          'message': data['message'] ?? 'Login Google berhasil',
          'user': data['user'],
        };
      } else {
        await _googleSignIn.signOut();
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': data['error'] ?? data['message'] ?? 'Login Google gagal',
        };
      }
    } catch (e) {
      print('Google Sign-In error: $e');
      await _googleSignIn.signOut();
      return {
        'statusCode': 500,
        'success': false,
        'message': 'Terjadi kesalahan saat login dengan Google',
      };
    }
  }

  static Future<Map<String, dynamic>> register(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/register');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'first_name': firstName,
          'surname': lastName,
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      return {
        'statusCode': response.statusCode,
        'success': response.statusCode == 201 && data['success'] == true,
        'message': data['success'] == true
            ? (data['message'] ?? 'Registrasi berhasil')
            : (data['error'] ?? data['message'] ?? 'Registrasi gagal'),
        if (data['data'] != null) 'data': data['data'],
      };
    } catch (e) {
      print('Register error: $e');
      return {
        'statusCode': 500,
        'success': false,
        'message': 'Terjadi kesalahan koneksi',
      };
    }
  }

  static Future<Map<String, dynamic>> fetchCurrentMember() async {
    if (!SessionManager.isLoggedIn) {
      return {'statusCode': 401, 'success': false, 'message': 'Belum login'};
    }

    try {
      final url = Uri.parse('${AppConfig.baseUrl}/member');
      final response = await http.get(
        url,
        headers: SessionManager.getHeaders(),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        _currentUser = Member.fromJson(data['data']);
        await SessionManager.updateUserData(data['data']);
        _notifyAllAuthStateListeners();

        return {
          'statusCode': response.statusCode,
          'success': true,
          'data': data['data'],
        };
      } else if (response.statusCode == 401) {
        await logout();
        return {
          'statusCode': 401,
          'success': false,
          'message': data['error'] ?? 'Sesi telah berakhir',
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': data['error'] ?? 'Gagal mengambil data user',
        };
      }
    } catch (e) {
      print('Fetch current member error: $e');
      return {
        'statusCode': 500,
        'success': false,
        'message': 'Terjadi kesalahan koneksi',
      };
    }
  }

  static Future<Map<String, dynamic>> updateProfile(
    String firstName,
    String lastName,
    String email, {
    String? password,
  }) async {
    if (_currentUser == null) {
      return {
        'statusCode': 401,
        'success': false,
        'message': 'User belum login',
      };
    }

    try {
      // Update password jika diberikan
      if (password != null && password.isNotEmpty) {
        final passwordUrl = Uri.parse('${AppConfig.baseUrl}/member/password');
        final passwordResponse = await http.put(
          passwordUrl,
          headers: SessionManager.getHeaders(),
          body: jsonEncode({'new_password': password}),
        );

        final passwordData = jsonDecode(passwordResponse.body);

        if (passwordResponse.statusCode != 200) {
          return {
            'statusCode': passwordResponse.statusCode,
            'success': false,
            'message': passwordData['error'] ?? 'Gagal mengubah password',
          };
        }
      }

      // Update profile data
      final url = Uri.parse('${AppConfig.baseUrl}/member');
      final response = await http.put(
        url,
        headers: SessionManager.getHeaders(),
        body: jsonEncode({
          'first_name': firstName,
          'surname': lastName,
          'email': email,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        _currentUser = Member.fromJson(data['data']);
        await SessionManager.updateUserData(data['data']);
        _notifyAllAuthStateListeners();

        return {
          'statusCode': response.statusCode,
          'success': true,
          'message': data['message'] ?? 'Profil berhasil diperbarui',
          'data': data['data'],
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message':
              data['error'] ?? data['message'] ?? 'Gagal memperbarui profil',
        };
      }
    } catch (e) {
      print('Update profile error: $e');
      return {
        'statusCode': 500,
        'success': false,
        'message': 'Terjadi kesalahan koneksi',
      };
    }
  }

  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/forgotpassword');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email}),
      );

      final data = jsonDecode(response.body);

      return {
        'statusCode': response.statusCode,
        'success': response.statusCode == 200 && data['success'] == true,
        'message': data['success'] == true
            ? (data['message'] ?? 'Link reset password telah dikirim')
            : (data['error'] ?? data['message'] ?? 'Gagal mengirim link reset'),
      };
    } catch (e) {
      print('Forgot password error: $e');
      return {
        'statusCode': 500,
        'success': false,
        'message': 'Terjadi kesalahan koneksi',
      };
    }
  }

  static Future<Map<String, dynamic>> logout() async {
    try {
      if (SessionManager.isLoggedIn) {
        final url = Uri.parse('${AppConfig.baseUrl}/logout');
        await http.post(url, headers: SessionManager.getHeaders());
      }

      await _googleSignIn.signOut();
    } catch (e) {
      print('Logout error: $e');
    } finally {
      _currentUser = null;
      await SessionManager.clearSession();
      _notifyAllAuthStateListeners();
    }
    return {'statusCode': 200, 'success': true, 'message': 'Logout berhasil'};
  }

  static void _notifyAllAuthStateListeners() {
    final listeners = List<Function()>.from(_authStateListeners);
    for (final listener in listeners) {
      try {
        listener();
      } catch (e) {
        print('Error calling auth state listener: $e');
        _authStateListeners.remove(listener);
      }
    }
  }

  static void clearAuthStateListeners() {
    _authStateListeners.clear();
  }
}
