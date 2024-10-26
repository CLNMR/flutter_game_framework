import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:source_gen/source_gen.dart';

import '../annotations/generate_service.dart';
import 'model_visitor.dart';

/// The different sources to get the data from.
enum Source {
  /// Gets the data from the DB, otherwise the cache.
  standard(''),

  /// Gets the data from the cache, otherwise the server.
  cache('FromCache'),

  /// Gets the data from the DB, otherwise null.
  db('FromDB'),

  /// Gets the data from the DB as a stream.
  stream('Stream');

  const Source(this.name);

  /// The name of the source.
  final String name;
}

/// The different results to get.
enum Result {
  /// Gets a single document by ID.
  doc(''),

  /// Gets the first document.
  first('First'),

  /// Gets the data as a list.
  list('List');

  const Result(this.name);

  /// The name of the result.
  final String name;
}

/// Generates a service for each class annotated with [GenerateService].
class ServiceGenerator extends GeneratorForAnnotation<GenerateService> {
  /// The name of the class that is visited.
  late String className;

  /// Indicates whether the update mask should be used.
  late bool updateMask;

  /// Indicates whether it is just an extension to a model created in Yust.
  late bool fromYust;

  /// Indicates whether the service should be setup for the user ID.
  late bool setupFromUserId;

  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    final visitor = ModelVisitor();
    element.visitChildren(visitor);
    className = visitor.className;

    if (className == '') {
      className = (element as ExtensionElement).extendedType.toString();
    }

    updateMask = annotation.read('updateMask').boolValue;
    fromYust = annotation.read('fromYust').boolValue;
    setupFromUserId = annotation.read('setupFromUserId').boolValue;

    final service = Library(
      (b) => b
        ..directives.addAll([
          Directive.import('package:yust/yust.dart'),
          if (!fromYust) Directive.import(element.library?.identifier ?? ''),
        ])
        ..body.addAll([
          Class(
            (b) => b
              ..name = '${className}Service'
              ..methods.addAll([
                ...Source.values
                    .map<Iterable<Method>>(
                      (source) => Result.values.map<Method>(
                        (result) => _buildMethod(source, result),
                      ),
                    )
                    .reduce((value, element) => element.followedBy(value)),
                _getListChunked(),
                _count(),
                _init(),
                _deleteAll(),
                _deleteById(),
              ])
              ..docs.add('/// A service to get elements of [$className].'),
          ),
          Extension(
            (b) => b
              ..name = '${className}Save'
              ..on = refer(className)
              ..methods.addAll([
                _save(),
                _update(),
                _delete(),
              ])
              ..docs.add('/// An extension to save and delete elements '
                  'of [$className].'),
          ),
        ]),
    );

    return '''
    // ignore_for_file: directives_ordering, prefer_relative_imports, empty_statements, lines_longer_than_80_chars
    ${DartFormatter().format('${service.accept(DartEmitter(useNullSafetySyntax: true))}')}''';
  }

  Method _buildMethod(Source source, Result result) {
    final methodName = 'get${result.name}${source.name}';
    final stream = source == Source.stream;
    final db = source == Source.db;
    final cache = source == Source.cache;
    final get = source == Source.standard;
    final list = result == Result.list;
    final doc = result == Result.doc;
    final first = result == Result.first;
    return Method(
      (b) => b
        ..name = methodName
        ..static = true
        ..modifier = stream ? null : MethodModifier.async
        ..returns = TypeReference(
          (b) => b
            ..symbol = stream ? 'Stream' : 'Future'
            ..types.add(
              _wrapListIfList(
                TypeReference(
                  (b) => b
                    ..symbol = className
                    ..isNullable = !list,
                ),
                list,
              ),
            ),
        )
        ..requiredParameters.addAll([
          if (result == Result.doc)
            Parameter(
              (b) => b
                ..name = 'id'
                ..type = refer('String').type,
            ),
        ])
        ..optionalParameters.addAll(
          result != Result.doc
              ? [
                  Parameter(
                    (b) => b
                      ..name = 'filters'
                      ..named = true
                      ..type = refer('List<YustFilter>?'),
                  ),
                  Parameter(
                    (b) => b
                      ..name = 'orderBy'
                      ..named = true
                      ..type = refer('List<YustOrderBy>?'),
                  ),
                  if (result == Result.list)
                    Parameter(
                      (b) => b
                        ..name = 'limit'
                        ..named = true
                        ..type = refer('int?'),
                    ),
                ]
              : [],
        )
        ..body = refer('Yust')
            .property('databaseService')
            .property('$methodName<$className>')
            .call(
          [
            callSetup(),
            if (result == Result.doc) refer('id'),
          ],
          result != Result.doc
              ? {
                  'filters': refer('filters'),
                  'orderBy': refer('orderBy'),
                  if (list) 'limit': refer('limit'),
                }
              : {},
        ).code
        ..docs.add('''
          /// Returns${stream ? ' a stream of' : ''} ${doc ? 'a [$className]' : first ? 'the first [$className]' : '[$className]s'}${stream ? '.' : ' ${db ? 'directly ' : ''}from the ${cache ? 'cache' : 'server'}, if available, otherwise from the ${cache ? 'server' : 'cache'}.'}
          /// ${get || cache ? 'The cached documents may not be up to date!' : ''}
          ///
          /// ${stream ? 'Whenever another user makes a change, a new version of the document is returned.' : 'Be careful with offline functionality.'}
          /// ${first ? 'The result is null if no document was found.' : list ? '''
          
          /// [filters] each entry represents a condition that has to be met.
          /// All of those conditions must be true for each returned entry.
          ///
          /// [orderBy] orders the returned records.
          /// Multiple of those entries can be repeated.
          ///
          /// [limit] can be passed to only get at most n documents.''' : ''}'''),
    );
  }

  TypeReference _wrapListIfList(TypeReference t, bool list) => list
      ? TypeReference(
          (b) => b
            ..symbol = 'List'
            ..types.add(t),
        )
      : t;

  Method _getListChunked() => Method(
        (b) => b
          ..name = 'getListChunked'
          ..static = true
          ..returns = TypeReference(
            (b) => b
              ..symbol = 'Stream'
              ..types.add(TypeReference((b) => b..symbol = className)),
          )
          ..requiredParameters.addAll([])
          ..optionalParameters.addAll([
            Parameter(
              (b) => b
                ..name = 'filters'
                ..named = true
                ..type = refer('List<YustFilter>?'),
            ),
            // ..types.add(TypeReference((b) => b..symbol = 'YustFilter'))),
            Parameter(
              (b) => b
                ..name = 'orderBy'
                ..named = true
                ..type = refer('List<YustOrderBy>?'),
            ),
            // ..types.add(TypeReference((b) => b..symbol = 'YustOrderBy'))),
            Parameter(
              (b) => b
                ..name = 'pageSize'
                ..named = true
                ..type = refer('int')
                ..defaultTo = const Code('5000'),
            ),
          ])
          ..body = refer('Yust')
              .property('databaseService')
              .property('getListChunked<$className>')
              .call(
            [callSetup()],
            {
              'filters': refer('filters'),
              'orderBy': refer('orderBy'),
              'pageSize': refer('pageSize'),
            },
          ).code
          ..docs.add('''
  /// Returns [$className]s as a lazy, chunked Stream from the database.
  ///
  /// This is much more memory efficient in comparison to other methods,
  /// because of three reasons:
  /// 1. It gets the data in multiple requests ([pageSize] each); the raw json
  ///    strings and raw maps are only in memory while one chunk is processed.
  /// 2. It loads the records *lazily*, meaning only one chunk is in memory while
  ///    the records worked with (e.g. via a `await for(...)`)
  /// 3. It doesn't use the google_apis package for the request, because that
  ///    has a huge memory leak
  ///
  /// NOTE: Because this is a Stream you may only iterate over it once,
  /// listening to it multiple times will result in a runtime-exception!
  ///
  /// [filters] each entry represents a condition that has to be met.
  /// All of those conditions must be true for each returned entry.
  ///
  /// [orderBy] orders the returned records.
  /// Multiple of those entries can be repeated.
  ///'''),
      );

  Method _count() => Method(
        (b) => b
          ..name = 'count'
          ..static = true
          ..returns = TypeReference(
            (b) => b
              ..symbol = 'Future'
              ..types.add(refer('int')),
          )
          ..requiredParameters.addAll([])
          ..optionalParameters.addAll([
            Parameter(
              (b) => b
                ..name = 'filters'
                ..named = true
                ..type = refer('List<YustFilter>?'),
            ),
          ])
          ..body = refer('Yust')
              .property('databaseService')
              .property('count<$className>')
              .call(
            [callSetup()],
            {
              'filters': refer('filters'),
            },
          ).code
          ..docs.add('''
  /// Returns the count of [$className]s in the database.
  /// 
  /// Please note, that this is still priced per item, therefore don't overuse it
  /// on large collections.
  ///
  /// [filters] each entry represents a condition that has to be met.
  /// All of those conditions must be true for each returned entry.
  ///
  ///'''),
      );

  Method _init() => Method(
        (b) => b
          ..name = 'init'
          ..static = true
          ..returns = TypeReference((b) => b..symbol = className)
          ..requiredParameters.addAll([])
          ..optionalParameters.add(
            Parameter(
              (b) => b
                ..name = 'doc'
                ..named = false
                ..type = refer('$className?'),
            ),
          )
          ..body = refer('Yust')
              .property('databaseService')
              .property('initDoc<$className>')
              .call(
            [
              callSetup(),
              refer('doc'),
            ],
          ).code
          ..docs.add('''
          /// Initializes a [$className] with an id and the time it was created.
          ///
          /// Optionally an existing [$className] can be given, which will still be
          /// assigned a new id becoming a new [$className] if it had an id previously.'''),
      );

  Method _deleteAll() => Method(
        (b) => b
          ..name = 'deleteAll'
          ..static = true
          ..returns = TypeReference((b) => b..symbol = 'Future<void>')
          ..requiredParameters.addAll([])
          ..optionalParameters.addAll([
            Parameter(
              (b) => b
                ..name = 'filters'
                ..named = true
                ..type = refer('List<YustFilter>?'),
            ),
          ])
          ..body = refer('Yust')
              .property('databaseService')
              .property('deleteDocs<$className>')
              .call(
            [callSetup()],
            {
              'filters': refer('filters'),
            },
          ).code
          ..docs.add('/// Delete all [$className]s in the filter.'),
      );

  Method _deleteById() => Method(
        (b) => b
          ..name = 'deleteById'
          ..static = true
          ..returns = TypeReference((b) => b..symbol = 'Future<void>')
          ..requiredParameters.addAll([
            Parameter(
              (b) => b
                ..name = 'id'
                ..type = refer('String').type,
            ),
          ])
          ..body = refer('Yust')
              .property('databaseService')
              .property('deleteDocById<$className>')
              .call(
            [
              callSetup(),
              refer('id'),
            ],
          ).code
          ..docs.add('/// Delete a [$className].'),
      );

  Method _save() => Method(
        (b) => b
          ..name = 'save'
          ..modifier = MethodModifier.async
          ..returns = TypeReference((b) => b..symbol = 'Future<void>')
          ..requiredParameters.addAll([])
          ..optionalParameters.addAll([
            Parameter(
              (b) => b
                ..name = 'merge'
                ..named = true
                ..defaultTo = const Code('true')
                ..type = refer('bool'),
            ),
            Parameter(
              (b) => b
                ..name = 'trackModification'
                ..named = true
                ..type = refer('bool?'),
            ),
            Parameter(
              (b) => b
                ..name = 'skipOnSave'
                ..named = true
                ..defaultTo = const Code('false')
                ..type = refer('bool'),
            ),
            Parameter(
              (b) => b
                ..name = 'removeNullValues'
                ..named = true
                ..type = refer('bool?'),
            ),
            Parameter(
              (b) => b
                ..name = 'doNotCreate'
                ..named = true
                ..defaultTo = const Code('false')
                ..type = refer('bool'),
            ),
            if (updateMask)
              Parameter(
                (b) => b
                  ..name = 'useUpdateMask'
                  ..named = true
                  ..defaultTo = const Code('true')
                  ..type = refer('bool'),
              ),
          ])
          ..body = Block((b) {
            if (updateMask) {
              b.statements
                  .add(const Code('if (hasChanges || !useUpdateMask) {'));
            }
            b.addExpression(
              refer('Yust')
                  .property('databaseService')
                  .property('saveDoc<$className>')
                  .call(
                [
                  callSetup(),
                  refer('this'),
                ],
                {
                  if (updateMask)
                    'updateMask':
                        refer('useUpdateMask ? updateMask.toList() : null'),
                  'trackModification': refer('trackModification ?? false'),
                  'skipOnSave': refer('skipOnSave'),
                  'doNotCreate': refer('doNotCreate'),
                  'merge': refer('merge'),
                  'removeNullValues': refer('removeNullValues'),
                },
              ).awaited,
            );
            if (updateMask) {
              b.statements.add(const Code('clearUpdateMask();}'));
            }
          })
          ..docs.add('/// Saves the document.'),
      );

  Method _update() => Method(
        (b) => b
          ..name = 'updateByTransform'
          ..modifier = MethodModifier.async
          ..returns = TypeReference((b) => b..symbol = 'Future<void>')
          ..requiredParameters.addAll([
            Parameter(
              (b) => b
                ..name = 'fieldTransforms'
                ..type = refer('List<YustFieldTransform>').type,
            ),
          ])
          ..optionalParameters.addAll([
            Parameter(
              (b) => b
                ..name = 'removeNullValues'
                ..named = true
                ..type = refer('bool?'),
            ),
            Parameter(
              (b) => b
                ..name = 'skipOnSave'
                ..named = true
                ..defaultTo = const Code('false')
                ..type = refer('bool'),
            ),
          ])
          ..body = refer('Yust')
              .property('databaseService')
              .property('updateDocByTransform<$className>')
              .call(
            [
              callSetup(),
              refer('id'),
              refer('fieldTransforms'),
            ],
            {
              'removeNullValues': refer('removeNullValues'),
              'skipOnSave': refer('skipOnSave'),
            },
          ).code
          ..docs.add(
            '/// Transforms (e.g. increment, decrement) a documents fields.',
          ),
      );

  Method _delete() => Method(
        (b) => b
          ..name = 'delete'
          ..modifier = MethodModifier.async
          ..returns = TypeReference((b) => b..symbol = 'Future<void>')
          ..requiredParameters.addAll([])
          ..body = refer('Yust')
              .property('databaseService')
              .property('deleteDoc<$className>')
              .call([
            callSetup(),
            refer('this'),
          ]).code
          ..docs.add('/// Deletes the document.'),
      );

  /// Returns the call to setup the service.
  Expression callSetup() => refer(className).property('setup').call([
        if (setupFromUserId) refer("stateSnap.userId ?? ''"),
      ]);
}
