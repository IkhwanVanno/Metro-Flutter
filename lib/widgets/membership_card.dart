import 'package:flutter/material.dart';
import 'package:metro/theme/app_theme.dart';

class MembershipCard extends StatelessWidget {
  final String tierName;
  final String tierImage;
  final int totalTransactions;
  final String formattedTotal;
  final int? nextTierLimit;
  final int? remaining;
  final double? progressPercentage;

  const MembershipCard({
    super.key,
    required this.tierName,
    required this.tierImage,
    required this.totalTransactions,
    required this.formattedTotal,
    this.nextTierLimit,
    this.remaining,
    this.progressPercentage,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                // Gambar tier (ikon membership)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    tierImage,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),

                // Nama dan status
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Status Membership',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tierName.toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Total Transaksi
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.grey.withAlpha(30),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Transaksi',
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    formattedTotal,
                    style: const TextStyle(
                      color: AppColors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Progress ke Level Selanjutnya
            if (nextTierLimit != null && remaining != null) ...[
              const SizedBox(height: 16),
              const Text(
                'Progress ke Level Selanjutnya',
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progressPercentage != null
                      ? progressPercentage! / 100
                      : 0,
                  backgroundColor: AppColors.grey,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.blue,
                  ),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sisa ${_formatCurrency(remaining!)} lagi untuk level berikutnya',
                style: const TextStyle(color: AppColors.black, fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatCurrency(int amount) {
    return 'Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }
}
