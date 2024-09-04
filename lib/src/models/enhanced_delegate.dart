import 'package:flutter/material.dart';

typedef EnhancedBoxBuilder<T> = Widget Function(
  List<T> data,
  ScrollPhysics physics,
  bool reverse,
  bool shrinkWrap,
);
typedef EnhancedSliverBuilder<T> = Widget Function(
  BuildContext context,
  List<T> data,
);

class EnhancedDelegate<T> {
  final ScrollPhysics? physics;
  final Widget? header;
  final bool shouldDeduplicate;
  final Widget? emptyView;
  final Widget? loadingWidget;
  final Widget Function(int)? errorWidget;
  final bool showError;
  final bool showLoading;
  final Axis scrollDirection;
  final CrossAxisAlignment crossAxisAlignment;
  final List<T> listOfData;

  EnhancedDelegate({
    required this.listOfData,
    required this.showError,
    required this.showLoading,
    this.physics,
    this.header,
    this.emptyView,
    this.loadingWidget,
    this.errorWidget,
    this.shouldDeduplicate = true,
    this.scrollDirection = Axis.vertical,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });
}
