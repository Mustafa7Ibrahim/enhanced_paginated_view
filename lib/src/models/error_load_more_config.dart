import 'package:flutter/material.dart';

/// Represents the configuration for handling error while loading more data.
///
/// Use this class to customize the error message, button text, retry function,
/// and custom button widget when an error occurs while loading more data.
@immutable
class ErrorLoadMoreConfig {
  /// Creates an instance of [ErrorLoadMoreConfig].
  ///
  /// The [title] parameter is optional and can be used to set the title of the error message.
  ///
  /// The [btnText] parameter is optional and can be used to set the text of the retry button.
  ///
  /// The [onRetry] parameter is optional and can be used to set the function to be called when the retry button is pressed.
  ///
  /// The [customButton] parameter is optional and can be used to set a custom button widget to be displayed instead of the default retry button.
  const ErrorLoadMoreConfig({
    this.title,
    this.btnText,
    this.onRetry,
    this.customButton,
  });

  /// The title of the error message.
  final String? title;

  /// The text to be displayed on the retry button.
  final String? btnText;

  /// The function to be called when the retry button is pressed.
  final void Function(int page)? onRetry;

  /// A custom button widget to be displayed instead of the default retry button.
  final Widget? customButton;

  /// Creates a copy of this config with the given fields replaced.
  ErrorLoadMoreConfig copyWith({
    String? title,
    String? btnText,
    void Function(int page)? onRetry,
    Widget? customButton,
  }) {
    return ErrorLoadMoreConfig(
      title: title ?? this.title,
      btnText: btnText ?? this.btnText,
      onRetry: onRetry ?? this.onRetry,
      customButton: customButton ?? this.customButton,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ErrorLoadMoreConfig &&
        other.title == title &&
        other.btnText == btnText &&
        other.onRetry == onRetry &&
        other.customButton == customButton;
  }

  @override
  int get hashCode => Object.hash(title, btnText, onRetry, customButton);
}
