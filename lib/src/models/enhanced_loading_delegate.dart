import 'package:flutter/material.dart';

/// A configuration class for defining the loading widgets used in the enhanced paginated view.
///
/// The [LoadingConfig] class allows you to customize the widgets used for displaying
/// the page and the load more indicators in the enhanced paginated view.
class LoadingConfig {
  /// The widget used for displaying the loading in first page.
  final Widget? pageWidget;

  /// The widget used for displaying the load more indicator.
  final Widget? loadMoreWidget;

  /// Creates a new instance of [LoadingConfig].
  const LoadingConfig({
    this.pageWidget,
    this.loadMoreWidget,
  });
}
