import 'package:flutter/material.dart';

class SnackBarHelper {
  static void showError(BuildContext context, String message) {
    _show(context, message, color: Colors.red);
  }

  static void showSuccess(BuildContext context, String message) {
    _show(context, message, color: Colors.green);
  }

  static void _show(BuildContext context, String message, {required Color color}) {
    final sb = SnackBar(
      content: Text(message),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context).showSnackBar(sb);
  }
}
