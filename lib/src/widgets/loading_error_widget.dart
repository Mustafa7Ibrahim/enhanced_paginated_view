import 'package:enhanced_paginated_view/enhanced_paginated_view.dart';
import 'package:enhanced_paginated_view/src/models/enhanced_view_type.dart';
import 'package:enhanced_paginated_view/src/widgets/error_load_more_widget.dart';
import 'package:enhanced_paginated_view/src/widgets/loading_widget.dart';
import 'package:flutter/material.dart';

class LoadingErrorWidget<T> extends StatelessWidget {
  const LoadingErrorWidget._({
    required this.page,
    required this.enhancedViewType,
    required this.delegate,
  });

  /// Creates a `LoadingErrorWidget` with a box view type.
  factory LoadingErrorWidget({
    required int page,
    required EnhancedDelegate<T> delegate,
  }) {
    return LoadingErrorWidget._(
      page: page,
      delegate: delegate,
      enhancedViewType: EnhancedViewType.box,
    );
  }

  /// Creates a `LoadingErrorWidget` with a sliver view type.
  factory LoadingErrorWidget.sliver({
    required int page,
    required EnhancedDelegate<T> delegate,
  }) {
    return LoadingErrorWidget._(
      page: page,
      delegate: delegate,
      enhancedViewType: EnhancedViewType.sliver,
    );
  }

  final int page;
  final EnhancedViewType enhancedViewType;
  final EnhancedDelegate<T> delegate;

  @override
  Widget build(BuildContext context) {
    return switch (enhancedViewType) {
      EnhancedViewType.box => buildBox(context),
      EnhancedViewType.sliver => buildSliver(context),
    };
  }

  // build the box view
  Widget buildBox(BuildContext context) {
    return Column(
      children: [
        if (delegate.status == EnhancedStatus.loading)
          delegate.loadingWidget ?? LoadingWidget(),
        if (delegate.status == EnhancedStatus.error)
          if (delegate.errorWidget != null)
            delegate.errorWidget!(page)
          else
            ErrorLoadMoreWidget(errorLoadMore: delegate.errorLoadMore),
      ],
    );
  }

  // build the sliver view
  Widget buildSliver(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          if (delegate.status == EnhancedStatus.loading)
            delegate.loadingWidget ?? LoadingWidget(),
          if (delegate.status == EnhancedStatus.error)
            if (delegate.errorWidget != null)
              delegate.errorWidget!(page)
            else
              ErrorLoadMoreWidget.sliver(errorLoadMore: delegate.errorLoadMore),
        ],
      ),
    );
  }
}
