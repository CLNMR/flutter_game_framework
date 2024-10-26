import 'dart:math';

import 'package:flutter/material.dart';

/// Helper class for UI.
class UIHelper {
  /// Converts the provided value to radians
  static double convertDegToRad(num degrees) => degrees * (pi / 180.0);

  /// Gets a color from a string.
  static Color getColorFromString(String str) =>
      Color(0xFF000000 + str.hashCode % 16777216);
}
