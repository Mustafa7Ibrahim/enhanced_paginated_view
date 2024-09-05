import 'package:enhanced_paginated_view/src/res/no_result_icon.dart';
import 'package:flutter/material.dart';

/// A configuration class for the empty widget.
///
/// This class holds the configuration options for the empty widget that is displayed when no results are found.
class EmptyWidgetConfig {
  /// The title of the empty widget.
  final String title;

  /// The SVG icon path for the empty widget.
  final String svgIcon;

  /// A custom widget to be displayed as the empty widget.
  final Widget? customView;

  /// Creates a new instance of [EmptyWidgetConfig].
  ///
  /// The [title] parameter is used to set the title of the empty widget. By default, it is set to "No results found".
  ///
  /// The [svgIcon] parameter is used to set the SVG icon path for the empty widget. By default, it is set to [noResultsIcon].
  ///
  /// The [customView] parameter is an optional custom widget to be displayed as the empty widget.
  const EmptyWidgetConfig({
    this.title = "No results found",
    this.svgIcon = noResultsIcon,
    this.customView,
  });
}
