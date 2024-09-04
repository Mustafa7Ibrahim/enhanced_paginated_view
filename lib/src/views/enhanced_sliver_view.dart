import 'package:enhanced_paginated_view/src/core/enhanced_deduplication.dart';
import 'package:enhanced_paginated_view/src/models/enhanced_delegate.dart';
import 'package:enhanced_paginated_view/src/models/enhanced_view_direction.dart';
import 'package:enhanced_paginated_view/src/widgets/empty_widget.dart';
import 'package:enhanced_paginated_view/src/widgets/loading_error_widget.dart';
import 'package:flutter/material.dart';

class EnhancedSliverView<T> extends StatelessWidget {
  const EnhancedSliverView._({
    super.key,
    required this.delegate,
    required this.direction,
    required this.builder,
    required this.page,
    required this.scrollController,
  });

  factory EnhancedSliverView({
    Key? key,
    required EnhancedDelegate<T> delegate,
    required EnhancedSliverBuilder<T> builder,
    required int page,
    required ScrollController scrollController,
  }) {
    return EnhancedSliverView._(
      key: key,
      delegate: delegate,
      builder: builder,
      page: page,
      scrollController: scrollController,
      direction: EnhancedViewDirection.forward,
    );
  }

  factory EnhancedSliverView.reverse({
    Key? key,
    required EnhancedDelegate<T> delegate,
    required EnhancedSliverBuilder<T> builder,
    required int page,
    required ScrollController scrollController,
  }) {
    return EnhancedSliverView._(
      key: key,
      delegate: delegate,
      builder: builder,
      page: page,
      scrollController: scrollController,
      direction: EnhancedViewDirection.reverse,
    );
  }

  final EnhancedDelegate<T> delegate;
  final EnhancedViewDirection direction;
  final EnhancedSliverBuilder<T> builder;
  final int page;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return switch (direction) {
      EnhancedViewDirection.forward => forwardBuild(context),
      EnhancedViewDirection.reverse => reverseBuild(context),
    };
  }

  /// forward build
  Widget forwardBuild(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      physics: delegate.physics,
      scrollDirection: delegate.scrollDirection,
      slivers: [
        if (delegate.header != null) delegate.header!,
        if (delegate.listOfData.isNotEmpty)
          builder(
            context,
            delegate.shouldDeduplicate
                ? delegate.listOfData.removeDuplication()
                : delegate.listOfData,
          )
        else
          delegate.emptyView ?? EmptyWidget.sliver(),
        LoadingErrorWidget.sliver(
          page: page,
          showError: delegate.showError,
          showLoading: delegate.showLoading,
          errorWidget: delegate.errorWidget,
          loadingWidget: delegate.loadingWidget,
        ),
      ],
    );
  }

  /// reverse build
  Widget reverseBuild(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      physics: delegate.physics,
      scrollDirection: delegate.scrollDirection,
      slivers: [
        LoadingErrorWidget.sliver(
          page: page,
          showError: delegate.showError,
          showLoading: delegate.showLoading,
          errorWidget: delegate.errorWidget,
          loadingWidget: delegate.loadingWidget,
        ),
        if (delegate.listOfData.isNotEmpty)
          builder(
            context,
            delegate.shouldDeduplicate
                ? delegate.listOfData.removeDuplication()
                : delegate.listOfData,
          )
        else
          delegate.emptyView ?? EmptyWidget.sliver(),
        if (delegate.header != null) delegate.header!,
      ],
    );
  }
}
