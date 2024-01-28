import 'package:flutter/material.dart';

import '../main.dart';

void showErrorDialog(String errorMessage, context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Error'),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}
