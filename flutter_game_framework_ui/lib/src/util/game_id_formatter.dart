import 'package:flutter/services.dart';

/// An input formatter to format incoming text to a GameId of the format
/// XXX-XXX-XXX.
class GameIdInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Replace all non-digit characters with an empty string:
    final text = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();
    for (var i = 0; i < text.length && i < 9; i++) {
      // Insert dash after every third character:
      if (i > 0 && i % 3 == 0) {
        buffer.write('-');
      }
      buffer.write(text[i]);
    }
    // Put the cursor at the end of the formatted text.
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
