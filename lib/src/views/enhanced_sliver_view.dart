import 'package:enhanced_paginated_view/src/core/custom_type_def.dart';
import 'package:enhanced_paginated_view/src/models/enhanced_config.dart';
import 'package:enhanced_paginated_view/src/models/enhanced_status.dart';
import 'package:enhanced_paginated_view/src/models/enhanced_view_direction.dart';
import 'package:enhanced_paginated_view/src/widgets/empty_widget.dart';
import 'package:enhanced_paginated_view/src/widgets/loading_error_widget.dart';
import 'package:flutter/material.dart';

/// A widget that represents an enhanced sliver view.
///
/// This widget is used to display an already-deduplicated list of data in a
/// sliver format, with enhanced features such as pagination and error
/// handling.
class EnhancedSliverView<T> extends StatelessWidget {
  /// Creates an instance of [EnhancedSliverView].
  const EnhancedSliverView({
    super.key,
    required this.data,
    required this.config,
    required this.status,
    required this.direction,
    required this.builder,
    required this.page,
    required this.scrollController,
  });

  /// The already-deduplicated data to be displayed.
  final List<T> data;

  /// The presentation configuration for the view.
  final EnhancedConfig config;

  /// The current status of the paginated view.
  final EnhancedStatus status;

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
    final bool isReverse = direction == EnhancedViewDirection.reverse;

    final List<Widget> slivers = [
      if (config.header != null) config.header!,
      _buildListOrEmpty(context),
      LoadingErrorWidget.sliver(
        page: page,
        status: status,
        loadingConfig: config.loadingConfig,
        errorLoadMoreConfig: config.errorLoadMoreConfig,
      ),
    ];

    return CustomScrollView(
      controller: scrollController,
      physics: config.physics,
      scrollDirection: config.scrollDirection,
      slivers: isReverse ? slivers.reversed.toList() : slivers,
    );
  }

  /// Builds the list content, or an empty-state widget when [data] is empty.
  Widget _buildListOrEmpty(BuildContext context) {
    if (data.isEmpty) {
      return EmptyWidget.sliver(config: config.emptyWidgetConfig);
    }
    return builder(context, data);
  }
}
