import 'package:enhanced_paginated_view/enhanced_paginated_view.dart';
import 'package:enhanced_paginated_view/src/models/enhanced_loading_type.dart';
import 'package:enhanced_paginated_view/src/models/enhanced_view_type.dart';
import 'package:enhanced_paginated_view/src/widgets/error_load_more_widget.dart';
import 'package:enhanced_paginated_view/src/widgets/loading_widget.dart';
import 'package:flutter/material.dart';

/// A widget that displays a loading or error state based on the provided delegate's status.
/// The widget can be used with either a box view type or a sliver view type.
class LoadingErrorWidget<T> extends StatelessWidget {
  const LoadingErrorWidget._({
    required this.page,
    required this.enhancedViewType,
    required this.delegate,
  });

  /// Creates a `LoadingErrorWidget` with a box view type.
  ///
  /// The [page] parameter specifies the current page number.
  /// The [delegate] parameter is the delegate that provides the loading and error status.
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
  ///
  /// The [page] parameter specifies the current page number.
  /// The [delegate] parameter is the delegate that provides the loading and error status.
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

  /// The current page number.
  final int page;

  /// The view type of the widget.
  final EnhancedViewType enhancedViewType;

  /// The delegate that provides the loading and error status.
  final EnhancedDelegate<T> delegate;

  @override
  Widget build(BuildContext context) {
    return switch (enhancedViewType) {
      EnhancedViewType.box => buildBox(context),
      EnhancedViewType.sliver => buildSliver(context),
    };
  }

  /// Builds the widget with a box view type.
  ///
  /// The [context] parameter is the build context.
  Widget buildBox(BuildContext context) {
    return Column(
      children: [
        if (delegate.status == EnhancedStatus.loading)
          LoadingWidget(
            config: delegate.loadingConfig,
            type: EnhancedLoadingType.loadMore,
          ),
        if (delegate.status == EnhancedStatus.error)
          ErrorLoadMoreWidget(
            config: delegate.errorLoadMoreConfig,
            page: page,
          ),
      ],
    );
  }

  /// Builds the widget with a sliver view type.
  ///
  /// The [context] parameter is the build context.
  Widget buildSliver(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          if (delegate.status == EnhancedStatus.loading)
            LoadingWidget(
              config: delegate.loadingConfig,
              type: EnhancedLoadingType.loadMore,
            ),
          if (delegate.status == EnhancedStatus.error)
            ErrorLoadMoreWidget.sliver(
              config: delegate.errorLoadMoreConfig,
              page: page,
            ),
        ],
      ),
    );
  }
}
