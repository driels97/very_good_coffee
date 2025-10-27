import 'package:flutter/material.dart';

abstract class WarningSnackbar {
  static void show(BuildContext context, {required String text}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 5,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
        content: Center(
          child: Text(
            text,
          ),
        ),
      ),
    );
  }
}
