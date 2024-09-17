import 'package:flutter/material.dart';

class DialogService {
  static bool _isDialogShowing = false;
  static bool _isSnackBarShowing = false;
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason>?
      _snackBarController;

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

  static void showErrorSnackBar(BuildContext context, String message) {
    if (_isSnackBarShowing) return;

    _isSnackBarShowing = true;

    _snackBarController = ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 70,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            message,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: Colors.redAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        duration: Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        padding: EdgeInsets.zero,
        margin: EdgeInsets.all(0),
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
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            message,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        duration: Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        padding: EdgeInsets.zero,
        margin: EdgeInsets.all(0),
      ),
    );

    _snackBarController?.closed.then((_) {
      _isSnackBarShowing = false;
    });
  }
}
