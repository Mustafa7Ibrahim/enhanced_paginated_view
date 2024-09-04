import 'package:enhanced_paginated_view/src/models/enhanced_view_type.dart';
import 'package:enhanced_paginated_view/src/models/loading_failure_model.dart';
import 'package:enhanced_paginated_view/src/widgets/loading_failure_widget.dart';
import 'package:enhanced_paginated_view/src/widgets/loading_widget.dart';
import 'package:flutter/material.dart';

class LoadingErrorWidget extends StatelessWidget {
  const LoadingErrorWidget._({
    required this.page,
    required this.showError,
    required this.showLoading,
    required this.enhancedViewType,
    this.errorWidget,
    this.loadingWidget,
    required this.loadingFailureModel,
  });

  /// Creates a `LoadingErrorWidget` with a box view type.
  factory LoadingErrorWidget({
    required int page,
    required bool showError,
    required bool showLoading,
    Widget Function(int)? errorWidget,
    Widget? loadingWidget,
    LoadingFailureModel? loadingFailureModel,
  }) {
    return LoadingErrorWidget._(
      page: page,
      showError: showError,
      showLoading: showLoading,
      errorWidget: errorWidget,
      loadingWidget: loadingWidget,
      enhancedViewType: EnhancedViewType.box,
      loadingFailureModel: loadingFailureModel,
    );
  }

  /// Creates a `LoadingErrorWidget` with a sliver view type.
  factory LoadingErrorWidget.sliver({
    required int page,
    required bool showError,
    required bool showLoading,
    Widget Function(int)? errorWidget,
    Widget? loadingWidget,
    LoadingFailureModel? loadingFailureModel,
  }) {
    return LoadingErrorWidget._(
      page: page,
      showError: showError,
      showLoading: showLoading,
      errorWidget: errorWidget,
      loadingWidget: loadingWidget,
      enhancedViewType: EnhancedViewType.sliver,
      loadingFailureModel: loadingFailureModel,
    );
  }

  final int page;
  final bool showError;
  final bool showLoading;

  final EnhancedViewType enhancedViewType;

  final Widget Function(int)? errorWidget;
  final Widget? loadingWidget;

  final LoadingFailureModel? loadingFailureModel;

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
        if (showLoading) loadingWidget ?? LoadingWidget(),
        if (showError)
          if (errorWidget != null)
            errorWidget!(page)
          else
            LoadingFailureWidget(model: loadingFailureModel),
      ],
    );
  }

  // build the sliver view
  Widget buildSliver(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          if (showLoading) loadingWidget ?? LoadingWidget(),
          if (showError)
            if (errorWidget != null)
              errorWidget!(page)
            else
              LoadingFailureWidget(model: loadingFailureModel),
        ],
      ),
    );
  }
}
