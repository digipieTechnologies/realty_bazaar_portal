// File: lib/app/app_utils.dart
// Purpose: Centralized helper utility methods.

import 'dart:async';
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import '../util/common_ext.dart';

import 'package:intl/intl.dart';
import '../util/app_date_utils.dart';

class AppUtils {
  AppUtils._();

  // --- VALIDATORS ---

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    // General global phone matcher: allows leading +, minimum 7 digits
    final phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');
    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[\s\-()]'), ''))) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    final nameVal = value.trim();
    if (nameVal.length < 2) {
      return 'Name must be at least 2 characters long';
    }
    final nameRegex = RegExp(r"^[a-zA-Z0-9\s\.\-\']+$");
    if (!nameRegex.hasMatch(nameVal)) {
      return 'Name can only contain letters, numbers, and standard characters';
    }
    return null;
  }

  static String? validateRequired(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null
          ? '$fieldName is required'
          : 'This field is required';
    }
    return null;
  }

  // --- FORMATTERS ---

  static String formatCurrency(double amount, {String symbol = '\$'}) {
    return '$symbol${amount.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  static String formatDate(DateTime date, {String? format}) {
    if (format == null) {
      return AppDateUtils.formatDate(date);
    }
    return DateFormat(format).format(date);
  }

  // --- SCREEN SIZE HELPERS ---

  static double getScreenWidth(BuildContext context) => context.width;
  static double getScreenHeight(BuildContext context) => context.height;

  static bool isMobile(BuildContext context) => context.isMobileUI;
  static bool isTablet(BuildContext context) => context.isTabletUI;
  static bool isDesktop(BuildContext context) => context.isDesktopUI;

  // --- DEBOUNCER ---

  static void Function(void Function() action) debounce({
    int milliseconds = 300,
  }) {
    Timer? timer;
    return (void Function() action) {
      if (timer != null) {
        timer!.cancel();
      }
      timer = Timer(Duration(milliseconds: milliseconds), action);
    };
  }

  // --- UI INTERACTION OVERLAYS ---

  static void dismissKeyboard(BuildContext context) {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  static void showSnackBar(
    BuildContext context, {
    required String message,
    bool isError = false,
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    final snackBar = SnackBar(
      backgroundColor: isError ? AppColors.error : AppColors.success,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      content: Text(
        message,
        style: AppTextStyles.body2.copyWith(
          color: AppColors.surface,
          fontWeight: FontWeight.w500,
        ),
      ),
      action: actionLabel != null && onActionPressed != null
          ? SnackBarAction(
              label: actionLabel,
              textColor: AppColors.surface,
              onPressed: onActionPressed,
            )
          : null,
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
