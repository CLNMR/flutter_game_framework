import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';

/// A visitor to get the class name of a model.
class ModelVisitor extends SimpleElementVisitor<dynamic> {
  /// The name of the class.
  String className = '';

  /// The fields of the class.
  Map<String, dynamic> fields = <String, dynamic>{};

  @override
  dynamic visitConstructorElement(ConstructorElement element) {
    final elementReturnType = element.type.returnType.toString();

    // DartType ends with '*', which needs to be eliminated
    // for the generated code to be accurate.
    if (elementReturnType != '') {
      className = elementReturnType.replaceFirst('*', '');
    }
  }

  @override
  dynamic visitExtensionElement(ExtensionElement element) {
    final elementExtendedType = element.extendedType.toString();

    // DartType ends with '*', which needs to be eliminated
    // for the generated code to be accurate.
    if (elementExtendedType != '') {
      className = elementExtendedType.replaceFirst('*', '');
    }
  }
}
