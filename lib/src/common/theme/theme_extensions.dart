import 'package:flutter/material.dart';

/// Extension methods on [BuildContext] allows us to have shorter syntax for
/// common things like text theme
extension BuildContextEntension<T> on BuildContext {
  // Text styles
  //
  //
  /// Style for displaySmall
  TextStyle? get displaySmall => Theme.of(this).textTheme.displaySmall;

  /// Style for headlineLarge
  TextStyle? get headlineLarge => Theme.of(this).textTheme.headlineLarge;

  /// Style for headlineMedium
  TextStyle? get headlineMedium => Theme.of(this).textTheme.headlineMedium;

  /// Style for headlineSmall
  TextStyle? get headlineSmall => Theme.of(this).textTheme.headlineSmall;

  /// Style for titleLarge
  TextStyle? get titleLarge => Theme.of(this).textTheme.titleLarge;

  /// Style for titleMedium
  TextStyle? get titleMedium => Theme.of(this).textTheme.titleMedium;

  /// Style for titleSmall
  TextStyle? get titleSmall => Theme.of(this).textTheme.titleSmall;

  /// Style for bodyLarge
  TextStyle? get bodyLarge => Theme.of(this).textTheme.bodyLarge;

  /// Style for bodyMedium
  TextStyle? get bodyMedium => Theme.of(this).textTheme.bodyMedium;

  /// Style for bodySmall
  TextStyle? get bodySmall => Theme.of(this).textTheme.bodySmall;

  /// Style for labelLarge
  TextStyle? get labelLarge => Theme.of(this).textTheme.labelLarge;

  /// Style for labelMedium
  TextStyle? get labelMedium => Theme.of(this).textTheme.labelMedium;

  /// Style for labelSmall
  TextStyle? get labelSmall => Theme.of(this).textTheme.labelSmall;

  /// colorScheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Theme Extension
  T? Function<T>() get extension => Theme.of(this).extension;
}
