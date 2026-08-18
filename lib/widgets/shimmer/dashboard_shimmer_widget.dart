import 'package:flutter/material.dart';

import '../../app/app_colors.dart';
import '../../util/common_ext.dart';
import 'app_shimmer_container.dart';

class DashboardShimmerWidget extends StatelessWidget {
  const DashboardShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktopUI;

    return Container(
      color: AppColors.background,
      child: Column(
        children: [
          // 1. Top Navigation Bar Shimmer
          _buildTopBarShimmer(isDesktop),

          // 2. Main Scrollable Dashboard Content Shimmer
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Title & Subtitle Shimmer
                  const AppShimmerContainer(width: 320, height: 28),
                  const SizedBox(height: 8.0),
                  const AppShimmerContainer(width: 480, height: 16),
                  const SizedBox(height: 24.0),

                  // Row 1: Account setup progress card + Security Card
                  if (isDesktop)
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: _CardSkeleton(height: 260)),
                        SizedBox(width: 24.0),
                        Expanded(flex: 1, child: _CardSkeleton(height: 260)),
                      ],
                    )
                  else
                    const Column(
                      children: [
                        _CardSkeleton(height: 240),
                        SizedBox(height: 20.0),
                        _CardSkeleton(height: 180),
                      ],
                    ),
                  const SizedBox(height: 24.0),

                  // Row 2: Facebook card + Instagram card
                  if (isDesktop)
                    const Row(
                      children: [
                        Expanded(child: _CardSkeleton(height: 185)),
                        SizedBox(width: 24.0),
                        Expanded(child: _CardSkeleton(height: 185)),
                      ],
                    )
                  else
                    const Column(
                      children: [
                        _CardSkeleton(height: 185),
                        SizedBox(height: 20.0),
                        _CardSkeleton(height: 185),
                      ],
                    ),
                  const SizedBox(height: 24.0),

                  // Row 3: Live Performance lock section
                  const _CardSkeleton(height: 130),
                  const SizedBox(height: 24.0),

                  // Row 4: Quick Action list grids
                  if (isDesktop)
                    Row(
                      children: List.generate(
                        6,
                        (index) => const Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: 12.0),
                            child: _CardSkeleton(height: 75),
                          ),
                        ),
                      ),
                    )
                  else
                    const Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: _CardSkeleton(height: 75)),
                            SizedBox(width: 12.0),
                            Expanded(child: _CardSkeleton(height: 75)),
                          ],
                        ),
                        SizedBox(height: 12.0),
                        Row(
                          children: [
                            Expanded(child: _CardSkeleton(height: 75)),
                            SizedBox(width: 12.0),
                            Expanded(child: _CardSkeleton(height: 75)),
                          ],
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBarShimmer(bool isDesktop) {
    return Container(
      height: 70.0,
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1.0)),
      ),
      child: Row(
        children: [
          // Screen Label Shimmer
          const AppShimmerContainer(width: 120, height: 20),
          const Spacer(),

          // Search Box Shimmer
          if (isDesktop) ...[
            const AppShimmerContainer(
              width: 240,
              height: 38,
              borderRadius: 8.0,
            ),
            const SizedBox(width: 16.0),
          ],

          // Notification / Help Action Icon Shimmers
          const AppShimmerContainer(width: 36, height: 36, borderRadius: 18.0),
          const SizedBox(width: 12.0),
          const AppShimmerContainer(width: 36, height: 36, borderRadius: 18.0),

          if (isDesktop) ...[
            const SizedBox(width: 16.0),
            const AppShimmerContainer(
              width: 32,
              height: 32,
              borderRadius: 16.0,
            ),
          ],
        ],
      ),
    );
  }
}

class _CardSkeleton extends StatelessWidget {
  final double height;

  const _CardSkeleton({required this.height});

  @override
  Widget build(BuildContext context) {
    // Render simplified skeletons for shorter boxes (like Quick Actions) to prevent overflow
    if (height <= 100) {
      return Container(
        height: height,
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: AppColors.border, width: 1.0),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppShimmerContainer(width: 22, height: 22, borderRadius: 11.0),
            SizedBox(height: 6.0),
            AppShimmerContainer(width: 55, height: 10),
          ],
        ),
      );
    }

    return Container(
      height: height,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: AppColors.border, width: 1.0),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          AppShimmerContainer(width: 140, height: 16),
          SizedBox(height: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppShimmerContainer(width: double.infinity, height: 10),
                SizedBox(height: 8.0),
                AppShimmerContainer(width: double.infinity, height: 10),
                SizedBox(height: 8.0),
                AppShimmerContainer(width: 160, height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
