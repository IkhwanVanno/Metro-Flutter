import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/controller/auth_controller.dart';
import 'package:metro/services/api_service.dart';
import 'package:metro/theme/app_theme.dart';
import 'package:metro/widgets/membership_card.dart';
import '../routes/app_routes.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController firstnameController;
  late TextEditingController surnameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool obscurePassword = true;
  bool isEditing = false;
  final authController = Get.find<AuthController>();

  // Membership data
  Map<String, dynamic>? membershipInfo;
  Map<String, dynamic>? membershipProgress;
  bool isLoadingMembership = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    if (authController.isLoggedIn) {
      _loadMembershipData();
    }
  }

  void _initializeControllers() {
    final user = authController.currentUser;
    firstnameController = TextEditingController(text: user?.firstName ?? '');
    surnameController = TextEditingController(text: user?.surname ?? '');
    emailController = TextEditingController(text: user?.email ?? '');
    passwordController = TextEditingController();
  }

  Future<void> _loadMembershipData() async {
    setState(() => isLoadingMembership = true);

    try {
      final infoResponse = await ApiService.getMembershipInfo();
      final progressResponse = await ApiService.getMembershipProgress();

      if (mounted) {
        setState(() {
          if (infoResponse['success'] == true) {
            membershipInfo = infoResponse['data'];
          }
          if (progressResponse['success'] == true) {
            membershipProgress = progressResponse['data'];
          }
          isLoadingMembership = false;
        });
      }
    } catch (e) {
      print('Error loading membership: $e');
      if (mounted) {
        setState(() => isLoadingMembership = false);
      }
    }
  }

  @override
  void dispose() {
    firstnameController.dispose();
    surnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _handleSaveProfile() async {
    final response = await authController.updateProfile(
      firstnameController.text.trim(),
      surnameController.text.trim(),
      emailController.text.trim(),
      password: passwordController.text.isNotEmpty
          ? passwordController.text
          : null,
    );

    if (mounted) {
      if (response['success'] == true) {
        Get.snackbar(
          'Berhasil',
          response['message'] ?? 'Profil berhasil diperbarui',
          backgroundColor: AppColors.green,
          colorText: AppColors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
        );
        setState(() {
          isEditing = false;
          passwordController.clear();
        });
      } else {
        Get.snackbar(
          'Gagal',
          response['message'] ?? 'Gagal memperbarui profil',
          backgroundColor: AppColors.red,
          colorText: AppColors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );
      }
    }
  }

  void _handleLogout() {
    Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin logout?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          TextButton(
            onPressed: () async {
              Get.back();
              await authController.logout();
              Get.snackbar(
                'Berhasil',
                'Logout berhasil',
                backgroundColor: AppColors.green,
                colorText: AppColors.white,
                snackPosition: SnackPosition.TOP,
                duration: const Duration(seconds: 2),
              );
            },
            child: const Text('Logout', style: TextStyle(color: AppColors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: AppColors.black)),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.black),
        actions: [
          Obx(() {
            if (authController.isLoggedIn) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: const Size(60, 40),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  onPressed: () {
                    setState(() {
                      isEditing = !isEditing;
                      if (!isEditing) {
                        _initializeControllers();
                        passwordController.clear();
                      }
                    });
                  },
                  child: Text(
                    isEditing ? 'Batal' : 'Edit',
                    style: const TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: Obx(() {
        if (!authController.isLoggedIn) {
          return _buildLoginPrompt();
        }
        return _buildProfileContent();
      }),
    );
  }

  Widget _buildLoginPrompt() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_outline,
                size: 80,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Login Required',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Please login to view and edit\nyour profile information',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: AppColors.grey, height: 1.5),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () => Get.toNamed(AppRoutes.login),
                child: const Text(
                  'Login Now',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account? ",
                  style: TextStyle(color: AppColors.grey),
                ),
                TextButton(
                  onPressed: () => Get.toNamed(AppRoutes.register),
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Profile Header
          Container(
            width: double.infinity,
            color: AppColors.white,
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.blue,
                  child: Icon(Icons.person, size: 50, color: AppColors.white),
                ),
                const SizedBox(height: 12),
                Text(
                  authController.currentUser?.fullName ?? 'User',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  authController.currentUser?.email ?? '',
                  style: TextStyle(fontSize: 14, color: AppColors.grey),
                ),
              ],
            ),
          ),

          // Membership Card
          if (isLoadingMembership)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Center(child: CircularProgressIndicator()),
            )
          else if (membershipInfo != null)
            Container(
              color: AppColors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: MembershipCard(
                  tierName: membershipInfo!['tier_name'] ?? 'Bronze',
                  tierImage: membershipInfo!['tier_image'] ?? '',
                  totalTransactions: membershipInfo!['total_transactions'] ?? 0,
                  formattedTotal: membershipInfo!['formatted_total'] ?? 'Rp 0',
                  nextTierLimit: membershipProgress?['next_tier_limit'],
                  remaining: membershipProgress?['remaining'],
                  progressPercentage: double.tryParse(
                    membershipProgress?['progress_percentage']?.replaceAll(
                          '%',
                          '',
                        ) ??
                        '0',
                  ),
                ),
              ),
            ),

          // Profile Form
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Informasi Profil',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: firstnameController,
                  enabled: isEditing,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.grey),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AppColors.blue,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: surnameController,
                  enabled: isEditing,
                  decoration: InputDecoration(
                    labelText: 'Surname',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.grey),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AppColors.blue,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  enabled: isEditing,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.grey),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AppColors.blue,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                if (isEditing) ...[
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'New Password (Optional)',
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppColors.blue,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Leave password empty to keep current password',
                    style: TextStyle(fontSize: 12, color: AppColors.grey),
                  ),
                ],
                const SizedBox(height: 24),
                if (isEditing)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: authController.isLoading
                            ? AppColors.grey
                            : AppColors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: authController.isLoading
                          ? null
                          : _handleSaveProfile,
                      child: authController.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.white,
                                ),
                              ),
                            )
                          : const Text(
                              'Save Changes',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.white,
                              ),
                            ),
                    ),
                  ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.red,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _handleLogout,
                    child: const Text(
                      'Logout',
                      style: TextStyle(fontSize: 16, color: AppColors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
