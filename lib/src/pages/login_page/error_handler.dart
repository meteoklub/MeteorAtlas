import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ErrorHandler {
  static void showErrorToast(BuildContext context, String e) {
    Fluttertoast.showToast(
        msg: "Login failed: $e",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Theme.of(context).primaryColor,
        gravity: ToastGravity.SNACKBAR,
        textColor: Colors.black,
        fontSize: 16.0);
  }

  static void showSuccesToast(BuildContext context, String e) {
    Fluttertoast.showToast(
        msg: "Login Successfull!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.black,
        backgroundColor: Theme.of(context).primaryColor,
        fontSize: 16.0);
  }
}
