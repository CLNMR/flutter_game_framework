import 'package:flutter/material.dart';

/// A class containing all the gradients used in the app.
class AppGradients {
  /// A gradient from indigo to yellow.
  static LinearGradient indigoToYellow = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      const Color.fromARGB(255, 98, 107, 164).withOpacity(0.7),
      Colors.yellow[50]!.withOpacity(0.7),
    ],
  );
}
