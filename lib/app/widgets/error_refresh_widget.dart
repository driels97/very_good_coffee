import 'package:flutter/material.dart';

class ErrorRefreshWidget extends StatelessWidget {
  const ErrorRefreshWidget({
    this.onRefresh,
    this.errorMessage,
    super.key,
  });

  final VoidCallback? onRefresh;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (errorMessage != null)
          Text(
            errorMessage!,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        const SizedBox(height: 16),
        InkWell(
          onTap: onRefresh,
          child: const Column(
            children: [
              Icon(
                Icons.refresh,
                size: 48,
              ),
              SizedBox(height: 4),
              Text(
                'Try again',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
