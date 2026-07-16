import 'package:enhanced_paginated_view/src/models/empty_widget_config.dart';
import 'package:enhanced_paginated_view/src/models/error_load_more_config.dart';
import 'package:enhanced_paginated_view/src/models/error_page_config.dart';
import 'package:enhanced_paginated_view/src/models/loading_config.dart';
import 'package:flutter/material.dart';

/// Presentation and behavior configuration for [EnhancedPaginatedView].
///
/// This holds everything that controls *how* the view looks and scrolls,
/// as opposed to [EnhancedDelegate] which only carries *what* data is shown.
@immutable
class EnhancedConfig {
  /// Creates a new instance of [EnhancedConfig].
  const EnhancedConfig({
    this.physics,
    this.header,
    this.scrollDirection = Axis.vertical,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.removeDuplicatedItems = true,
    this.emptyWidgetConfig = const EmptyWidgetConfig(),
    this.loadingConfig = const LoadingConfig(),
    this.errorLoadMoreConfig = const ErrorLoadMoreConfig(),
    this.errorPageConfig = const ErrorPageConfig(),
  });

  /// The physics of the scrollable area.
  final ScrollPhysics? physics;

  /// The widget to be displayed as the header of the EnhancedPaginatedView.
  final Widget? header;

  /// The direction in which the list should scroll.
  final Axis scrollDirection;

  /// The alignment of the children along the cross axis.
  final CrossAxisAlignment crossAxisAlignment;

  /// Whether to remove duplicated items from the list of data.
  final bool removeDuplicatedItems;

  /// The configuration for the empty widget.
  final EmptyWidgetConfig emptyWidgetConfig;

  /// The configuration for the loading state.
  final LoadingConfig loadingConfig;

  /// The configuration for the error when loading more data.
  final ErrorLoadMoreConfig errorLoadMoreConfig;

  /// The configuration for the error page.
  final ErrorPageConfig errorPageConfig;

  /// Creates a copy of this config with the given fields replaced.
  EnhancedConfig copyWith({
    ScrollPhysics? physics,
    Widget? header,
    Axis? scrollDirection,
    CrossAxisAlignment? crossAxisAlignment,
    bool? removeDuplicatedItems,
    EmptyWidgetConfig? emptyWidgetConfig,
    LoadingConfig? loadingConfig,
    ErrorLoadMoreConfig? errorLoadMoreConfig,
    ErrorPageConfig? errorPageConfig,
  }) {
    return EnhancedConfig(
      physics: physics ?? this.physics,
      header: header ?? this.header,
      scrollDirection: scrollDirection ?? this.scrollDirection,
      crossAxisAlignment: crossAxisAlignment ?? this.crossAxisAlignment,
      removeDuplicatedItems:
          removeDuplicatedItems ?? this.removeDuplicatedItems,
      emptyWidgetConfig: emptyWidgetConfig ?? this.emptyWidgetConfig,
      loadingConfig: loadingConfig ?? this.loadingConfig,
      errorLoadMoreConfig: errorLoadMoreConfig ?? this.errorLoadMoreConfig,
      errorPageConfig: errorPageConfig ?? this.errorPageConfig,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EnhancedConfig &&
        other.physics == physics &&
        other.header == header &&
        other.scrollDirection == scrollDirection &&
        other.crossAxisAlignment == crossAxisAlignment &&
        other.removeDuplicatedItems == removeDuplicatedItems &&
        other.emptyWidgetConfig == emptyWidgetConfig &&
        other.loadingConfig == loadingConfig &&
        other.errorLoadMoreConfig == errorLoadMoreConfig &&
        other.errorPageConfig == errorPageConfig;
  }

  @override
  int get hashCode => Object.hash(
        physics,
        header,
        scrollDirection,
        crossAxisAlignment,
        removeDuplicatedItems,
        emptyWidgetConfig,
        loadingConfig,
        errorLoadMoreConfig,
        errorPageConfig,
      );
}
