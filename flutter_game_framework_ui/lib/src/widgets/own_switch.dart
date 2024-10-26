import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A switch to select between two options.
class OwnSwitch extends StatelessWidget {
  /// Creates a [OwnSwitch].
  const OwnSwitch({
    super.key,
    required this.firstOptionKey,
    required this.secondOptionKey,
    required this.secondOption,
    required this.onChange,
  });

  /// The key of the first option.
  final String firstOptionKey;

  /// The key of the second option.
  final String secondOptionKey;

  /// Whether the second option is selected.
  final bool secondOption;

  /// Called when the user toggles the switch.
  // ignore: avoid_positional_boolean_parameters
  final void Function(bool value) onChange;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('firstOptionKey', firstOptionKey))
      ..add(StringProperty('secondOptionKey', secondOptionKey))
      ..add(DiagnosticsProperty<bool>('secondOption', secondOption))
      ..add(
        // ignore: avoid_positional_boolean_parameters
        ObjectFlagProperty<void Function(bool value)>.has(
          'onChange',
          onChange,
        ),
      );
  }

  @override
  Widget build(BuildContext context) => Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            left: secondOption ? null : 0,
            right: secondOption ? 0 : null,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const SizedBox(
                width: 100,
                height: 40,
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 100,
                height: 40,
                child: Center(
                  child: Text(context.tr('SWITCH:$firstOptionKey')),
                ),
              ),
              SizedBox(
                width: 100,
                height: 40,
                child: Center(
                  child: Text(context.tr('SWITCH:$secondOptionKey')),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => onChange(!secondOption),
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const SizedBox(
                width: 200,
                height: 40,
              ),
            ),
          ),
        ],
      );
}
