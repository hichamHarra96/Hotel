import 'package:flutter/material.dart';

import '../main.dart';

void showInfoDialog(String infoMessage,context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Info'),
        content: Text(infoMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              //Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}