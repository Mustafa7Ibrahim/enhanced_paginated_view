import 'package:enhanced_paginated_view/src/models/enhanced_view_type.dart';
import 'package:enhanced_paginated_view/src/models/loading_failure_model.dart';
import 'package:flutter/material.dart';

class LoadingFailureWidget extends StatelessWidget {
  const LoadingFailureWidget._({
    required this.model,
    required this.type,
  });

  /// Creates a `LoadingFailureWidget` with a box view type.
  factory LoadingFailureWidget({LoadingFailureModel? model}) {
    return LoadingFailureWidget._(
      model: model ?? LoadingFailureModel(),
      type: EnhancedViewType.box,
    );
  }

  /// Creates a `LoadingFailureWidget` with a sliver view type.
  factory LoadingFailureWidget.sliver({LoadingFailureModel? model}) {
    return LoadingFailureWidget._(
      model: model ?? LoadingFailureModel(),
      type: EnhancedViewType.sliver,
    );
  }

  final LoadingFailureModel model;
  final EnhancedViewType type;

  @override
  Widget build(BuildContext context) {
    return switch (type) {
      EnhancedViewType.box => buildBox(context),
      EnhancedViewType.sliver => buildSliver(context),
    };
  }

  Widget buildBox(BuildContext context) {
    return SafeArea(child: _FailureWidget(model: model));
  }

  Widget buildSliver(BuildContext context) {
    return SliverToBoxAdapter(child: _FailureWidget(model: model));
  }
}

class _FailureWidget extends StatelessWidget {
  const _FailureWidget({required this.model});

  final LoadingFailureModel model;

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
