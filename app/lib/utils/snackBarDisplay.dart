import 'package:flutter/material.dart';

class SnackBarDisplay {
  final BuildContext context;
  SnackBarDisplay({required this.context});
  void showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,
            style:
                Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 15)),
        backgroundColor: Colors.green,
      ),
    );
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,
            style:
                Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 15)),
        backgroundColor: Colors.red,
      ),
    );
  }
}
