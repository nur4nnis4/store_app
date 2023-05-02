import 'package:flutter/material.dart';

class CustomSnackbar {
  static SnackBar loadingSnackbar(BuildContext context, {String? text}) {
    double horizontalMargin = MediaQuery.of(context).size.width * 0.3;
    return SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.fromLTRB(horizontalMargin, 0, horizontalMargin,
            MediaQuery.of(context).size.height * 0.4),
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        content: Row(
          children: [
            SizedBox.square(
              dimension: 13,
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.background,
                strokeWidth: 3,
              ),
            ),
            SizedBox(width: 10),
            Text(
              text ?? ' Processing...',
              style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.background),
            ),
          ],
        ));
  }

  static SnackBar errorSnackBar(BuildContext context, {String? text}) =>
      SnackBar(
        content: Text(text ?? 'Unknown error.'),
        backgroundColor: Theme.of(context).errorColor,
      );

  static SnackBar snackbarAlert(BuildContext context,
      {Duration duration = const Duration(milliseconds: 300),
      required String content}) {
    double horizontalMargin = MediaQuery.of(context).size.width * 0.3;

    return SnackBar(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, color: Colors.grey[300]),
          SizedBox(height: 2),
          Text(
            content.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[300],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      duration: duration,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Color.fromRGBO(0, 0, 0, 0.7),
      margin: EdgeInsets.fromLTRB(horizontalMargin, 0, horizontalMargin,
          MediaQuery.of(context).size.height * 0.5),
    );
  }
}
