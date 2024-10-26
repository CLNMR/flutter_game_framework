import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A combo box with a dropdown of a given list of string options.
class OwnCounter extends StatefulWidget {
  /// Creates a [OwnCounter]
  const OwnCounter({
    super.key,
    required this.initialVal,
    this.minVal = 0,
    this.maxVal = 10,
    this.onChanged,
    this.label,
    this.isEditable = true,
  });

  /// The initial value the counter should be set to.
  final int initialVal;

  /// The minimum value the counter should be able to have.
  final int minVal;

  /// The maximum value the counter should be able to have.
  final int maxVal;

  /// The callback that is called when the dropdown value changes.
  final Function(int)? onChanged;

  /// The label of the TextField of the counter.
  final String? label;

  /// Wether the text field should be editable.
  final bool isEditable;

  /// The regexp filter pattern to filter the input of the counter.
  String get filterPattern => '^($minVal|$maxVal' r'|[1-9][0-9]?)$';

  @override
  OwnCounterState createState() => OwnCounterState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    properties
      ..add(IntProperty('initialVal', initialVal))
      ..add(IntProperty('minVal', minVal))
      ..add(IntProperty('maxVal', maxVal))
      ..add(ObjectFlagProperty<Function(int p1)?>.has('onChanged', onChanged))
      ..add(StringProperty('filterPattern', filterPattern))
      ..add(StringProperty('label', label))
      ..add(DiagnosticsProperty<bool>('isEditable', isEditable));
  }
}

/// The state of a [OwnCounter].
class OwnCounterState extends State<OwnCounter> {
  /// The current value of the counter.
  late int _counterVal;

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _counterVal = widget.initialVal;
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        // TextField lost focus, call onEditingComplete
        _setCounterVal(_controller.text, isEditingComplete: true);
      }
    });

    _setControllerValue();
  }

  @override
  void dispose() {
    // Clean up the focus node and textController when the Form is disposed
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  bool get _decrementDisabled => _counterVal <= widget.minVal;
  bool get _incrementDisabled => _counterVal >= widget.maxVal;

  void _setControllerValue() {
    _controller
      ..text = '$_counterVal'
      ..selection = TextSelection.collapsed(offset: _controller.text.length);
  }

  /// Decrement the counter by one.
  void _decrementCounter() {
    if (_decrementDisabled) return;
    setState(() {
      _counterVal--;
      widget.onChanged?.call(_counterVal);
      _setControllerValue();
    });
  }

  /// Increment the counter by one.
  void _incrementCounter() {
    if (_incrementDisabled) return;
    setState(() {
      _counterVal++;
      widget.onChanged?.call(_counterVal);
      _setControllerValue();
    });
  }

  void _setCounterVal(String value, {bool isEditingComplete = false}) {
    final newVal = int.tryParse(value) ?? 0;
    final isValid = newVal <= widget.maxVal && newVal >= widget.minVal;
    setState(() {
      if (isValid) {
        _counterVal = newVal;
        widget.onChanged?.call(_counterVal);
        _setControllerValue();
      } else if (isEditingComplete) {
        // Set the counter value to the closest valid value:
        _counterVal = newVal.clamp(widget.minVal, widget.maxVal);
        _setControllerValue();
      } else if (value == '' || newVal < widget.minVal) {
        // This is safe because we properly set the value if focus is lost.
        _counterVal = newVal;
        _controller
          ..text = value
          ..selection =
              TextSelection.collapsed(offset: _controller.text.length);
      } else {
        _setControllerValue();
      }
    });
  }

  @override
  Widget build(BuildContext context) => Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              onPressed: _decrementDisabled ? null : _decrementCounter,
              backgroundColor:
                  _decrementDisabled ? Colors.grey : Colors.deepPurple,
              child: const Icon(Icons.remove),
            ),
            Expanded(
              child: Theme(
                data: Theme.of(context).copyWith(
                  disabledColor: Colors.black,
                ),
                child: TextFormField(
                  style: const TextStyle(color: Colors.black),
                  enabled: widget.isEditable,
                  keyboardType: TextInputType.number,
                  focusNode: _focusNode,
                  autocorrect: false,
                  controller: _controller,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  textAlign: TextAlign.center,
                  onChanged: _setCounterVal,
                  onEditingComplete: () =>
                      _setCounterVal(_controller.text, isEditingComplete: true),
                  decoration: InputDecoration(
                    fillColor: Colors.white.withAlpha(100),
                    label: Text(widget.label ?? ''),
                    hintText: '${widget.minVal} - ${widget.maxVal}',
                  ),
                ),
              ),
            ),
            FloatingActionButton(
              onPressed: _incrementDisabled ? null : _incrementCounter,
              backgroundColor:
                  _incrementDisabled ? Colors.grey : Colors.deepPurple,
              child: const Icon(Icons.add),
            ),
          ],
        ),
      );
}
