import 'package:flutter/material.dart';

/// Represents the configuration for an error page.
///
/// An error page is displayed when there is a failure in loading data for the first page.
class ErrorPageConfig {
  /// The title of the failure message.
  final String? title;

  /// A description of the failure.
  final String? description;

  /// The text to display on the retry button.
  final String? btnText;

  /// A callback function to be called when the retry button is pressed.
  final VoidCallback? onRetry;

  /// A custom widget for the retry button.
  final Widget? customButton;

  /// Creates a new instance of [ErrorPageConfig].
  ///
  /// The [title] parameter represents the title of the failure message.
  ///
  /// The [description] parameter represents a description of the failure.
  ///
  /// The [btnText] parameter represents the text to display on the retry button.
  ///
  /// The [onRetry] parameter represents a callback function to be called when the retry button is pressed.
  ///
  /// The [customButton] parameter represents a custom widget for the retry button.
  const ErrorPageConfig({
    this.title,
    this.description,
    this.btnText,
    this.onRetry,
    this.customButton,
  });
}
