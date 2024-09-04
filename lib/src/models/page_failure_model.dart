import 'package:flutter/material.dart';

class PageFailureModel {
  /// The title of the failure message.
  final String? title;

  /// A description of the failure.
  final String? description;

  /// The text to display on the retry button.
  final String? btnText;

  /// A callback function to be called when the retry button is pressed.
  final VoidCallback? onRetry;

  /// A custom widget for the retry button.
  final Widget? retryButton;

  PageFailureModel({
    this.title,
    this.description,
    this.btnText,
    this.onRetry,
    this.retryButton,
  });
}
