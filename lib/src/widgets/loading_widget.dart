import 'package:enhanced_paginated_view/src/models/enhanced_loading_delegate.dart';
import 'package:enhanced_paginated_view/src/models/enhanced_loading_type.dart';
import 'package:enhanced_paginated_view/src/models/enhanced_view_type.dart';
import 'package:flutter/material.dart';

/// A widget that displays a loading indicator in the center of the screen.
///
/// This widget is typically used to indicate that data is being loaded or processed.
/// It displays a circular progress indicator with adaptive size.
///
/// Example usage:
///
/// ```dart
/// LoadingWidget(),
/// ```
class LoadingWidget extends StatelessWidget {
  /// Creates a `LoadingWidget` with the specified [config] and [type].
  ///
  /// The default view type is [EnhancedViewType.box].
  factory LoadingWidget({
    required LoadingConfig config,
    required EnhancedLoadingType type,
  }) {
    return LoadingWidget._(
      enhancedViewType: EnhancedViewType.box,
      config: config,
      type: type,
    );
  }

  /// Creates a `LoadingWidget` with a sliver view type.
  factory LoadingWidget.sliver({
    required LoadingConfig config,
    required EnhancedLoadingType type,
  }) {
    return LoadingWidget._(
      enhancedViewType: EnhancedViewType.sliver,
      config: config,
      type: type,
    );
  }

  /// The view type of the loading widget.
  final EnhancedViewType enhancedViewType;

  /// The loading configuration.
  final LoadingConfig config;

  /// The loading type.
  final EnhancedLoadingType type;

  const LoadingWidget._({
    required this.enhancedViewType,
    required this.config,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return switch (enhancedViewType) {
      EnhancedViewType.box => buildBox(context),
      EnhancedViewType.sliver => buildSliver(context),
    };
  }

  /// Builds the loading widget with a box view type.
  Widget buildBox(BuildContext context) {
    if (type == EnhancedLoadingType.loadMore) {
      return config.loadMoreWidget ?? const _Loading();
    }
    return config.pageWidget ?? const _Loading();
  }

  /// Builds the loading widget with a sliver view type.
  Widget buildSliver(BuildContext context) {
    if (type == EnhancedLoadingType.loadMore) {
      return config.loadMoreWidget ??
          const SliverFillRemaining(child: _Loading());
    }
    return config.pageWidget ?? const SliverFillRemaining(child: _Loading());
  }
}

/// A private widget that displays the loading indicator.
class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
