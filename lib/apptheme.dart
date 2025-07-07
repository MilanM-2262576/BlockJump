import 'package:flutter/material.dart';

class AppTheme {
  static const BoxDecoration mainBoxDecoration = BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xFF232526), Color(0xFF2C5364)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.all(Radius.circular(32)),
    boxShadow: [
      BoxShadow(
        color: Colors.black54,
        blurRadius: 24,
        offset: Offset(0, 8),
      ),
    ],
    border: Border.fromBorderSide(BorderSide(color: Colors.cyanAccent, width: 2)),
  );

  static const TextStyle titleStyle = TextStyle(
    color: Colors.cyanAccent,
    fontWeight: FontWeight.bold,
    fontSize: 32,
    letterSpacing: 2,
    shadows: [
      Shadow(
        blurRadius: 8,
        color: Colors.black54,
        offset: Offset(2, 4),
      )
    ],
  );
}