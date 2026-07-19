import 'package:enhanced_paginated_view/src/models/error_page_config.dart';
import 'package:flutter/material.dart';

/// A widget that displays a failure message with an optional retry button.
///
/// The `ErrorPageWidget` is typically used to indicate that the first page
/// failed to load. It displays a title, a description, and a retry button.
///
/// Example usage:
/// ```dart
/// ErrorPageWidget(
///   config: ErrorPageConfig(
///     title: 'Error',
///     description: 'Something went wrong. Please try again.',
///     btnText: 'Retry',
///     onRetry: () {
///       // Retry logic here
///     },
///   ),
/// )
/// ```
class ErrorPageWidget extends StatelessWidget {
  /// Creates an `ErrorPageWidget` for a box-based view.
  const ErrorPageWidget({super.key, required this.config});

  /// The configuration for the error page.
  final ErrorPageConfig config;

  @override
  Widget build(BuildContext context) {
    return config.customView ?? SafeArea(child: _FailureWidget(config: config));
  }
}

/// A widget that displays the failure message and retry button.
class _FailureWidget extends StatelessWidget {
  const _FailureWidget({required this.config});

  /// The configuration for the error page.
  final ErrorPageConfig config;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Spacer(flex: 2),
          Text(
            config.title ?? "Oops!",
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            config.description ??
                "Something wrong with your connection, Please try again after a moment.",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16 * 2.5),
          config.customButton ??
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                onPressed: config.onRetry,
                child: Text(config.btnText ?? "Retry".toUpperCase()),
              ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
