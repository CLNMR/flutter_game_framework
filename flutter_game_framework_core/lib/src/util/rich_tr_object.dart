import 'rich_tr_object_type.dart';

/// An object that is going to be translatable to a rich text span.
class RichTrObject {
  /// Creates a [RichTrObject].
  RichTrObject(this.trType, {required this.value, this.keySuffix = ''}) {
    assert(
      value.runtimeType.toString() == trType.valueType.toString() ||
          value is Map,
      'Encountered $value ${value.runtimeType}, expected $trType.',
    );
  }

  /// The value associated with the object, e.g. a Coordinates object or an
  /// integer.
  final dynamic value;

  /// The type of this object.
  final RichTrType trType;

  /// The suffix to be appended to the key in the translation file, if needed.
  final String keySuffix;

  /// The key that this object is referred to in the translation file.
  String get key => trType.name + keySuffix;
}
