import 'package:flutter/material.dart';
import '../models/app_error.dart';

class ErrorService {
  static void showError(BuildContext context, AppError error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              error.message,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            if (error.details != null)
              Text(
                error.details!,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
          ],
        ),
        action: SnackBarAction(
          label: 'CHIUDI',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: _getErrorColor(error.type),
        duration: Duration(seconds: 4),
      ),
    );
  }

  static Color _getErrorColor(ErrorType type) {
    switch (type) {
      case ErrorType.network:
        return Colors.red[700]!;
      case ErrorType.storage:
        return Colors.orange[700]!;
      case ErrorType.content:
        return Colors.amber[700]!;
      default:
        return Colors.red[900]!;
    }
  }
}
