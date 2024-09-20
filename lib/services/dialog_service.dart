import 'package:flutter/material.dart';

class DialogService {
  static bool _isDialogShowing = false;

  static void showErrorDialog(BuildContext context, String message) {
    if (_isDialogShowing) return;

    _isDialogShowing = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              _isDialogShowing = false;
              Navigator.of(context).pop();
            },
            child: const Text('OK', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    ).then((_) {
      _isDialogShowing = false;
    });
  }

  static void showInfoDialog(BuildContext context, String message) {
    if (_isDialogShowing) return;

    _isDialogShowing = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Información'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              _isDialogShowing = false;
              Navigator.of(context).pop();
            },
            child: const Text('OK', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    ).then((_) {
      _isDialogShowing = false;
    });
  }
}
