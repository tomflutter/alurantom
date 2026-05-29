// widgets/shimmer_list.dart
// Skeleton loading UI shown while Surahs are being fetched

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../utils/app_theme.dart';

/// Displays a shimmer skeleton list while the API is loading
class ShimmerList extends StatelessWidget {
  final int itemCount;

  const ShimmerList({super.key, this.itemCount = 12});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppTheme.backgroundCard,
      highlightColor: AppTheme.backgroundElevated,
      child: ListView.builder(
        itemCount: itemCount,
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemBuilder: (_, __) => const _ShimmerTile(),
      ),
    );
  }
}

class _ShimmerTile extends StatelessWidget {
  const _ShimmerTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.backgroundCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Number circle
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.backgroundElevated,
            ),
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 14,
                  width: 120,
                  color: AppTheme.backgroundElevated,
                ),
                const SizedBox(height: 6),
                Container(
                  height: 11,
                  width: 80,
                  color: AppTheme.backgroundElevated,
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(height: 16, width: 40, color: AppTheme.backgroundElevated),
              const SizedBox(height: 6),
              Container(height: 11, width: 50, color: AppTheme.backgroundElevated),
            ],
          ),
        ],
      ),
    );
  }
}