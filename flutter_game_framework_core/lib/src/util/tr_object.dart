import 'rich_tr_object.dart';

/// A class that represents a translation object.
class TrObject {
  /// Creates a new translation object.
  TrObject(
    this.text, {
    this.args,
    this.namedArgs,
    this.gender,
    this.namedArgsTrObjects,
    this.richTrObjects,
  });

  /// The key for the translation.
  String text;

  /// A list of arguments for the translation.
  List<String>? args;

  /// A map of named arguments for the translation.
  Map<String, String>? namedArgs;

  /// A map of named arguments that are themselves translation objects.
  Map<String, TrObject>? namedArgsTrObjects;

  /// The rich TrObjects that will be translated and highlighted.
  List<RichTrObject>? richTrObjects;

  /// The gender of the translation.
  String? gender;
}
