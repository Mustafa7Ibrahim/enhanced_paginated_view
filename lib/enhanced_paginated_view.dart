library enhanced_paginated_view;

import 'package:flutter/material.dart';

/// this is the load more widget
/// the T is the type of the items that will be loaded
class EnhancedPaginatedView<T> extends StatefulWidget {
  /// this is the load more widget constructor
  const EnhancedPaginatedView({
    required this.loadingWidget,
    required this.onLoadMore,
    required this.isLoadingState,
    required this.isMaxReached,
    required this.listOfData,
    required this.builder,
    this.header,
    this.emptyWidget,
    required this.errorWidget,
    this.showErrorWidget = false,
    super.key,
  });

  /// the loading widget that will be shown when loading
  /// new items from the server or any other source
  /// this widget will be shown at the bottom of the list
  /// and will be removed when the new items are loaded
  /// and the list is rebuilt
  /// this widget will be shown only if [isLoadingState] is true
  /// and [isMaxReached] is false
  /// this widget is required
  /// this widget is not nullable
  final Widget loadingWidget;

  /// [onLoadMore] is a function that will be called when
  /// the user reaches the end of the list
  /// this function will be called only if [isMaxReached] is false
  /// this function is required
  final void Function(int) onLoadMore;

  /// [isLoadingState] is a [ValueNotifier] that will be used
  /// to control the loading widget
  /// this [ValueNotifier] will be set to true when the user
  /// reaches the end of the list and [onLoadMore] is called
  /// and will be set to false when the new items are loaded
  /// and the list is rebuilt
  /// this [ValueNotifier] is required
  final bool isLoadingState;

  /// [isMaxReached] is a boolean that will be used
  /// to control the loading widget
  /// this boolean will be set to true when the list reaches the end
  final bool isMaxReached;

  /// [listOfData] is a list of items that will be added to the list
  /// this list is required
  final List<T> listOfData;

  /// [header] is a list of widgets that will be shown
  /// at the top of the list
  /// this list is not required
  final Widget? header;

  /// [emptyWidget] is a list of widgets that will be shown
  /// when the list is empty
  /// this list is not required
  final Widget? emptyWidget;

  /// [errorWidget] is a widget that will be shown
  /// when an error occurs during data loading.
  /// This widget is optional and can be null.
  final Widget Function(int page) errorWidget;

  /// [showErrorWidget] is a boolean that will be used
  /// to control the error widget
  /// this boolean will be set to true when an error occurs
  final bool showErrorWidget;

  /// [builder] is a function that will be used to build the widget
  /// wither it is a [ListView] or a [GridView] or any other widget
  /// the *physics* parameter is the physics that will be used
  /// for the widget to control the scrolling behavior of the widget
  /// by default the physics will be [NeverScrollableScrollPhysics]
  /// to prevent the widget from scrolling
  /// this parameter is required
  /// the *items* parameter is the list of items that will be shown
  /// in the widget
  final Widget Function(
    ScrollPhysics physics,
    List<T> items,
    bool shrinkWrap,
  ) builder;

  @override
  State<EnhancedPaginatedView<T>> createState() =>
      _EnhancedPaginatedViewState<T>();
}

class _EnhancedPaginatedViewState<T> extends State<EnhancedPaginatedView<T>> {
  final ScrollController scrollController = ScrollController();
  int page = 1;

  void loadMore() async {
    page++;
    widget.onLoadMore(page);
  }

  void scrollListener() {
    if (widget.isMaxReached) return;
    if (widget.isLoadingState) return;
    if (widget.showErrorWidget) return;
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
      controller: scrollController,
      child: Column(
        children: [
          widget.header ?? const SizedBox(),
          Visibility(
            visible: widget.listOfData.isNotEmpty,
            replacement: widget.emptyWidget ?? const SizedBox(),
            child: widget.builder(
              const NeverScrollableScrollPhysics(),
              widget.listOfData,
              true,
            ),
          ),
          Visibility(
            visible: widget.showErrorWidget,
            child: widget.errorWidget(page),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Visibility(
              visible: widget.isLoadingState,
              child: widget.loadingWidget,
            ),
          ),
        ],
      ),
    );
  }
}
