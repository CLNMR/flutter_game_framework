import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:source_gen/source_gen.dart';

import '../annotations/screen.dart';
import 'model_visitor.dart';

/// A generator for the path and routes of the screens.
class RoutingGenerator extends GeneratorForAnnotation<Screen> {
  late String _screenName;
  late String? _screenPath;
  late String? _screenParam;

  final List<String> _routes = [];

  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    final visitor = ModelVisitor();
    element.visitChildren(visitor);
    _screenName = visitor.className;

    if (_screenName == '') {
      _screenName = (element as ExtensionElement).extendedType.toString();
    }

    _screenPath = annotation.peek('path')?.stringValue;

    _screenParam = annotation.peek('param')?.stringValue;

    _routes.add('$_screenName.route,');

    final screenExtension = Library(
      (b) => b
        ..directives.addAll(
          [
            Directive.import('package:go_router/go_router.dart'),
            Directive.import(element.library?.identifier ?? ''),
          ],
        )
        ..body.addAll(
          [
            Extension(
              (b) => b
                ..name = '${_screenName}Routing'
                ..on = refer(_screenName)
                ..fields.addAll(
                  [
                    _path(),
                    _param(),
                    _route(),
                  ],
                )
                ..docs.add('/// The path and route of the screen.'),
            ),
          ],
        ),
    );

    return '''
    // ignore_for_file: directives_ordering, prefer_relative_imports
    // ignore_for_file: prefer_const_constructors
    ${DartFormatter().format('${screenExtension.accept(DartEmitter(useNullSafetySyntax: true))}')}
    ''';
  }

  Field _path() {
    final path =
        _screenPath ?? _screenName.toLowerCase().replaceAll('screen', '');
    return Field(
      (b) => b
        ..name = 'path'
        ..static = true
        ..modifier = FieldModifier.constant
        ..type = refer('String')
        ..assignment = literalString('/$path').code
        ..docs.add('/// The path of the screen.'),
    );
  }

  Field _param() => Field(
        (b) => b
          ..name = 'param'
          ..static = true
          ..modifier = FieldModifier.constant
          ..type = refer('String${_screenParam == null ? '?' : ''}')
          ..assignment = _screenParam != null
              ? literalString(_screenParam!).code
              : const Code('null')
          ..docs.add('/// The parameter of the screen.'),
      );

  Field _route() => Field(
        (b) => b
          ..name = 'route'
          ..static = true
          ..type = refer('GoRoute')
          ..assignment = refer(
            'GoRoute',
            'package:go_router/go_router.dart',
          ).call(
            [],
            {
              'path': _screenParam != null
                  ? literalString(r'$path/:$param')
                  : refer('path'),
              'name': refer('path'),
              'builder': Method(
                (b) => b
                  ..requiredParameters.addAll([
                    Parameter((b) => b..name = 'context'),
                    Parameter((b) => b..name = 'state'),
                  ])
                  ..body = refer(_screenName).newInstance([], {
                    if (_screenParam != null)
                      '$_screenParam': refer('state.pathParameters[param]!,'),
                  }).code,
              ).closure,
            },
          ).code
          ..docs.add('/// The route of the screen.'),
      );
}
