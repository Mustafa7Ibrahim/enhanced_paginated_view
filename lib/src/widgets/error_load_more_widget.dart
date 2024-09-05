import 'package:enhanced_paginated_view/src/models/enhanced_view_type.dart';
import 'package:enhanced_paginated_view/src/models/error_load_more_config.dart';
import 'package:flutter/material.dart';
/// A widget that displays an error message and a retry button when loading more data fails.
///
/// This widget can be used with both box and sliver view types.
class ErrorLoadMoreWidget extends StatelessWidget {
  const ErrorLoadMoreWidget._({
    required this.config,
    required this.type,
    required this.page,
  });

  /// Creates a `ErrorLoadMoreWidget` with a box view type.
  ///
  /// The [page] parameter specifies the current page number.
  /// The [config] parameter specifies the configuration for the error widget.
  factory ErrorLoadMoreWidget({
    required int page,
    ErrorLoadMoreConfig? config,
  }) {
    return ErrorLoadMoreWidget._(
      config: config ?? const ErrorLoadMoreConfig(),
      page: page,
      type: EnhancedViewType.box,
    );
  }

  /// Creates a `ErrorLoadMoreWidget` with a sliver view type.
  ///
  /// The [page] parameter specifies the current page number.
  /// The [config] parameter specifies the configuration for the error widget.
  factory ErrorLoadMoreWidget.sliver({
    required int page,
    ErrorLoadMoreConfig? config,
  }) {
    return ErrorLoadMoreWidget._(
      page: page,
      config: config ?? const ErrorLoadMoreConfig(),
      type: EnhancedViewType.sliver,
    );
  }

  /// The configuration for the error widget.
  final ErrorLoadMoreConfig config;

  /// The view type of the widget.
  final EnhancedViewType type;

  /// The current page number.
  final int page;

  @override
  Widget build(BuildContext context) {
    return switch (type) {
      EnhancedViewType.box => buildBox(context),
      EnhancedViewType.sliver => buildSliver(context),
    };
  }

  /// Builds the error widget with a box view type.
  ///
  /// The [context] parameter specifies the build context.
  Widget buildBox(BuildContext context) {
    return SafeArea(child: _FailureWidget(config: config, page: page));
  }

  /// Builds the error widget with a sliver view type.
  ///
  /// The [context] parameter specifies the build context.
  Widget buildSliver(BuildContext context) {
    return SliverToBoxAdapter(
      child: _FailureWidget(config: config, page: page),
    );
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
