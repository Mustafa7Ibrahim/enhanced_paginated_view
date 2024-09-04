import 'package:enhanced_paginated_view/src/models/enhanced_view_type.dart';
import 'package:flutter/material.dart';

/// A widget that represents an empty state.
///
/// This widget is typically used when there is no data to display.
/// It renders an empty `SizedBox` widget.
class EmptyWidget extends StatelessWidget {
  const EmptyWidget._(this.enhancedViewType);

  /// Creates an `EmptyWidget` with a box view type.
  factory EmptyWidget() {
    return const EmptyWidget._(EnhancedViewType.box);
  }

  /// Creates an `EmptyWidget` with a sliver view type.
  factory EmptyWidget.sliver() {
    return const EmptyWidget._(EnhancedViewType.sliver);
  }

  final EnhancedViewType enhancedViewType;

  @override
  Widget build(BuildContext context) {
    return switch (enhancedViewType) {
      EnhancedViewType.box => buildBox(context),
      EnhancedViewType.sliver => buildSliver(context),
    };
  }

  // box build function
  Widget buildBox(BuildContext context) {
    return const SizedBox();
  }

  // sliver build function
  Widget buildSliver(BuildContext context) {
    return const SliverToBoxAdapter(
      child: SizedBox(),
    );
  }
}
