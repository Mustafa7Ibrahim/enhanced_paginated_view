import 'package:enhanced_paginated_view/src/models/enhanced_view_type.dart';
import 'package:enhanced_paginated_view/src/models/page_failure_model.dart';
import 'package:enhanced_paginated_view/src/res/failed_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A widget that displays a failure message with an optional retry button.
///
/// The `PageFailureWidget` is typically used to indicate that a page has failed to load
/// or an error has occurred. It displays an icon, a title, a description, and a retry button.
///
/// The widget takes the following parameters:
/// - [title]: The title of the failure message.
/// - [description]: A description of the failure.
/// - [btnText]: The text to display on the retry button.
/// - [onRetry]: A callback function to be called when the retry button is pressed.
/// - [retryButton]: A custom widget for the retry button.
///
/// Example usage:
/// ```dart
/// PageFailureWidget(
///   title: 'Error',
///   description: 'Something went wrong. Please try again.',
///   btnText: 'Retry',
///   onRetry: () {
///     // Retry logic here
///   },
///   retryButton: ElevatedButton(
///     onPressed: () {
///       // Retry logic here
///     },
///     child: Text('Retry'),
///   ),
/// )
/// ```
class PageFailureWidget extends StatelessWidget {
  /// Creates a `PageFailureWidget`.
  ///
  /// All parameters are required and must not be null.
  const PageFailureWidget._({
    required this.model,
    required this.enhancedViewType,
  });

  // box factory constructor for the PageFailureWidget class
  factory PageFailureWidget({required PageFailureModel pageFailureModel}) {
    return PageFailureWidget._(
      model: pageFailureModel,
      enhancedViewType: EnhancedViewType.box,
    );
  }

  // sliver factory constructor for sliver-based view type
  factory PageFailureWidget.sliver({
    required PageFailureModel pageFailureModel,
  }) {
    return PageFailureWidget._(
      model: pageFailureModel,
      enhancedViewType: EnhancedViewType.sliver,
    );
  }

  final PageFailureModel model;

  /// The type of view to use for the enhanced paginated view.
  final EnhancedViewType enhancedViewType;

  @override
  Widget build(BuildContext context) {
    return switch (enhancedViewType) {
      EnhancedViewType.box => buildBox(context),
      EnhancedViewType.sliver => buildSliver(context),
    };
  }

  // box build function
  Widget buildBox(BuildContext context) {
    return SafeArea(
      child: _FailureWidget(model: model),
    );
  }

  // sliver build function
  Widget buildSliver(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: _FailureWidget(model: model),
    );
  }
}

class _FailureWidget extends StatelessWidget {
  const _FailureWidget({required this.model});

  /// The title of the failure message.
  final PageFailureModel model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Spacer(flex: 2),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: AspectRatio(
              aspectRatio: 1,
              child: SvgPicture.string(
                failedIcon,
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
          const Spacer(flex: 2),
          Text(
            model.title ?? "Opps!....",
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            model.description ??
                "Something wrong with your connection, Please try again after a moment.",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16 * 2.5),
          model.retryButton ??
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                onPressed: model.onRetry,
                child: Text(model.btnText ?? "Retry".toUpperCase()),
              ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
