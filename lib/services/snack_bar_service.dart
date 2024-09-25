import 'package:flutter/material.dart';

class SnackBarService {
  static bool _isSnackBarShowing = false;
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason>?
      _snackBarController;

  static void showErrorSnackBar(BuildContext context, String message) {
    if (_isSnackBarShowing) return;

    _isSnackBarShowing = true;

    _snackBarController = ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: Colors.redAccent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        padding: EdgeInsets.zero,
        margin: const EdgeInsets.all(0),
      ),
    );

    _snackBarController?.closed.then((_) {
      _isSnackBarShowing = false;
    });
  }

  static void showSuccessSnackBar(BuildContext context, String message) {
    if (_isSnackBarShowing) return;

    _isSnackBarShowing = true;

    _snackBarController = ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: Colors.green,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        padding: EdgeInsets.zero,
        margin: const EdgeInsets.all(0),
      ),
    );

    _snackBarController?.closed.then((_) {
      _isSnackBarShowing = false;
    });
  }
}
