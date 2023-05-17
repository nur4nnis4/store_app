import 'package:flutter/material.dart';

class MyBorder {
  static OutlineInputBorder outlineInputBorder(BuildContext context) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF616161)),
    );
  }

  static UnderlineInputBorder underlineInputBorder(BuildContext context) {
    return UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF616161)),
    );
  }
}
