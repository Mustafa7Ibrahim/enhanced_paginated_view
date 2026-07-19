import 'package:flutter/material.dart';

/// A configuration class for defining the loading widgets used in the enhanced paginated view.
///
/// The [LoadingConfig] class allows you to customize the widgets used for displaying
/// the page and the load more indicators in the enhanced paginated view.
@immutable
class LoadingConfig {
  /// Creates a new instance of [LoadingConfig].
  const LoadingConfig({
    this.pageWidget,
    this.loadMoreWidget,
  });

  /// The widget used for displaying the loading in first page.
  final Widget? pageWidget;

  /// The widget used for displaying the load more indicator.
  final Widget? loadMoreWidget;

  /// Creates a copy of this config with the given fields replaced.
  LoadingConfig copyWith({
    Widget? pageWidget,
    Widget? loadMoreWidget,
  }) {
    return LoadingConfig(
      pageWidget: pageWidget ?? this.pageWidget,
      loadMoreWidget: loadMoreWidget ?? this.loadMoreWidget,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LoadingConfig &&
        other.pageWidget == pageWidget &&
        other.loadMoreWidget == loadMoreWidget;
  }

  @override
  int get hashCode => Object.hash(pageWidget, loadMoreWidget);
}
