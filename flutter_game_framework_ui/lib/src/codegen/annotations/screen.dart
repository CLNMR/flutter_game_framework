/// Annotation to mark a class as a screen.
class Screen {
  /// Creates a [Screen].
  const Screen({this.path, this.param});

  /// The path of the screen, if different from the class name.
  final String? path;

  /// The parameter of the screen.
  final String? param;
}
