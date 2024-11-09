import 'package:flutter/material.dart';
import '../models/app_error.dart';

class ErrorView extends StatelessWidget {
  final AppError error;
  final VoidCallback onRetry;

  const ErrorView({
    Key? key,
    required this.error,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getErrorIcon(error.type),
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            SizedBox(height: 16),
            Text(
              error.message,
              style: Theme.of(context).textTheme.headline6?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            if (error.details != null) ...[
              SizedBox(height: 8),
              Text(
                error.details!,
                style: Theme.of(context).textTheme.caption,
                textAlign: TextAlign.center,
              ),
            ],
            SizedBox(height: 24),
            ElevatedButton.icon(
              icon: Icon(Icons.refresh),
              label: Text('RIPROVA'),
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getErrorIcon(ErrorType type) {
    switch (type) {
      case ErrorType.network:
        return Icons.wifi_off;
      case ErrorType.storage:
        return Icons.storage;
      case ErrorType.content:
        return Icons.error_outline;
      default:
        return Icons.error;
    }
  }
}
