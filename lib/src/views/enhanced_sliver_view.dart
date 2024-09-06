import 'package:enhanced_paginated_view/src/core/custom_type_def.dart';
import 'package:enhanced_paginated_view/src/core/enhanced_deduplication.dart';
import 'package:enhanced_paginated_view/src/models/enhanced_delegate.dart';
import 'package:enhanced_paginated_view/src/models/enhanced_view_direction.dart';
import 'package:enhanced_paginated_view/src/widgets/empty_widget.dart';
import 'package:enhanced_paginated_view/src/widgets/loading_error_widget.dart';
import 'package:flutter/material.dart';

/// A widget that represents an enhanced sliver view.
///
/// This widget is used to display a list of data in a sliver format, with enhanced features such as pagination and error handling.
class EnhancedSliverView<T> extends StatelessWidget {
  /// Creates an instance of [EnhancedSliverView].
  ///
  /// The [delegate] parameter is required and represents the delegate that provides the necessary data and configuration for the view.
  /// The [builder] parameter is required and represents the builder function that generates the sliver widgets based on the provided data.
  /// The [page] parameter is required and represents the current page number.
  /// The [scrollController] parameter is required and represents the scroll controller for the view.
  const EnhancedSliverView({
    super.key,
    required this.delegate,
    required this.direction,
    required this.builder,
    required this.page,
    required this.scrollController,
  });

  /// The delegate that provides the necessary data and configuration for the view.
  final EnhancedDelegate<T> delegate;

  /// The direction of the sliver view.
  final EnhancedViewDirection direction;

  /// The builder function that generates the sliver widgets based on the provided data.
  final EnhancedSliverBuilder<T> builder;

  /// The current page number.
  final int page;

  /// The scroll controller for the view.
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
            delegate.removeDuplicatedItems
                ? delegate.listOfData.removeDuplication()
                : delegate.listOfData,
          )
        else
          delegate.emptyWidgetConfig.customView ??
              EmptyWidget.sliver(config: delegate.emptyWidgetConfig),
        LoadingErrorWidget.sliver(page: page, delegate: delegate),
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
        LoadingErrorWidget.sliver(page: page, delegate: delegate),
        if (delegate.listOfData.isNotEmpty)
          builder(
            context,
            delegate.removeDuplicatedItems
                ? delegate.listOfData.removeDuplication()
                : delegate.listOfData,
          )
        else
          delegate.emptyWidgetConfig.customView ??
              EmptyWidget.sliver(config: delegate.emptyWidgetConfig),
        if (delegate.header != null) delegate.header!,
      ],
    );
  }
}
