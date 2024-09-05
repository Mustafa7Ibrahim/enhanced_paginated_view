import 'package:enhanced_paginated_view/src/models/enhanced_view_type.dart';
import 'package:enhanced_paginated_view/src/models/error_load_more.dart';
import 'package:flutter/material.dart';

class ErrorLoadMoreWidget extends StatelessWidget {
  const ErrorLoadMoreWidget._({
    required this.errorLoadMore,
    required this.type,
  });

  /// Creates a `LoadingFailureWidget` with a box view type.
  factory ErrorLoadMoreWidget({ErrorLoadMore? errorLoadMore}) {
    return ErrorLoadMoreWidget._(
      errorLoadMore: errorLoadMore ?? const ErrorLoadMore(),
      type: EnhancedViewType.box,
    );
  }

  /// Creates a `LoadingFailureWidget` with a sliver view type.
  factory ErrorLoadMoreWidget.sliver({ErrorLoadMore? errorLoadMore}) {
    return ErrorLoadMoreWidget._(
      errorLoadMore: errorLoadMore ?? const ErrorLoadMore(),
      type: EnhancedViewType.sliver,
    );
  }

  final ErrorLoadMore errorLoadMore;
  final EnhancedViewType type;

  @override
  Widget build(BuildContext context) {
    return switch (type) {
      EnhancedViewType.box => buildBox(context),
      EnhancedViewType.sliver => buildSliver(context),
    };
  }

  Widget buildBox(BuildContext context) {
    return SafeArea(child: _FailureWidget(model: errorLoadMore));
  }

  Widget buildSliver(BuildContext context) {
    return SliverToBoxAdapter(child: _FailureWidget(model: errorLoadMore));
  }
}

class _FailureWidget extends StatelessWidget {
  const _FailureWidget({required this.model});

  final ErrorLoadMore model;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 16),
        Text(
          model.title ?? "Oops! Something went wrong...",
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        model.retryButton ??
            ElevatedButton(
              onPressed: model.onRetry,
              child: Text(model.btnText ?? "Retry".toUpperCase()),
            ),
        const SizedBox(height: 16),
      ],
    );
  }
}
