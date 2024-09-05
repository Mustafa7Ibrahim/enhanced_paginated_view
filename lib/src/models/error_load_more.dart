import 'package:flutter/material.dart';

class ErrorLoadMore {
  final String? title;
  final String? btnText;
  final VoidCallback? onRetry;
  final Widget? retryButton;

  const ErrorLoadMore({
    this.title,
    this.btnText,
    this.onRetry,
    this.retryButton,
  });
}
