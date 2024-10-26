import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';

/// A visitor that visits [ConstructorElement]s and [ExtensionElement]s
class ModelVisitor extends SimpleElementVisitor<dynamic> {
  /// The name of the class that is visited.
  String className = '';

  /// The fields of the class that is visited.
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
