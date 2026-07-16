import 'package:enhanced_paginated_view/src/models/enhanced_loading_type.dart';
import 'package:enhanced_paginated_view/src/models/loading_config.dart';
import 'package:flutter/material.dart';

/// A widget that displays a loading indicator in the center of the screen.
///
/// This widget is typically used to indicate that data is being loaded or processed.
/// It displays a circular progress indicator with adaptive size.
///
/// Example usage:
///
/// ```dart
/// LoadingWidget(config: LoadingConfig(), type: EnhancedLoadingType.page),
/// ```
class LoadingWidget extends StatelessWidget {
  /// Creates a `LoadingWidget` for a box-based view with the specified
  /// [config] and [type].
  const LoadingWidget({super.key, required this.config, required this.type});

  /// The loading configuration.
  final LoadingConfig config;

  /// The loading type.
  final EnhancedLoadingType type;

  /// Creates a `LoadingWidget` for a sliver-based view.
  static Widget sliver({
    Key? key,
    required LoadingConfig config,
    required EnhancedLoadingType type,
  }) {
    return SliverToBoxAdapter(
      child: LoadingWidget(key: key, config: config, type: type),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (type == EnhancedLoadingType.loadMore) {
      return config.loadMoreWidget ?? const _Loading();
    }
    return config.pageWidget ?? const _Loading();
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
