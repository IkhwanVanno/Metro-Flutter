import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/models/review_model.dart';
import 'package:metro/services/api_service.dart';

class ReviewController extends GetxController {
  var isLoading = false.obs;
  var reviews = <Review>[].obs;

  // Submit review
  Future<bool> submitReview({
    required int orderId,
    required int orderItemId,
    required int rating,
    required String message,
    bool showName = true,
  }) async {
    try {
      isLoading(true);

      final response = await ApiService.submitReview(
        orderId: orderId,
        orderItemId: orderItemId,
        rating: rating,
        message: message,
        showName: showName,
      );

      if (response['success'] == true) {
        Get.snackbar(
          'Berhasil',
          response['message'] ?? 'Review berhasil dikirim',
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        return true;
      } else {
        Get.snackbar(
          'Gagal',
          response['message'] ?? 'Gagal mengirim review',
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        return false;
      }
    } catch (e) {
      print('Submit review error: $e');
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat mengirim review',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return false;
    } finally {
      isLoading(false);
    }
  }

  // Get product reviews
  Future<void> fetchProductReviews(int productId) async {
    try {
      isLoading(true);

      final response = await ApiService.getProductReviews(
        productId,
        page: 1,
        limit: 100,
      );

      if (response['success'] == true) {
        reviews.value = response['data'] as List<Review>;
      } else {
        reviews.clear();
      }
    } catch (e) {
      print('Fetch reviews error: $e');
      reviews.clear();
    } finally {
      isLoading(false);
    }
  }

  // Calculate average rating
  double getAverageRating() {
    if (reviews.isEmpty) return 0.0;

    int total = 0;
    for (var review in reviews) {
      total += review.rating;
    }

    return total / reviews.length;
  }

  // Get rating distribution
  Map<int, int> getRatingDistribution() {
    Map<int, int> distribution = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};

    for (var review in reviews) {
      if (review.rating >= 1 && review.rating <= 5) {
        distribution[review.rating] = (distribution[review.rating] ?? 0) + 1;
      }
    }

    return distribution;
  }
}
