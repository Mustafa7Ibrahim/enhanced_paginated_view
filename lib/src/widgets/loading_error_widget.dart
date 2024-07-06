import 'package:enhanced_paginated_view/src/widgets/error_widget.dart';
import 'package:enhanced_paginated_view/src/widgets/loading_widget.dart';
import 'package:flutter/material.dart';

class LoadingErrorWidget extends StatelessWidget {
  const LoadingErrorWidget({
    super.key,
    required this.page,
    required this.showError,
    required this.showLoading,
    this.errorWidget,
    this.loadingWidget,
  });

  final int page;
  final bool showError;
  final bool showLoading;

  final Widget Function(int)? errorWidget;
  final Widget? loadingWidget;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showLoading) loadingWidget ?? const LoadingWidget(),
        if (showError)
          if (errorWidget != null)
            errorWidget!(page)
          else
            const SomethingWentWrong(),
      ],
    );
  }
}
