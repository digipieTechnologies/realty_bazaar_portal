// File: lib/modules/auth/screens/social_connection_success_screen.dart
// Purpose: Clean, modern result screen displayed after Facebook/Instagram OAuth flow.

import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_text_styles.dart';
import '../../../widgets/brand/app_logo.dart';

class SocialConnectionSuccessScreen extends StatelessWidget {
  final String platform;
  final bool isConnected;
  final String? errorMessage;

  const SocialConnectionSuccessScreen({
    super.key,
    required this.platform,
    this.isConnected = true,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    final isFB = platform.toLowerCase() == 'facebook';
    final platformDisplay = isFB ? 'Facebook' : 'Instagram';
    final platformIcon = isFB
        ? 'assets/icons/facebook.png'
        : 'assets/icons/instagram.png';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 520),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24.0),
                border: Border.all(
                  color: AppColors.border.withValues(alpha: 0.6),
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.05),
                    blurRadius: 40.0,
                    spreadRadius: 0,
                    offset: const Offset(0, 16),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 12.0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ─── Top gradient accent bar ───
                  Container(
                    height: 4.0,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24.0),
                        topRight: Radius.circular(24.0),
                      ),
                      gradient: LinearGradient(
                        colors: isConnected
                            ? [AppColors.primary, AppColors.secondary]
                            : [AppColors.error, AppColors.warning],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 36.0, 20.0, 36.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ─── 1. App Logo & Brand Header ───
                        const AppLogo(size: 56.0),
                        const SizedBox(height: 12.0),
                        Text(
                          'The Realty Bazaar',
                          style: AppTextStyles.heading2.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),

                        const SizedBox(height: 32.0),

                        // ─── 2. Icon + Title Row (Single Centered Line) ───
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 40.0,
                                height: 40.0,
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: isFB
                                      ? const Color(0xFF1877F2)
                                          .withValues(alpha: 0.08)
                                      : const Color(0xFFE4405F)
                                          .withValues(alpha: 0.08),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isFB
                                        ? const Color(0xFF1877F2)
                                            .withValues(alpha: 0.18)
                                        : const Color(0xFFE4405F)
                                            .withValues(alpha: 0.18),
                                    width: 1.5,
                                  ),
                                ),
                                child: Image.asset(
                                  platformIcon,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                isConnected
                                    ? '$platformDisplay Connected Successfully'
                                    : '$platformDisplay Connection Failed',
                                maxLines: 1,
                                style: AppTextStyles.heading3.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                  fontSize: 18.0,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16.0),

                        // ─── 3. Description text ───
                        Text(
                          isConnected
                              ? 'Your $platformDisplay account has been linked to The Realty Bazaar successfully.'
                              : (errorMessage ??
                                  'We were unable to connect your $platformDisplay account. Please try again from the app.'),
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.65,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 24.0),

                        // ─── 4. Divider ───
                        Container(
                          height: 1.0,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.border.withValues(alpha: 0.0),
                                AppColors.border,
                                AppColors.border.withValues(alpha: 0.0),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20.0),

                        // ─── 5. Footer note ───
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.info_outline_rounded,
                              size: 15.0,
                              color: AppColors.textMuted,
                            ),
                            const SizedBox(width: 8.0),
                            Flexible(
                              child: Text(
                                'You can safely close this tab.',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textMuted,
                                  fontSize: 13.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
