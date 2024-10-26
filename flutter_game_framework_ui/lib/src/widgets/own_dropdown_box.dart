import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A combo box with a dropdown of a given list of string options.
class OwnDropdownBox extends StatefulWidget {
  /// Creates a [OwnDropdownBox]
  const OwnDropdownBox({
    super.key,
    required this.options,
    this.initialValue,
    this.onChanged,
  });

  /// The list of string options to display in the dropdown.
  final List<String> options;

  /// The initial value of the dropdown. If null, no option is selected.
  final String? initialValue;

  /// The callback that is called when the dropdown value changes.
  final Function(String?)? onChanged;

  @override
  OwnDropdownBoxState createState() => OwnDropdownBoxState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('initialValue', initialValue))
      ..add(IterableProperty<String>('options', options))
      ..add(
        ObjectFlagProperty<Function(String p1)?>.has('onChanged', onChanged),
      );
  }
}

/// The state of a [OwnDropdownBox].
class OwnDropdownBoxState extends State<OwnDropdownBox> {
  /// The current value of the dropdown. If null, no option is selected.
  String? _dropdownValue;

  @override
  void initState() {
    super.initState();
    _dropdownValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) => DropdownButton<String>(
        value: _dropdownValue,
        icon: const Icon(Icons.arrow_downward),
        iconSize: 24,
        elevation: 16,
        style: const TextStyle(color: Colors.deepPurple),
        underline: Container(
          height: 2,
          color: Colors.deepPurpleAccent,
        ),
        onChanged: (newValue) {
          setState(() {
            _dropdownValue = newValue;
            widget.onChanged?.call(newValue);
          });
        },
        items: widget.options
            .map<DropdownMenuItem<String>>(
              (value) => DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              ),
            )
            .toList(),
      );
}
