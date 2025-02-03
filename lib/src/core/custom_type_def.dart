import 'package:flutter/material.dart';

/// Defines a typedef for a function that builds a widget with enhanced box properties.
///
/// The [EnhancedBoxBuilder] function takes in the following parameters:
/// - [data]: A list of type [T] representing the data to be displayed.
/// - [physics]: The scroll physics to be applied to the widget.
/// - [reverse]: A boolean value indicating whether the widget should be displayed in reverse order.
/// - [shrinkWrap]: A boolean value indicating whether the widget should shrink-wrap its contents.
///
/// The [EnhancedBoxBuilder] function returns a [Widget] that represents the built widget.
typedef EnhancedBoxBuilder<T> = Widget Function(
  List<T> data,
  ScrollPhysics physics,
  bool reverse,
  bool shrinkWrap,
);

/// Defines a typedef for a function that builds a sliver widget with enhanced properties.
///
/// The [EnhancedSliverBuilder] function takes in the following parameters:
/// - [context]: The build context for the widget.
/// - [data]: A list of type [T] representing the data to be displayed.
///
/// The [EnhancedSliverBuilder] function returns a [Widget] that represents the built sliver widget.
typedef EnhancedSliverBuilder<T> = Widget Function(
  BuildContext context,
  List<T> data,
);

typedef EnhancedRefreshBuilder<T> = Widget Function(
  BuildContext context,
  Future<void> Function() onRefresh,
  Widget child,
);
