import 'package:flutter/material.dart';

class LoadingFailureModel {
  final String? title;
  final String? btnText;
  final VoidCallback? onRetry;
  final Widget? retryButton;

  LoadingFailureModel({
    this.title,
    this.btnText,
    this.onRetry,
    this.retryButton,
  });
}
