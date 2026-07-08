import 'package:flutter/material.dart';

class AppStyle{
  static final ButtonStyle button = ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  static final TextStyle taillText = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 24,
    color: Colors.white
  );

  static final TextStyle textButton = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 23,
    color: Colors.white
  );

  static final TextStyle textOrdinairelien = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 14,
    color: Colors.white,
    decoration: TextDecoration.underline,
    decorationColor: Colors.white,
  );

  static final TextStyle textSnackBar = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 14,
    color: Colors.white,
  );
}