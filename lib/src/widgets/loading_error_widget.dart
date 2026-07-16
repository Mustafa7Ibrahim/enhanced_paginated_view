import 'package:enhanced_paginated_view/src/models/enhanced_loading_type.dart';
import 'package:enhanced_paginated_view/src/models/enhanced_status.dart';
import 'package:enhanced_paginated_view/src/models/error_load_more_config.dart';
import 'package:enhanced_paginated_view/src/models/loading_config.dart';
import 'package:enhanced_paginated_view/src/widgets/error_load_more_widget.dart';
import 'package:enhanced_paginated_view/src/widgets/loading_widget.dart';
import 'package:flutter/material.dart';

/// A widget that displays a loading or error footer based on the provided
/// [status]. Used to show a "load more" spinner or a retry prompt below the
/// list, as opposed to a full-page loading/error state.
class LoadingErrorWidget extends StatelessWidget {
  /// Creates a `LoadingErrorWidget` for a box-based view.
  ///
  /// The [page] parameter specifies the current page number.
  /// The [status] parameter is the current status of the paginated view.
  const LoadingErrorWidget({
    super.key,
    required this.page,
    required this.status,
    required this.loadingConfig,
    required this.errorLoadMoreConfig,
  });

  /// The current page number.
  final int page;

  /// The current status of the paginated view.
  final EnhancedStatus status;

  /// The configuration for the loading state.
  final LoadingConfig loadingConfig;

  /// The configuration for the error when loading more data.
  final ErrorLoadMoreConfig errorLoadMoreConfig;

  /// Creates a `LoadingErrorWidget` for a sliver-based view.
  ///
  /// The [page] parameter specifies the current page number.
  /// The [status] parameter is the current status of the paginated view.
  static Widget sliver({
    Key? key,
    required int page,
    required EnhancedStatus status,
    required LoadingConfig loadingConfig,
    required ErrorLoadMoreConfig errorLoadMoreConfig,
  }) {
    return SliverToBoxAdapter(
      child: LoadingErrorWidget(
        key: key,
        page: page,
        status: status,
        loadingConfig: loadingConfig,
        errorLoadMoreConfig: errorLoadMoreConfig,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (status == EnhancedStatus.loading)
          LoadingWidget(
            config: loadingConfig,
            type: EnhancedLoadingType.loadMore,
          ),
        if (status == EnhancedStatus.error)
          ErrorLoadMoreWidget(
            config: errorLoadMoreConfig,
            page: page,
          ),
      ],
    );
  }
}
