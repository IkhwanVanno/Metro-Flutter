import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/controller/review_controller.dart';
import 'package:metro/theme/app_theme.dart';

class ReviewDialog extends StatefulWidget {
  final int orderId;
  final int orderItemId;
  final String productName;
  final String? productImage;

  const ReviewDialog({
    super.key,
    required this.orderId,
    required this.orderItemId,
    required this.productName,
    this.productImage,
  });

  @override
  State<ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {
  final reviewController = Get.put(ReviewController());
  final messageController = TextEditingController();
  int rating = 5;
  bool showName = true;

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  void _submitReview() async {
    if (messageController.text.trim().length < 5) {
      Get.snackbar(
        'Peringatan',
        'Review minimal 5 karakter',
        backgroundColor: AppColors.orange,
        colorText: AppColors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    final success = await reviewController.submitReview(
      orderId: widget.orderId,
      orderItemId: widget.orderItemId,
      rating: rating,
      message: messageController.text.trim(),
      showName: showName,
    );

    if (success) {
      Get.back(result: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Beri Review',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Get.back(),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Product Info
              Row(
                children: [
                  if (widget.productImage != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        widget.productImage!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stack) => Container(
                          width: 60,
                          height: 60,
                          color: AppColors.grey,
                          child: Icon(Icons.broken_image, size: 30),
                        ),
                      ),
                    ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.productName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),

              // Rating
              Center(
                child: Column(
                  children: [
                    Text(
                      'Berikan Rating',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < rating ? Icons.star : Icons.star_border,
                            size: 40,
                            color: AppColors.yellow,
                          ),
                          onPressed: () {
                            setState(() {
                              rating = index + 1;
                            });
                          },
                        );
                      }),
                    ),
                    Text(
                      _getRatingText(rating),
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // Review Message
              Text(
                'Tulis Review',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              TextField(
                controller: messageController,
                maxLines: 5,
                maxLength: 500,
                decoration: InputDecoration(
                  hintText: 'Bagikan pengalaman Anda tentang produk ini...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.blue, width: 2),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Show Name Checkbox
              Row(
                children: [
                  Checkbox(
                    value: showName,
                    onChanged: (value) {
                      setState(() {
                        showName = value ?? true;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      'Tampilkan nama saya di review',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: Obx(() {
                  return ElevatedButton(
                    onPressed: reviewController.isLoading.value
                        ? null
                        : _submitReview,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: reviewController.isLoading.value
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.white,
                              ),
                            ),
                          )
                        : Text(
                            'Kirim Review',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 1:
        return 'Sangat Buruk';
      case 2:
        return 'Buruk';
      case 3:
        return 'Cukup';
      case 4:
        return 'Baik';
      case 5:
        return 'Sangat Baik';
      default:
        return '';
    }
  }
}
