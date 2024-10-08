import 'package:enhanced_paginated_view/src/models/empty_widget_config.dart';
import 'package:enhanced_paginated_view/src/models/enhanced_view_type.dart';
import 'package:flutter/material.dart';

/// A widget that represents an empty state.
///
/// This widget is typically used when there is no data to display.
/// It renders an empty `SizedBox` widget.
class EmptyWidget extends StatelessWidget {
  /// The type of enhanced view.
  final EnhancedViewType enhancedViewType;

  /// the config for the empty widget
  final EmptyWidgetConfig config;

  /// Creates an `EmptyWidget` with the specified [enhancedViewType].
  const EmptyWidget._(this.enhancedViewType, this.config);

  /// Creates an `EmptyWidget` with a box view type.
  factory EmptyWidget({required EmptyWidgetConfig config}) {
    return EmptyWidget._(EnhancedViewType.box, config);
  }

  /// Creates an `EmptyWidget` with a sliver view type.
  factory EmptyWidget.sliver({required EmptyWidgetConfig config}) {
    return EmptyWidget._(EnhancedViewType.sliver, config);
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent(context);
  }

  /// Builds the content based on the [enhancedViewType].
  Widget _buildContent(BuildContext context) {
    switch (enhancedViewType) {
      case EnhancedViewType.box:
        return _buildBox(context);
      case EnhancedViewType.sliver:
        return _buildSliver(context);
    }
  }

  /// Builds the content with a box view type.
  Widget _buildBox(BuildContext context) {
    return config.customView ?? _EmptyWidget(config);
  }

  /// Builds the content with a sliver view type.
  Widget _buildSliver(BuildContext context) {
    return config.customView ?? SliverToBoxAdapter(child: _EmptyWidget(config));
  }
}

class _EmptyWidget extends StatelessWidget {
  const _EmptyWidget(this.config);

  final EmptyWidgetConfig config;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Center(
        child: Text(
          config.title,
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
