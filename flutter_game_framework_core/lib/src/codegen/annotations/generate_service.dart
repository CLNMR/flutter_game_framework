/// Annotation to generate a service class.
class GenerateService {
  /// Creates a [GenerateService].
  const GenerateService({
    this.updateMask = false,
    this.fromYust = false,
    this.setupFromUserId = false,
  });

  /// Indicates whether the update mask should be used.
  final bool updateMask;

  /// Indicates whether it is just an extension to a model created in Yust.
  final bool fromYust;

  /// Indicates whether the service should be setup for the user ID.
  final bool setupFromUserId;
}
