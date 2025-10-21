import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/controller/auth_controller.dart';

class Forgetpassword extends StatefulWidget {
  const Forgetpassword({super.key});

  @override
  State<Forgetpassword> createState() => _ForgetpasswordState();
}

class _ForgetpasswordState extends State<Forgetpassword> {
  final forgotpasswordController = TextEditingController();
  final authController = Get.find<AuthController>();

  @override
  void dispose() {
    forgotpasswordController.dispose();
    super.dispose();
  }

  void _handleForgotPassword() async {
    final email = forgotpasswordController.text.trim();

    if (email.isEmpty) {
      Get.snackbar(
        'Perhatian',
        'Email wajib diisi',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    final response = await authController.forgotPassword(email);

    if (mounted) {
      if (response['success'] == true) {
        Get.snackbar(
          'Berhasil',
          response['message'] ??
              'Link reset password telah dikirim ke email Anda',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );
        await Future.delayed(const Duration(seconds: 2));
        Get.back();
      } else {
        Get.snackbar(
          'Gagal',
          response['message'] ?? 'Terjadi kesalahan. Silakan coba lagi.',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: Image.asset(
                'assets/images/background.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.all(24.0),
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      'Forgot',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const Text(
                      'Password',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Subtitle
                    const Text(
                      'Enter your email address,\nwe will send you verification code',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Input field
                    Row(
                      children: [
                        const Icon(Icons.email_outlined, color: Colors.grey),
                        const SizedBox(width: 10),
                        Flexible(
                          child: TextField(
                            controller: forgotpasswordController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Email Address',
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // Submit button
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: authController.isLoading
                                ? Colors.grey
                                : Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: authController.isLoading
                              ? null
                              : _handleForgotPassword,
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
                                  'Submit',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Back to login link
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text(
                          'Back to Login',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
