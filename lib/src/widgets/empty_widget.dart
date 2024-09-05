import 'package:enhanced_paginated_view/src/models/enhanced_view_type.dart';
import 'package:flutter/material.dart';

/// A widget that represents an empty state.
///
/// This widget is typically used when there is no data to display.
/// It renders an empty `SizedBox` widget.
class EmptyWidget extends StatelessWidget {
  /// The type of enhanced view.
  final EnhancedViewType enhancedViewType;

  /// Creates an `EmptyWidget` with the specified [enhancedViewType].
  const EmptyWidget._(this.enhancedViewType);

  /// Creates an `EmptyWidget` with a box view type.
  factory EmptyWidget() {
    return const EmptyWidget._(EnhancedViewType.box);
  }

  /// Creates an `EmptyWidget` with a sliver view type.
  factory EmptyWidget.sliver() {
    return const EmptyWidget._(EnhancedViewType.sliver);
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
    return const SizedBox();
  }

  /// Builds the content with a sliver view type.
  Widget _buildSliver(BuildContext context) {
    return const SliverToBoxAdapter(
      child: SizedBox(),
    );
  }
}
