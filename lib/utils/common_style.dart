import 'package:flutter/material.dart';

class CommonStyle {

  static BoxDecoration get boxDecoration => const BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xffdce35b), Color(0xff45b649)],
      stops: [0, 1],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    ),
  );

}
