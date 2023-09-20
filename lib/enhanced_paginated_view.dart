/// this is the enhanced_paginated_view library
library enhanced_paginated_view;

export 'package:enhanced_paginated_view/src/enhanced_deduplication.dart';

import 'dart:developer';
import 'package:enhanced_paginated_view/src/enhanced_deduplication.dart';
import 'package:enhanced_paginated_view/src/widgets/empty_widget.dart';
import 'package:enhanced_paginated_view/src/widgets/error_widget.dart';
import 'package:enhanced_paginated_view/src/widgets/loading_widget.dart';
import 'package:flutter/material.dart';

/// this is the EnhancedPaginatedView widget
/// the T is the type of the items that will be loaded
class EnhancedPaginatedView<T> extends StatefulWidget {
  /// this is the load more widget constructor
  const EnhancedPaginatedView({
    required this.listOfData,
    required this.onLoadMore,
    required this.builder,
    required this.showError,
    required this.showLoading,
    required this.isMaxReached,
    this.shouldDeduplicate = true,
    this.reverse = false,
    this.itemsPerPage = 15,
    this.loadingWidget,
    this.errorWidget,
    this.physics,
    this.header,
    this.emptyView,
    super.key,
  });

  /// [deduplication] is a boolean that will be used
  /// to control wither the list will be deduplicated or not
  /// the default value is true
  /// if you want to disable the deduplication, then set this value to false
  final bool shouldDeduplicate;

  /// [physics] is a [ScrollPhysics] that will be used
  /// to control the scrolling behavior of the widget
  ///
  /// the default value is [null]
  final ScrollPhysics? physics;

  /// [isMaxReached] is a boolean that will be used
  /// to control the loading widget
  /// this boolean will be set to true when the list reaches the end
  final bool isMaxReached;

  /// [showLoading] is a [ValueNotifier] that will be used
  /// to control the loading widget
  /// this [ValueNotifier] will be set to true when the user
  /// reaches the end of the list and [onLoadMore] is called
  /// and will be set to false when the new items are loaded
  /// and the list is rebuilt
  /// this [ValueNotifier] is required
  final bool showLoading;

  /// the loading widget that will be shown when loading
  /// new items from the server or any other source
  /// this widget will be shown at the bottom of the list
  /// and will be removed when the new items are loaded
  /// and the list is rebuilt
  /// this widget will be shown only if [showLoading] is true
  /// and [isMaxReached] is false
  /// this widget is required
  /// this widget is not nullable
  final Widget? loadingWidget;

  /// [showError] is a boolean that will be used
  /// to control the error widget
  /// this boolean will be set to true when an error occurs
  final bool showError;

  /// [itemsPerPage] is an integer that will be used
  /// to control the number of items that will be loaded
  /// per page
  /// this help with requesting the right page number from the server
  /// in case of delete or update operations
  /// the default value is 15
  final int itemsPerPage;

  /// [errorWidget] is a widget that will be shown
  /// when an error occurs during data loading.
  /// This widget is optional and can be null.
  final Widget Function(int page)? errorWidget;

  /// [onLoadMore] is a function that will be called when
  /// the user reaches the end of the list
  /// this function will be called only if [isMaxReached] is false
  /// this function is required
  final void Function(int) onLoadMore;

  /// [listOfData] is a list of items that will be added to the list
  /// this list is required
  final List<T> listOfData;

  /// [header] is a list of widgets that will be shown
  /// at the top of the list
  /// this list is not required
  final Widget? header;

  /// [emptyView] is a widgets that will be shown
  /// when the list is empty
  /// this list is not required
  final Widget? emptyView;

  /// [reverse] is a boolean that will be used
  /// to reverse the list and its children
  final bool reverse;

  /// [builder] is a function that will be used to build the widget
  /// wither it is a [ListView] or a [GridView] or any other widget
  ///
  /// the `physics` parameter is the physics that will be used
  /// for the widget to control the scrolling behavior of the widget
  /// by default the physics will be [NeverScrollableScrollPhysics]
  /// to prevent the widget from scrolling
  /// this parameter is required
  ///
  /// the `items` parameter is the list of items that will be shown
  /// in the widget
  /// this parameter is required
  ///
  /// the `shrinkWrap` parameter is a boolean that will be used
  /// to control the shrinkWrap property of the widget
  /// by default the shrinkWrap will be true
  /// this parameter is required
  ///
  /// the `reverse` parameter is a boolean that will be used
  /// to reverse the list and its children
  /// it code be handy when you are building a chat app for example
  /// and you want to reverse the list to show the latest messages
  /// at the bottom of the list
  /// this parameter is required
  final Widget Function(
    ScrollPhysics physics,
    List<T> items,
    bool shrinkWrap,
    bool reverse,
  ) builder;

  @override
  State<EnhancedPaginatedView<T>> createState() =>
      _EnhancedPaginatedViewState<T>();
}

class _EnhancedPaginatedViewState<T> extends State<EnhancedPaginatedView<T>> {
  final ScrollController scrollController = ScrollController();

  bool isLoading = false;
  late int loadThreshold;

  /// get the current page
  int get page => widget.listOfData.length ~/ widget.itemsPerPage + 1;

  void loadMore() {
    if (isLoading) return;

    isLoading = true;
    log('loadMore called from EnhancedPaginatedView with page $page');
    widget.onLoadMore(page);
    // Use a delayed Future to reset the loading flag after a short delay
    Future.delayed(const Duration(milliseconds: 500), () => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    loadThreshold = widget.itemsPerPage - 3;
  }

  void checkAndLoadDataIfNeeded() {
    if (widget.isMaxReached || widget.showLoading || widget.showError) {
      return;
    }

    if (widget.listOfData.length <= loadThreshold) {
      // Load more data when the list gets shorter than the minimum threshold
      if (page < 2) {
        loadMore();
      }
    }
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
      onNotification: (ScrollNotification scrollInfo) {
        if (widget.isMaxReached || widget.showLoading || widget.showError) {
          return false;
        }

        if (scrollInfo is ScrollUpdateNotification) {
          // Check if the last 5 items are visible
          final lastVisibleIndex = scrollController.position.maxScrollExtent -
              scrollInfo.metrics.pixels;
          if (lastVisibleIndex <= 100) {
            // The last 5 items are visible
            // You can now take appropriate action
            loadMore();
          }
        }
        return false;
      },
      child: SingleChildScrollView(
        reverse: widget.reverse,
        controller: scrollController,
        physics: widget.physics,
        child: Column(
          children: [
            // if reverse is true then show the loading widget
            // before the list
            if (widget.reverse)
              Column(
                children: [
                  if (widget.showLoading)
                    widget.loadingWidget ?? const LoadingWidget()
                  else if (widget.showError)
                    widget.errorWidget != null
                        ? widget.errorWidget!(page)
                        : const SomethingWentWrong(),
                ],
              ),

            // if reverse is true, then show the header before the list
            if (!widget.reverse)
              if (widget.header != null) widget.header ?? const SizedBox(),

            // if the list is not empty, then show the list
            // otherwise show the empty view
            if (widget.listOfData.isNotEmpty)
              widget.builder(
                const NeverScrollableScrollPhysics(),
                widget.shouldDeduplicate
                    ? widget.listOfData.removeDuplication()
                    : widget.listOfData,
                true,
                widget.reverse,
              )
            else
              widget.emptyView ?? const EmptyWidget(),

            // if reverse is true, then show the header after the list
            if (widget.reverse)
              if (widget.header != null) widget.header ?? const SizedBox(),
            if (!widget.reverse)
              Column(
                children: [
                  if (widget.showLoading)
                    widget.loadingWidget ?? const LoadingWidget()
                  else if (widget.showError)
                    widget.errorWidget != null
                        ? widget.errorWidget!(page)
                        : const SomethingWentWrong(),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
