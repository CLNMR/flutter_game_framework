import 'dart:math';

/// String extension
extension StringExtension on String {
  /// Capitalizes the first letter of the string.
  String capitalize() => '${this[0].toUpperCase()}${substring(1)}';

  /// Returns a string of [length] random numbers.
  String randomNumbers(int length) =>
      Random().nextInt(pow(10, length).toInt()).toString().padLeft(length, '0');
}
