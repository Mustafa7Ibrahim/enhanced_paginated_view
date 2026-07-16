import 'package:flutter/material.dart';

/// A configuration class for the empty widget.
///
/// This class holds the configuration options for the empty widget that is displayed when no results are found.
@immutable
class EmptyWidgetConfig {
  /// Creates a new instance of [EmptyWidgetConfig].
  ///
  /// The [title] parameter is used to set the title of the empty widget. By default, it is set to "No data found".
  ///
  /// The [customView] parameter is an optional custom widget to be displayed as the empty widget.
  const EmptyWidgetConfig({
    this.title = "No data found",
    this.customView,
  });

  /// The title of the empty widget.
  final String title;

  /// A custom widget to be displayed as the empty widget.
  final Widget? customView;

  /// Creates a copy of this config with the given fields replaced.
  EmptyWidgetConfig copyWith({
    String? title,
    Widget? customView,
  }) {
    return EmptyWidgetConfig(
      title: title ?? this.title,
      customView: customView ?? this.customView,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EmptyWidgetConfig &&
        other.title == title &&
        other.customView == customView;
  }

  @override
  int get hashCode => Object.hash(title, customView);
}
