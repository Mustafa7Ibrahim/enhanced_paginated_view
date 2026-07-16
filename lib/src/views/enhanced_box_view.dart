import 'package:enhanced_paginated_view/src/core/custom_type_def.dart';
import 'package:enhanced_paginated_view/src/models/enhanced_config.dart';
import 'package:enhanced_paginated_view/src/models/enhanced_status.dart';
import 'package:enhanced_paginated_view/src/models/enhanced_view_direction.dart';
import 'package:enhanced_paginated_view/src/widgets/empty_widget.dart';
import 'package:enhanced_paginated_view/src/widgets/loading_error_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// A widget that displays a paginated view in a box layout.
///
/// The [EnhancedBoxView] widget is used to display a paginated view in a box
/// layout. It takes an already-deduplicated [data] list, a [config] that
/// provides presentation options, a [builder] function that builds the
/// individual items in the view, a [direction] that determines the scrolling
/// direction of the view, a [page] number used by the footer retry button,
/// a [status] used to decide whether to show a footer loading/error region,
/// and a [scrollController] that controls the scrolling behavior of the view.
class EnhancedBoxView<T> extends StatelessWidget {
  /// Creates an [EnhancedBoxView].
  const EnhancedBoxView({
    super.key,
    required this.data,
    required this.config,
    required this.status,
    required this.builder,
    required this.direction,
    required this.page,
    required this.scrollController,
    required this.physics,
  });

  /// The already-deduplicated data to be displayed.
  final List<T> data;

  /// The presentation configuration for the view.
  final EnhancedConfig config;

  /// The effective scroll physics for the outer scrollable. This is resolved
  /// by the parent so that pull-to-refresh stays available even when the
  /// content is shorter than the viewport.
  final ScrollPhysics? physics;

  /// The current status of the paginated view.
  final EnhancedStatus status;

  /// The function that builds the individual items in the view.
  final EnhancedBoxBuilder<T> builder;

  /// The scrolling direction of the view.
  final EnhancedViewDirection direction;

  /// The current page of the view.
  final int page;

  /// The scroll controller that controls the scrolling behavior of the view.
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final bool isReverse = direction == EnhancedViewDirection.reverse;

    final List<Widget> children = [
      if (config.header != null) config.header!,
      _buildListOrEmpty(isReverse),
      LoadingErrorWidget(
        page: page,
        status: status,
        loadingConfig: config.loadingConfig,
        errorLoadMoreConfig: config.errorLoadMoreConfig,
      ),
    ];

    return SingleChildScrollView(
      reverse: isReverse,
      dragStartBehavior:
          isReverse ? DragStartBehavior.down : DragStartBehavior.start,
      controller: scrollController,
      physics: physics,
      scrollDirection: config.scrollDirection,
      child: Column(
        crossAxisAlignment: config.crossAxisAlignment,
        children: isReverse ? children.reversed.toList() : children,
      ),
    );
  }

  /// Builds the list content, or an empty-state widget when [data] is empty.
  Widget _buildListOrEmpty(bool isReverse) {
    if (data.isEmpty) {
      return EmptyWidget(config: config.emptyWidgetConfig);
    }
    return builder(
      data,
      const NeverScrollableScrollPhysics(),
      isReverse,
      true,
    );
  }
}
