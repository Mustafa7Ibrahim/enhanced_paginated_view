import 'package:enhanced_paginated_view/src/models/empty_widget_config.dart';
import 'package:flutter/material.dart';

/// A widget that represents an empty state.
///
/// This widget is typically used when there is no data to display.
/// It renders [EmptyWidgetConfig.customView] if provided, otherwise a
/// centered title.
class EmptyWidget extends StatelessWidget {
  /// Creates an `EmptyWidget` for a box-based view.
  const EmptyWidget({super.key, required this.config});

  /// The config for the empty widget.
  final EmptyWidgetConfig config;

  /// Creates an `EmptyWidget` for a sliver-based view.
  static Widget sliver({Key? key, required EmptyWidgetConfig config}) {
    return SliverToBoxAdapter(
      child: EmptyWidget(key: key, config: config),
    );
  }

  @override
  Widget build(BuildContext context) {
    return config.customView ?? _EmptyWidget(config: config);
  }
}

class _EmptyWidget extends StatelessWidget {
  const _EmptyWidget({required this.config});

  final EmptyWidgetConfig config;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Center(
        child: Text(
          config.title,
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
