// ignore_for_file: comment_references

/// Annotation to generate a service class.
class GenerateService {
  /// Creates a [GenerateService].
  const GenerateService({
    this.updateMask = false,
    this.fromYust = false,
    this.setupFromUserId = false,
    this.skipSaveExtension = false,
  });

  /// Indicates whether the update mask should be used.
  final bool updateMask;

  /// Indicates whether it is just an extension to a model created in Yust.
  final bool fromYust;

  /// Indicates whether the service should be setup for the user ID.
  final bool setupFromUserId;

  /// When true, skip generating the save/update/delete extension.
  /// Use when the annotated class already defines its own [save] method
  /// (e.g., overriding a parent class), which would shadow the generated
  /// extension.
  final bool skipSaveExtension;
}
