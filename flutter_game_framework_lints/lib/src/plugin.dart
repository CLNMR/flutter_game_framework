import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'rules/missing_translation_key.dart';

class GameFrameworkLintsPlugin extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        MissingTranslationKeyRule(),
      ];
}
