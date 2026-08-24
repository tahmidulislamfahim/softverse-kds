import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

class AppHelperFunctions {
  AppHelperFunctions._();

  static void showSnackBar(String message, {ToastificationType? type}) {
    final context = Get.context;
    if (context == null) return;
    final resolvedType = type ?? ToastificationType.error;
    toastification.show(
      context: context,
      type: resolvedType,
      style: ToastificationStyle.minimal,
      alignment: Alignment.topLeft,
      title: Text(_getTitleForType(resolvedType)),
      description: Text(message),
      autoCloseDuration: const Duration(seconds: 3),
      sizeConstraints: const BoxConstraints(maxWidth: 260),
    );
  }

  static void showSuccessSnackBar(String message) =>
      showSnackBar(message, type: ToastificationType.success);

  static void showErrorSnackBar(String message) =>
      showSnackBar(message, type: ToastificationType.error);

  static void showWarningSnackBar(String message) =>
      showSnackBar(message, type: ToastificationType.warning);

  static String _getTitleForType(ToastificationType type) {
    if (type == ToastificationType.success) return 'Success';
    if (type == ToastificationType.error) return 'Error';
    if (type == ToastificationType.warning) return 'Warning';
    return 'Notice';
  }

  static String getFormattedDate(
    DateTime date, {
    String format = 'dd MMM yyyy',
  }) {
    return DateFormat(format).format(date);
  }
}
