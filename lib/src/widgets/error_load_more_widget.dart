import 'package:enhanced_paginated_view/src/models/error_load_more_config.dart';
import 'package:flutter/material.dart';

/// A widget that displays an error message and a retry button when loading more data fails.
class ErrorLoadMoreWidget extends StatelessWidget {
  /// Creates an `ErrorLoadMoreWidget` for a box-based view.
  ///
  /// The [page] parameter specifies the current page number.
  /// The [config] parameter specifies the configuration for the error widget.
  const ErrorLoadMoreWidget({
    super.key,
    required this.page,
    this.config = const ErrorLoadMoreConfig(),
  });

  /// The configuration for the error widget.
  final ErrorLoadMoreConfig config;

  /// The current page number.
  final int page;

  /// Creates an `ErrorLoadMoreWidget` for a sliver-based view.
  ///
  /// The [page] parameter specifies the current page number.
  /// The [config] parameter specifies the configuration for the error widget.
  static Widget sliver({
    Key? key,
    required int page,
    ErrorLoadMoreConfig config = const ErrorLoadMoreConfig(),
  }) {
    return SliverToBoxAdapter(
      child: ErrorLoadMoreWidget(key: key, page: page, config: config),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: _FailureWidget(config: config, page: page));
  }
}

/// A widget that displays the error message and retry button.
class _FailureWidget extends StatelessWidget {
  const _FailureWidget({required this.config, required this.page});

  /// The configuration for the error widget.
  final ErrorLoadMoreConfig config;

  /// The current page number.
  final int page;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 16),
        Text(
          config.title ?? "Oops! Something went wrong...",
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        config.customButton ??
            ElevatedButton(
              onPressed:
                  config.onRetry == null ? null : () => config.onRetry!(page),
              child: Text(config.btnText ?? "Retry".toUpperCase()),
            ),
        const SizedBox(height: 16),
      ],
    );
  }
}
