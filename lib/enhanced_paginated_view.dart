/// this is the enhanced_paginated_view library
library enhanced_paginated_view;

import 'package:flutter/material.dart';

/// this is the EnhancedPaginatedView widget
/// the T is the type of the items that will be loaded
class EnhancedPaginatedView<T> extends StatefulWidget {
  /// this is the load more widget constructor
  const EnhancedPaginatedView({
    required this.listOfData,
    required this.loadingWidget,
    required this.errorWidget,
    required this.onLoadMore,
    required this.builder,
    this.showLoading = false,
    this.isMaxReached = false,
    this.reverse = false,
    this.showError = false,
    this.header,
    this.emptyView,
    super.key,
  });

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
  final Widget loadingWidget;

  /// [showError] is a boolean that will be used
  /// to control the error widget
  /// this boolean will be set to true when an error occurs
  final bool showError;

  /// [errorWidget] is a widget that will be shown
  /// when an error occurs during data loading.
  /// This widget is optional and can be null.
  final Widget Function(int page) errorWidget;

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
  int page = 1;

  void loadMore() {
    page++;
    widget.onLoadMore(page);
  }

  void scrollListener() {
    if (widget.isMaxReached) return;
    if (widget.showLoading) return;
    if (widget.showError) return;
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      loadMore();
    }
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      reverse: widget.reverse,
      controller: scrollController,
      child: Column(
        children: [
          Visibility(
            visible: widget.reverse,
            child: Column(
              children: [
                Visibility(
                  visible: widget.showError,
                  child: widget.errorWidget(page),
                ),
                Visibility(
                  visible: widget.showLoading,
                  child: widget.loadingWidget,
                ),
              ],
            ),
          ),
          Visibility(
            visible: !widget.reverse,
            child: Visibility(
              visible: widget.header != null,
              child: widget.header ?? const SizedBox(),
            ),
          ),
          Visibility(
            visible: widget.listOfData.isNotEmpty,
            replacement: widget.emptyView ?? const SizedBox(),
            child: widget.builder(
              const NeverScrollableScrollPhysics(),
              widget.listOfData,
              true,
              widget.reverse,
            ),
          ),
          Visibility(
            visible: widget.reverse,
            child: Visibility(
              visible: widget.header != null,
              child: widget.header ?? const SizedBox(),
            ),
          ),
          Visibility(
            visible: !widget.reverse,
            child: Column(
              children: [
                Visibility(
                  visible: widget.showError,
                  child: widget.errorWidget(page),
                ),
                Visibility(
                  visible: widget.showLoading,
                  child: widget.loadingWidget,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
