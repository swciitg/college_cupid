import 'package:college_cupid/main.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void showSnackBar(String message) {
  rootScaffoldMessengerKey.currentState?.clearSnackBars();
  rootScaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
    content: Text(
      message,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    ),
    backgroundColor: CupidColors.primary,
    duration: const Duration(seconds: 2),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    margin: const EdgeInsets.all(16),
  ));
}

void showErrorSnackBar(DioException err) {
  rootScaffoldMessengerKey.currentState?.clearSnackBars();
  rootScaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
    content: Row(
      children: [
        const Icon(
          Icons.error_outline,
          color: Colors.white,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            (err.response != null)
                ? err.response!.data['message']
                : 'Some error occurred, please try again.',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
    backgroundColor: CupidColors.red,
    duration: const Duration(seconds: 4),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    margin: const EdgeInsets.all(16),
  ));
}
