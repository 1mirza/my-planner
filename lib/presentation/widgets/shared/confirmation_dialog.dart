import 'package:flutter/material.dart';

Future<bool?> showConfirmationDialog(
  BuildContext context, {
  required String title,
  required String content,
  String confirmText = 'تایید',
  String cancelText = 'لغو',
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: Text(cancelText),
            onPressed: () {
              Navigator.of(context).pop(false); // Return false on cancel
            },
          ),
          FilledButton(
            child: Text(confirmText),
            onPressed: () {
              Navigator.of(context).pop(true); // Return true on confirm
            },
          ),
        ],
      );
    },
  );
}
