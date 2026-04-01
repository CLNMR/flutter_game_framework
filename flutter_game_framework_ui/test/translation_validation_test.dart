import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  late Map<String, dynamic> en;
  late Map<String, dynamic> de;

  setUp(() {
    en = _loadJson('assets/localizables/en-US.json');
    de = _loadJson('assets/localizables/de-DE.json');
  });

  test('en-US and de-DE have the same keys', () {
    final enKeys = en.keys.toSet();
    final deKeys = de.keys.toSet();
    final missingInDe = enKeys.difference(deKeys);
    final missingInEn = deKeys.difference(enKeys);
    expect(missingInDe, isEmpty,
        reason: 'Keys in en-US but missing from de-DE: $missingInDe');
    expect(missingInEn, isEmpty,
        reason: 'Keys in de-DE but missing from en-US: $missingInEn');
  });

  test('no empty translation values', () {
    final emptyEn = en.entries
        .where((e) => e.value.toString().isEmpty)
        .map((e) => e.key)
        .toList();
    final emptyDe = de.entries
        .where((e) => e.value.toString().isEmpty)
        .map((e) => e.key)
        .toList();
    expect(emptyEn, isEmpty, reason: 'Empty EN keys: $emptyEn');
    expect(emptyDe, isEmpty, reason: 'Empty DE keys: $emptyDe');
  });

  test('all static .tr() keys exist in translations', () {
    final usedKeys = _extractStaticKeys(Directory('lib/src'));
    final available = en.keys.toSet();
    final missing = usedKeys.difference(available);
    expect(missing, isEmpty,
        reason: 'Keys used in code but missing from en-US.json: $missing');
  });
}

Map<String, dynamic> _loadJson(String path) =>
    json.decode(File(path).readAsStringSync()) as Map<String, dynamic>;

/// Scans Dart source files for static translation keys.
///
/// Finds patterns like `'someKey'.tr()` and `context.tr('someKey')`.
/// Skips keys with string interpolation (`$`) since those are dynamic.
Set<String> _extractStaticKeys(Directory dir) {
  final keys = <String>{};
  for (final file in dir.listSync(recursive: true)) {
    if (file is! File || !file.path.endsWith('.dart')) continue;
    final content = file.readAsStringSync();

    // Match 'someKey'.tr()
    for (final m in RegExp(r"'([^']+)'\.tr\(").allMatches(content)) {
      final key = m.group(1)!;
      if (!key.contains(r'$')) keys.add(key);
    }

    // Match context.tr('someKey')
    for (final m
        in RegExp(r"context\.tr\('([^']+)'\)").allMatches(content)) {
      final key = m.group(1)!;
      if (!key.contains(r'$')) keys.add(key);
    }
  }
  return keys;
}
