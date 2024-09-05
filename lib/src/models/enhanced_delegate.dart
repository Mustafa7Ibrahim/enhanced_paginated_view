import 'package:enhanced_paginated_view/enhanced_paginated_view.dart';
import 'package:flutter/material.dart';

/// A delegate class for the EnhancedPaginatedView widget.
///
/// This delegate class provides configuration options for the EnhancedPaginatedView widget.
class EnhancedDelegate<T> {
  /// The physics of the scrollable area.
  final ScrollPhysics? physics;

  /// Whether to remove duplicated items from the list of data.
  final bool removeDuplicatedItems;

  /// The direction in which the list should scroll.
  final Axis scrollDirection;

  /// The alignment of the children along the cross axis.
  final CrossAxisAlignment crossAxisAlignment;

  /// The list of data to be displayed in the EnhancedPaginatedView.
  final List<T> listOfData;

  /// The current status of the EnhancedPaginatedView.
  final EnhancedStatus status;

  /// The widget to be displayed as the header of the EnhancedPaginatedView.
  final Widget? header;

  /// The configuration for the empty widget.
  final EmptyWidgetConfig emptyWidgetConfig;

  /// The configuration for the error page.
  final ErrorPageConfig errorPageConfig;

  /// The configuration for the error when loading more data.
  final ErrorLoadMoreConfig errorLoadMoreConfig;

  /// The configuration for the loading state.
  final LoadingConfig loadingConfig;

  /// Creates a new instance of the EnhancedDelegate class.
  ///
  /// The [listOfData] parameter is required and represents the list of data to be displayed.
  /// The [status] parameter is required and represents the current status of the EnhancedPaginatedView.
  /// The [physics] parameter is optional and represents the physics of the scrollable area.
  /// The [header] parameter is optional and represents the widget to be displayed as the header of the EnhancedPaginatedView.
  /// The [emptyWidgetConfig] parameter is optional and represents the widget to be displayed when the list of data is empty or add customization.
  /// The [loadingConfig] parameter is optional and represents the configuration for the loading state.
  /// The [errorLoadMoreConfig] parameter is optional and represents the configuration for the error when loading more data.
  /// The [errorPageConfig] parameter is optional and represents the configuration for the error page.
  /// The [removeDuplicatedItems] parameter is optional and determines whether to remove duplicated items from the list of data.
  /// The [scrollDirection] parameter is optional and represents the direction in which the list should scroll.
  /// The [crossAxisAlignment] parameter is optional and represents the alignment of the children along the cross axis.
  EnhancedDelegate({
    required this.listOfData,
    required this.status,
    this.physics,
    this.header,
    this.emptyWidgetConfig = const EmptyWidgetConfig(),
    this.loadingConfig = const LoadingConfig(),
    this.errorLoadMoreConfig = const ErrorLoadMoreConfig(),
    this.errorPageConfig = const ErrorPageConfig(),
    this.removeDuplicatedItems = true,
    this.scrollDirection = Axis.vertical,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });
}
