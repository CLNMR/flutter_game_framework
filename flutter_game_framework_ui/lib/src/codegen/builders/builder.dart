import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'routing_generator.dart';

/// A builder to generate the path and routes of the screens.
Builder generateRouting(BuilderOptions options) =>
    LibraryBuilder(RoutingGenerator(), generatedExtension: '.r.dart');
