import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/controller/auth_controller.dart';
import '../routes/app_routes.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final emailController = TextEditingController();
  final firstnameController = TextEditingController();
  final surnameController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscurePassword = true;
  final authController = Get.find<AuthController>();

  @override
  void dispose() {
    emailController.dispose();
    firstnameController.dispose();
    surnameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool _validateInputs() {
    if (emailController.text.isEmpty ||
        firstnameController.text.isEmpty ||
        passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Email, nama depan, dan password harus diisi',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (!GetUtils.isEmail(emailController.text.trim())) {
      Get.snackbar(
        'Error',
        'Format email tidak valid',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (passwordController.text.length < 8) {
      Get.snackbar(
        'Error',
        'Password minimal 8 karakter',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    return true;
  }

  void _handleRegister() async {
    if (!_validateInputs()) return;

    final result = await authController.register(
      firstnameController.text.trim(),
      surnameController.text.trim(),
      emailController.text.trim(),
      passwordController.text,
    );

    if (mounted) {
      if (result['success'] == true) {
        Get.snackbar(
          'Success',
          result['message'] ?? 'Registrasi berhasil',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        await Future.delayed(const Duration(seconds: 2));
        Get.offNamed(AppRoutes.login);
      } else {
        Get.snackbar(
          'Registrasi Gagal',
          result['message'] ?? 'Terjadi kesalahan saat registrasi',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/images/background.png',
                height: 180,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 16),

              const Text(
                'Register',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Email
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: UnderlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Full name fields (First + Last name)
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: firstnameController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                        prefixIcon: Icon(Icons.person_outline),
                        border: UnderlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: surnameController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        labelText: 'Surname',
                        prefixIcon: Icon(Icons.person_outline),
                        border: UnderlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Password
              TextField(
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                  ),
                  border: const UnderlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Terms and conditions
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                  children: [
                    const TextSpan(text: "By signing up, you agree to our "),
                    TextSpan(
                      text: "Terms & Conditions",
                      style: const TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()..onTap = () {},
                    ),
                    const TextSpan(text: " and "),
                    TextSpan(
                      text: "Privacy Policy",
                      style: const TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()..onTap = () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Register button
              Obx(
                () => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: authController.isLoading
                        ? Colors.grey
                        : Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: authController.isLoading ? null : _handleRegister,
                  child: authController.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text(
                          'Continue',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
              ),
              const SizedBox(height: 25),

              // Login redirect
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  TextButton(
                    onPressed: () => Get.offNamed(AppRoutes.login),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
