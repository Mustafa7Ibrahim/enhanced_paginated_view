library enhanced_paginated_view;

export 'package:enhanced_paginated_view/src/core/enhanced_deduplication.dart';
export 'package:enhanced_paginated_view/src/models/enhanced_delegate.dart';
export 'package:enhanced_paginated_view/src/widgets/error_page_widget.dart';
export 'package:enhanced_paginated_view/src/models/error_page.dart';
export 'package:enhanced_paginated_view/src/models/enhanced_status.dart';

import 'dart:developer';

import 'package:enhanced_paginated_view/src/models/enhanced_delegate.dart';
import 'package:enhanced_paginated_view/src/models/enhanced_status.dart';
import 'package:enhanced_paginated_view/src/models/enhanced_view_type.dart';
import 'package:enhanced_paginated_view/src/views/enhanced_box_view.dart';
import 'package:enhanced_paginated_view/src/views/enhanced_sliver_view.dart';
import 'package:enhanced_paginated_view/src/widgets/loading_widget.dart';
import 'package:enhanced_paginated_view/src/widgets/error_page_widget.dart';
import 'package:flutter/material.dart';

/// this is the EnhancedPaginatedView widget
/// the T is the type of the items that will be loaded
class EnhancedPaginatedView<T> extends StatefulWidget {
  /// this is the load more widget constructor

  // Private constructor
  const EnhancedPaginatedView._({
    required this.onLoadMore,
    required this.isMaxReached,
    required this.itemsPerPage,
    required this.type,
    required this.delegate,
    required this.boxBuilder,
    required this.sliverBuilder,
    super.key,
  });

  // Factory constructor for ListView-based view
  factory EnhancedPaginatedView({
    required void Function(int) onLoadMore,
    required bool isMaxReached,
    int itemsPerPage = 15,
    required EnhancedDelegate<T> delegate,
    required EnhancedBoxBuilder<T> builder,
  }) {
    return EnhancedPaginatedView._(
      type: EnhancedViewType.box,
      onLoadMore: onLoadMore,
      isMaxReached: isMaxReached,
      itemsPerPage: itemsPerPage,
      delegate: delegate,
      boxBuilder: builder,
      sliverBuilder: null,
    );
  }

  // Factory constructor for CustomScrollView-based view
  factory EnhancedPaginatedView.slivers({
    required void Function(int) onLoadMore,
    required bool isMaxReached,
    int itemsPerPage = 15,
    required EnhancedDelegate<T> delegate,
    required EnhancedSliverBuilder<T> builder,
  }) {
    return EnhancedPaginatedView._(
      onLoadMore: onLoadMore,
      type: EnhancedViewType.sliver,
      isMaxReached: isMaxReached,
      itemsPerPage: itemsPerPage,
      delegate: delegate,
      boxBuilder: null,
      sliverBuilder: builder,
    );
  }

  /// [isMaxReached] is a boolean that will be used
  /// to control the loading widget
  /// this boolean will be set to true when the list reaches the end
  final bool isMaxReached;

  /// [itemsPerPage] is an integer that will be used
  /// to control the number of items that will be loaded
  /// per page
  /// this help with requesting the right page number from the server
  /// in case of delete or update operations
  /// the default value is 15
  final int itemsPerPage;

  /// [type] is where you can specify the type of the view
  /// whether it is a [EnhancedViewType.sliver] or a [EnhancedViewType.box]
  ///
  /// [EnhancedViewType.sliver] is used when you want to use a sliver widget
  /// like a [SliverList] or a [SliverGrid]
  ///
  /// [EnhancedViewType.box] is used when you want to use a normal widget
  /// like a [ListView] or a [GridView]
  ///
  /// the default value is [EnhancedViewType.box]
  final EnhancedViewType type;

  /// [onLoadMore] is a function that will be called when
  /// the user reaches the end of the list
  /// this function will be called only if [isMaxReached] is false
  /// this function is required
  final void Function(int) onLoadMore;

  final EnhancedDelegate<T> delegate;

  final EnhancedBoxBuilder<T>? boxBuilder;

  final EnhancedSliverBuilder<T>? sliverBuilder;

  @override
  State<EnhancedPaginatedView<T>> createState() =>
      _EnhancedPaginatedViewState<T>();
}

class _EnhancedPaginatedViewState<T> extends State<EnhancedPaginatedView<T>> {
  final ScrollController scrollController = ScrollController();

  bool isLoading = false;
  late int loadThreshold;

  /// get the current page
  int get page => widget.delegate.listOfData.length ~/ widget.itemsPerPage + 1;

  void loadMore() {
    if (isLoading) return;

    isLoading = true;
    log('loadMore called from EnhancedPaginatedView with page $page');
    widget.onLoadMore(page);
    // Use a delayed Future to reset the loading flag after a short delay
    Future.delayed(const Duration(milliseconds: 250), () => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    loadThreshold = widget.itemsPerPage - 3;
  }

  void checkAndLoadDataIfNeeded() {
    if (widget.isMaxReached ||
        widget.delegate.status == EnhancedStatus.loading ||
        widget.delegate.status == EnhancedStatus.error) {
      return;
    }

    if (widget.delegate.listOfData.length <= loadThreshold) {
      // Load more data when the list gets shorter than the minimum threshold
      if (page < 2) {
        loadMore();
      }
    }
  }

  bool onNotification(ScrollNotification scrollInfo) {
    if (widget.isMaxReached ||
        widget.delegate.status == EnhancedStatus.loading ||
        widget.delegate.status == EnhancedStatus.error) {
      return false;
    }

    if (scrollInfo is ScrollUpdateNotification) {
      // Check if the last 5 items are visible
      final lastVisibleIndex =
          scrollController.position.maxScrollExtent - scrollInfo.metrics.pixels;
      if (lastVisibleIndex <= 100) {
        // The last 5 items are visible
        // You can now take appropriate action
        loadMore();
      }
    }
    return false;
  }

  @override
  void didUpdateWidget(covariant EnhancedPaginatedView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    checkAndLoadDataIfNeeded();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: onNotification,
      child: widget.delegate.status == EnhancedStatus.loading && page == 1
          ? LoadingWidget()
          : widget.delegate.status == EnhancedStatus.error && page == 1
              ? ErrorPageWidget(errorPage: widget.delegate.errorPage)
              : switch (widget.type) {
                  EnhancedViewType.sliver => EnhancedSliverView<T>(
                      delegate: widget.delegate,
                      builder: widget.sliverBuilder!,
                      page: page,
                      scrollController: scrollController,
                    ),
                  EnhancedViewType.box => EnhancedBoxView<T>(
                      delegate: widget.delegate,
                      builder: widget.boxBuilder!,
                      page: page,
                      scrollController: scrollController,
                    ),
                },
    );
  }
}
