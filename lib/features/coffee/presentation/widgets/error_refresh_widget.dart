import 'package:flutter/material.dart';

class ErrorRefreshWidget extends StatelessWidget {
  const ErrorRefreshWidget({this.onRefresh, super.key});

  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onRefresh,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.refresh,
            size: 48,
          ),
          SizedBox(height: 4),
          Text(
            'Try again',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
