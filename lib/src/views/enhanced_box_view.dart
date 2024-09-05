import 'package:enhanced_paginated_view/src/core/enhanced_deduplication.dart';
import 'package:enhanced_paginated_view/src/models/enhanced_view_direction.dart';
import 'package:enhanced_paginated_view/src/models/enhanced_delegate.dart';
import 'package:enhanced_paginated_view/src/widgets/empty_widget.dart';
import 'package:enhanced_paginated_view/src/widgets/loading_error_widget.dart';

import 'package:flutter/material.dart';

class EnhancedBoxView<T> extends StatelessWidget {
  final EnhancedDelegate<T> delegate;
  final EnhancedBoxBuilder<T> builder;
  final EnhancedViewDirection direction;
  final int page;
  final ScrollController scrollController;

  const EnhancedBoxView._({
    super.key,
    required this.delegate,
    required this.direction,
    required this.builder,
    required this.page,
    required this.scrollController,
  });

  factory EnhancedBoxView({
    Key? key,
    required EnhancedDelegate<T> delegate,
    required EnhancedBoxBuilder<T> builder,
    required int page,
    required ScrollController scrollController,
  }) {
    return EnhancedBoxView._(
      page: page,
      key: key,
      delegate: delegate,
      builder: builder,
      scrollController: scrollController,
      direction: EnhancedViewDirection.forward,
    );
  }

  factory EnhancedBoxView.reverse({
    Key? key,
    required EnhancedDelegate<T> delegate,
    required EnhancedBoxBuilder<T> builder,
    required int page,
    required ScrollController scrollController,
  }) {
    return EnhancedBoxView._(
      page: page,
      key: key,
      delegate: delegate,
      builder: builder,
      scrollController: scrollController,
      direction: EnhancedViewDirection.reverse,
    );
  }

  @override
  Widget build(BuildContext context) {
    return switch (direction) {
      EnhancedViewDirection.forward => forwardBuild(context),
      EnhancedViewDirection.reverse => reverseBuild(context),
    };
  }

  // a forward view build
  Widget forwardBuild(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      physics: delegate.physics,
      scrollDirection: delegate.scrollDirection,
      child: Column(
        crossAxisAlignment: delegate.crossAxisAlignment,
        children: [
          if (delegate.header != null) delegate.header!,
          if (delegate.listOfData.isNotEmpty)
            builder(
              delegate.shouldDeduplicate
                  ? delegate.listOfData.removeDuplication()
                  : delegate.listOfData,
              const NeverScrollableScrollPhysics(),
              false,
              true,
            )
          else
            delegate.emptyView ?? EmptyWidget(),
          LoadingErrorWidget(page: page, delegate: delegate),
        ],
      ),
    );
  }

  // a reverse view build
  Widget reverseBuild(BuildContext context) {
    return SingleChildScrollView(
      reverse: true,
      controller: scrollController,
      physics: delegate.physics,
      scrollDirection: delegate.scrollDirection,
      child: Column(
        crossAxisAlignment: delegate.crossAxisAlignment,
        children: [
          LoadingErrorWidget(page: page, delegate: delegate),
          if (delegate.listOfData.isNotEmpty)
            builder(
              delegate.shouldDeduplicate
                  ? delegate.listOfData.removeDuplication()
                  : delegate.listOfData,
              const NeverScrollableScrollPhysics(),
              true,
              true,
            )
          else
            delegate.emptyView ?? EmptyWidget(),
          if (delegate.header != null) delegate.header!,
        ],
      ),
    );
  }
}
