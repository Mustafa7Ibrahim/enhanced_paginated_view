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
  /// Creates a `LoadingWidget`. The default view type is [EnhancedViewType.box].
  const LoadingWidget._(this._enhancedViewType);

  /// Creates a `LoadingWidget` with a box view type.
  factory LoadingWidget() {
    return const LoadingWidget._(EnhancedViewType.box);
  }

  /// Creates a `LoadingWidget` with a sliver view type.
  factory LoadingWidget.sliver() {
    return const LoadingWidget._(EnhancedViewType.sliver);
  }

  final EnhancedViewType _enhancedViewType;

  @override
  Widget build(BuildContext context) {
    return switch (_enhancedViewType) {
      EnhancedViewType.box => buildBox(context),
      EnhancedViewType.sliver => buildSliver(context),
    };
  }

  // box build function
  Widget buildBox(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }

  // sliver build function
  Widget buildSliver(BuildContext context) {
    return const SliverFillRemaining(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
    );
  }
}
