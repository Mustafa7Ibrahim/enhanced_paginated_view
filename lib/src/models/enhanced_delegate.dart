import 'package:enhanced_paginated_view/enhanced_paginated_view.dart';
import 'package:enhanced_paginated_view/src/models/error_load_more.dart';
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
  final bool shouldDeduplicate;
  final Axis scrollDirection;
  final CrossAxisAlignment crossAxisAlignment;

  final List<T> listOfData;
  final EnhancedStatus status;

  final Widget? header;
  final Widget? loadingWidget;
  final Widget Function(int)? errorWidget;
  final Widget? emptyView;
  final ErrorPage errorPage;
  final ErrorLoadMore errorLoadMore;

  EnhancedDelegate({
    required this.listOfData,
    required this.status,
    this.physics,
    this.header,
    this.emptyView,
    this.loadingWidget,
    this.errorWidget,
    this.errorLoadMore = const ErrorLoadMore(),
    this.errorPage = const ErrorPage(),
    this.shouldDeduplicate = true,
    this.scrollDirection = Axis.vertical,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });
}
