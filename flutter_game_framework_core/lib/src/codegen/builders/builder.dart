import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import '../annotations/generate_service.dart';
import 'service_generator.dart';

/// Generates a service for each class annotated with [GenerateService].
Builder generateService(BuilderOptions options) =>
    LibraryBuilder(ServiceGenerator(), generatedExtension: '.service.dart');
