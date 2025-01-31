import 'package:enhanced_paginated_view/src/core/custom_type_def.dart';
import 'package:enhanced_paginated_view/src/core/enhanced_deduplication.dart';
import 'package:enhanced_paginated_view/src/models/enhanced_view_direction.dart';
import 'package:enhanced_paginated_view/src/models/enhanced_delegate.dart';
import 'package:enhanced_paginated_view/src/widgets/empty_widget.dart';
import 'package:enhanced_paginated_view/src/widgets/loading_error_widget.dart';

import 'package:flutter/material.dart';

/// A widget that displays a paginated view in a box layout.
///
/// The [EnhancedBoxView] widget is used to display a paginated view in a box layout.
/// It takes a [delegate] that provides the necessary data and configuration for the view,
/// a [builder] function that builds the individual items in the view,
/// a [direction] that determines the scrolling direction of the view,
/// a [page] number that represents the current page of the view,
/// and a [scrollController] that controls the scrolling behavior of the view.
///
/// The [EnhancedBoxView] widget provides two factory constructors:
/// - [EnhancedBoxView] creates a forward scrolling view.
///
/// The [EnhancedBoxView] widget overrides the [build] method to build the view based on the [direction].
/// It internally calls either the [forwardBuild] or [reverseBuild] method to build the view accordingly.
///
/// The [forwardBuild] method builds the view with a forward scrolling direction.
/// It uses a [SingleChildScrollView] with a [Column] as its child.
/// The [delegate] provides the necessary configuration for the view,
/// and the [builder] function is used to build the individual items in the view.
///
/// The [reverseBuild] method builds the view with a reverse scrolling direction.
/// It uses a [SingleChildScrollView] with a [Column] as its child.
/// The [delegate] provides the necessary configuration for the view,
/// and the [builder] function is used to build the individual items in the view.
class EnhancedBoxView<T> extends StatelessWidget {
  /// The delegate that provides the necessary data and configuration for the view.
  final EnhancedDelegate<T> delegate;

  /// The function that builds the individual items in the view.
  final EnhancedBoxBuilder<T> builder;

  /// The scrolling direction of the view.
  final EnhancedViewDirection direction;

  /// The current page of the view.
  final int page;

  /// The scroll controller that controls the scrolling behavior of the view.
  final ScrollController scrollController;

  /// A boolean that determines if the refresh indicator is enabled.
  final bool hasRefreshEnabled;

  /// The function that is called when the user pulls down to refresh the view.
  final Future<void> Function()? onRefresh;

  /// The builder function for the refresh indicator.
  final Widget Function(BuildContext, Widget)? refreshIndicatorBuilder;

  /// Creates a forward scrolling [EnhancedBoxView].
  ///
  /// The [delegate] provides the necessary data and configuration for the view.
  /// The [builder] function builds the individual items in the view.
  /// The [page] represents the current page of the view.
  /// The [scrollController] controls the scrolling behavior of the view.
  /// The [hasRefreshEnabled] boolean determines if the refresh indicator is enabled.
  /// The [onRefresh] function is called when the user pulls down to refresh the view.
  /// The [refreshIndicatorBuilder] is a builder function for the refresh indicator.
  const EnhancedBoxView({
    super.key,
    required this.delegate,
    required this.builder,
    required this.direction,
    required this.page,
    required this.scrollController,
    this.hasRefreshEnabled = false,
    this.onRefresh,
    this.refreshIndicatorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return switch (direction) {
      EnhancedViewDirection.forward => buildView(context, false),
      EnhancedViewDirection.reverse => buildView(context, true),
    };
  }

  Widget buildView(BuildContext context, bool reverse) {
    if (hasRefreshEnabled) return buildWithRefreshIndicator(context, reverse);

    return buildScrollView(reverse);
  }

  Widget buildWithRefreshIndicator(BuildContext context, bool reverse) {
    final refreshIndicator = RefreshIndicator(
      onRefresh: onRefresh!,
      child: buildScrollView(reverse),
    );

    if (refreshIndicatorBuilder != null) {
      return refreshIndicatorBuilder!(context, refreshIndicator);
    }

    return refreshIndicator;
  }

  SingleChildScrollView buildScrollView(bool reverse) {
    return SingleChildScrollView(
      reverse: reverse,
      controller: scrollController,
      physics: delegate.physics,
      scrollDirection: delegate.scrollDirection,
      child: Column(
        crossAxisAlignment: delegate.crossAxisAlignment,
        children: [
          if (reverse) LoadingErrorWidget(page: page, delegate: delegate),
          if (delegate.listOfData.isNotEmpty)
            builder(
              delegate.removeDuplicatedItems
                  ? delegate.listOfData.removeDuplication()
                  : delegate.listOfData,
              const NeverScrollableScrollPhysics(),
              reverse,
              true,
            )
          else
            delegate.emptyWidgetConfig.customView ??
                EmptyWidget(config: delegate.emptyWidgetConfig),
          if (!reverse) LoadingErrorWidget(page: page, delegate: delegate),
          if (delegate.header != null) delegate.header!,
        ],
      ),
    );
  }
}
