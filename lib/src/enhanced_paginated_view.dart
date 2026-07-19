import 'package:enhanced_paginated_view/src/core/custom_type_def.dart';
import 'package:enhanced_paginated_view/src/core/enhanced_deduplication.dart';
import 'package:enhanced_paginated_view/src/core/enhanced_pagination_controller.dart';
import 'package:enhanced_paginated_view/src/models/enhanced_config.dart';
import 'package:enhanced_paginated_view/src/models/enhanced_delegate.dart';
import 'package:enhanced_paginated_view/src/models/enhanced_loading_type.dart';
import 'package:enhanced_paginated_view/src/models/enhanced_status.dart';
import 'package:enhanced_paginated_view/src/models/enhanced_view_direction.dart';
import 'package:enhanced_paginated_view/src/views/enhanced_box_view.dart';
import 'package:enhanced_paginated_view/src/views/enhanced_sliver_view.dart';
import 'package:enhanced_paginated_view/src/widgets/error_page_widget.dart';
import 'package:enhanced_paginated_view/src/widgets/loading_widget.dart';
import 'package:flutter/material.dart';

/// This is the EnhancedPaginatedView widget.
/// It provides a paginated view of items of type [T].
abstract class EnhancedPaginatedView<T> extends StatefulWidget {
  /// Constructs an EnhancedPaginatedView widget backed by a "bring your own
  /// scrollable" [builder] (e.g. a [ListView] or [GridView]).
  ///
  /// The [onLoadMore] function is called with the page to load when the user
  /// scrolls close to the end of the list.
  /// The [hasReachedMax] boolean disables further load-more calls once true.
  /// The [delegate] is an instance of [EnhancedDelegate] carrying the data
  /// and status.
  /// The [config] carries presentation/behavior options.
  /// The [builder] builds the box-based scrollable that renders [data].
  /// The [direction] specifies the direction of the enhanced paginated view.
  /// The [refreshBuilder] is a builder function for creating a refresh indicator.
  /// The [onRefresh] function is called when the user pulls down to refresh the list.
  /// The [loadMoreThreshold] is how many pixels before the end edge of the
  /// scrollable a load-more request should be triggered.
  ///
  /// Note: because [builder] supplies its own scrollable, this variant is
  /// wrapped in a [SingleChildScrollView] with `shrinkWrap`-like eager
  /// layout. For very large lists prefer [EnhancedPaginatedView.slivers].
  const factory EnhancedPaginatedView({
    Key? key,
    required EnhancedDelegate<T> delegate,
    EnhancedConfig config,
    required bool hasReachedMax,
    required void Function(int page) onLoadMore,
    required EnhancedBoxBuilder<T> builder,
    EnhancedPaginationController? controller,
    EnhancedViewDirection direction,
    Future<void> Function()? onRefresh,
    EnhancedRefreshBuilder<T>? refreshBuilder,
    double loadMoreThreshold,
  }) = _BoxEnhancedPaginatedView<T>;

  /// Constructs an EnhancedPaginatedView widget backed by a
  /// [CustomScrollView]-compatible [builder] that returns sliver widgets.
  ///
  /// The [onLoadMore] function is called with the page to load when the user
  /// scrolls close to the end of the list.
  /// The [hasReachedMax] boolean disables further load-more calls once true.
  /// The [delegate] is an instance of [EnhancedDelegate] carrying the data
  /// and status.
  /// The [config] carries presentation/behavior options.
  /// The [builder] builds the sliver(s) that render [data].
  /// The [direction] specifies the direction of the enhanced paginated view.
  /// The [refreshBuilder] is a builder function for creating a refresh indicator.
  /// The [onRefresh] function is called when the user pulls down to refresh the list.
  /// The [loadMoreThreshold] is how many pixels before the end edge of the
  /// scrollable a load-more request should be triggered.
  const factory EnhancedPaginatedView.slivers({
    Key? key,
    required EnhancedDelegate<T> delegate,
    EnhancedConfig config,
    required bool hasReachedMax,
    required void Function(int page) onLoadMore,
    required EnhancedSliverBuilder<T> builder,
    EnhancedPaginationController? controller,
    EnhancedViewDirection direction,
    Future<void> Function()? onRefresh,
    EnhancedRefreshBuilder<T>? refreshBuilder,
    double loadMoreThreshold,
  }) = _SliverEnhancedPaginatedView<T>;

  // Private constructor shared by both variants.
  const EnhancedPaginatedView._({
    super.key,
    required this.delegate,
    this.config = const EnhancedConfig(),
    required this.hasReachedMax,
    required this.onLoadMore,
    this.controller,
    this.direction = EnhancedViewDirection.forward,
    this.onRefresh,
    this.refreshBuilder,
    this.loadMoreThreshold = 200,
  });

  /// [delegate] is an instance of [EnhancedDelegate] that provides data and status information.
  final EnhancedDelegate<T> delegate;

  /// [config] carries presentation/behavior configuration for the view.
  final EnhancedConfig config;

  /// [hasReachedMax] is a boolean that controls the loading widget.
  ///
  /// This boolean is set to true when the list reaches the end.
  final bool hasReachedMax;

  /// [onLoadMore] is a function that is called when the user reaches the end of the list.
  ///
  /// This function is required and receives the page number to load next.
  final void Function(int page) onLoadMore;

  /// [controller] tracks the current page and in-flight load-more state.
  ///
  /// If not provided, an internal controller is created and disposed
  /// automatically.
  final EnhancedPaginationController? controller;

  /// Specifies the direction of the enhanced paginated view.
  ///
  /// The [EnhancedViewDirection] enum is used to determine the scrolling direction
  /// of the enhanced paginated view. It can be set to either [EnhancedViewDirection.forward]
  /// or [EnhancedViewDirection.reverse].
  final EnhancedViewDirection direction;

  /// [onRefresh] is a function that is called when the user pulls down to refresh the list.
  /// if this function is not provided, the refresh indicator will not be shown.
  final Future<void> Function()? onRefresh;

  /// [refreshBuilder] is a builder function for creating a refresh indicator.
  /// if this function is not provided, the default refresh indicator will be shown.
  final EnhancedRefreshBuilder<T>? refreshBuilder;

  /// How many pixels before the end edge of the scrollable a load-more
  /// request should be triggered.
  final double loadMoreThreshold;

  /// Renders the content for [data] using the concrete builder supplied by
  /// the chosen factory (box or sliver).
  Widget _buildContent({
    required BuildContext context,
    required List<T> data,
    required EnhancedStatus status,
    required int page,
    required ScrollController scrollController,
    required ScrollPhysics? physics,
  });

  @override
  State<EnhancedPaginatedView<T>> createState() =>
      _EnhancedPaginatedViewState<T>();
}

/// Box-based variant of [EnhancedPaginatedView].
class _BoxEnhancedPaginatedView<T> extends EnhancedPaginatedView<T> {
  const _BoxEnhancedPaginatedView({
    super.key,
    required super.delegate,
    super.config,
    required super.hasReachedMax,
    required super.onLoadMore,
    required this.builder,
    super.controller,
    super.direction,
    super.onRefresh,
    super.refreshBuilder,
    super.loadMoreThreshold,
  }) : super._();

  /// Builds the box-based scrollable that renders the data.
  final EnhancedBoxBuilder<T> builder;

  @override
  Widget _buildContent({
    required BuildContext context,
    required List<T> data,
    required EnhancedStatus status,
    required int page,
    required ScrollController scrollController,
    required ScrollPhysics? physics,
  }) {
    return EnhancedBoxView<T>(
      data: data,
      config: config,
      status: status,
      builder: builder,
      direction: direction,
      page: page,
      scrollController: scrollController,
      physics: physics,
    );
  }
}

/// Sliver-based variant of [EnhancedPaginatedView].
class _SliverEnhancedPaginatedView<T> extends EnhancedPaginatedView<T> {
  const _SliverEnhancedPaginatedView({
    super.key,
    required super.delegate,
    super.config,
    required super.hasReachedMax,
    required super.onLoadMore,
    required this.builder,
    super.controller,
    super.direction,
    super.onRefresh,
    super.refreshBuilder,
    super.loadMoreThreshold,
  }) : super._();

  /// Builds the sliver(s) that render the data.
  final EnhancedSliverBuilder<T> builder;

  @override
  Widget _buildContent({
    required BuildContext context,
    required List<T> data,
    required EnhancedStatus status,
    required int page,
    required ScrollController scrollController,
    required ScrollPhysics? physics,
  }) {
    return EnhancedSliverView<T>(
      data: data,
      config: config,
      status: status,
      direction: direction,
      builder: builder,
      page: page,
      scrollController: scrollController,
      physics: physics,
    );
  }
}

class _EnhancedPaginatedViewState<T> extends State<EnhancedPaginatedView<T>> {
  final ScrollController _scrollController = ScrollController();
  late EnhancedPaginationController _paginationController;
  bool _ownsPaginationController = false;
  late List<T> _dedupedData;

  /// Length of the source list the last time [_dedupedData] was computed.
  /// Tracked in a field (not via `oldWidget`) so that in-place mutations of
  /// the *same* list instance are still detected and re-deduplicated.
  int _dedupeSourceLength = 0;

  @override
  void initState() {
    super.initState();
    _attachPaginationController();
    _dedupedData = _dedupe(widget.delegate.listOfData);
    _dedupeSourceLength = widget.delegate.listOfData.length;
  }

  void _attachPaginationController() {
    final EnhancedPaginationController? injected = widget.controller;
    if (injected != null) {
      _paginationController = injected;
      _ownsPaginationController = false;
    } else {
      _paginationController = EnhancedPaginationController();
      _ownsPaginationController = true;
    }
  }

  List<T> _dedupe(List<T> data) {
    return widget.config.removeDuplicatedItems
        ? data.removeDuplication()
        : data;
  }

  /// Requests the next page, guarding against duplicate in-flight requests.
  void _loadMore() {
    if (_paginationController.isLoadingMore) return;
    _paginationController.markLoadStarted();
    try {
      widget.onLoadMore(_paginationController.page);
    } catch (_) {
      // A synchronous failure must release the in-flight lock, otherwise
      // load-more would be permanently disabled. The error still propagates.
      _paginationController.markLoadFailed();
      rethrow;
    }
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    // Only react to the view's own scrollable. Without this guard, an inner
    // scrollable (e.g. a horizontal carousel inside a list item) bubbling its
    // notifications would spuriously trigger the outer load-more.
    if (notification.depth != 0) return false;
    if (notification is ScrollUpdateNotification) {
      _maybeLoadMore(notification.metrics);
    }
    return false;
  }

  void _maybeLoadMore(ScrollMetrics metrics) {
    if (widget.hasReachedMax) return;
    if (widget.delegate.status != EnhancedStatus.loaded) return;
    if (_paginationController.isLoadingMore) return;
    if (metrics.extentAfter <= widget.loadMoreThreshold) {
      _loadMore();
    }
  }

  /// Guards against short initial pages that don't fill the viewport, which
  /// would otherwise never produce a scroll notification to trigger the
  /// next load-more request.
  void _scheduleViewportFillCheck() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (!_scrollController.hasClients) return;
      if (_scrollController.position.maxScrollExtent != 0) return;
      if (widget.hasReachedMax) return;
      if (widget.delegate.status != EnhancedStatus.loaded) return;
      if (_paginationController.isLoadingMore) return;
      _loadMore();
    });
  }

  Future<void> _handleRefresh() async {
    _paginationController.reset();
    await widget.onRefresh!();
  }

  /// The scroll physics to apply to the view's scrollable.
  ///
  /// When [EnhancedPaginatedView.onRefresh] is provided, this forces an
  /// always-scrollable physics (preserving any configured physics as its
  /// parent) so pull-to-refresh keeps working even when the content is
  /// shorter than the viewport and would otherwise not be draggable.
  ScrollPhysics? get _effectivePhysics {
    final ScrollPhysics? configured = widget.config.physics;
    if (widget.onRefresh != null) {
      return AlwaysScrollableScrollPhysics(parent: configured);
    }
    return configured;
  }

  /// Wraps a full-page empty state (loading/error) so pull-to-refresh keeps
  /// working when there is no content.
  ///
  /// [RefreshIndicator] needs a scrollable descendant to detect overscroll,
  /// but the empty loading/error widgets are not scrollable on their own. When
  /// [EnhancedPaginatedView.onRefresh] is set, this places the child inside an
  /// always-scrollable [SingleChildScrollView] sized to fill the viewport. The
  /// child is given a bounded height (rather than the scroll view's unbounded
  /// height) so full-page states that rely on [Expanded]/[Spacer] lay out
  /// correctly. When no refresh handler is present, the child is returned
  /// as-is.
  ///
  /// This assumes a vertical axis; for a horizontal refresh, supply a custom
  /// [EnhancedPaginatedView.refreshBuilder].
  Widget _wrapEmptyState(Widget child) {
    if (widget.onRefresh == null) return child;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          controller: _scrollController,
          physics: _effectivePhysics,
          child: SizedBox(
            height: constraints.maxHeight.isFinite
                ? constraints.maxHeight
                : null,
            child: child,
          ),
        );
      },
    );
  }

  @override
  void didUpdateWidget(covariant EnhancedPaginatedView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      if (_ownsPaginationController) {
        _paginationController.dispose();
      }
      _attachPaginationController();
    }

    final List<T> data = widget.delegate.listOfData;
    if (!identical(data, oldWidget.delegate.listOfData) ||
        data.length != _dedupeSourceLength ||
        widget.config.removeDuplicatedItems !=
            oldWidget.config.removeDuplicatedItems) {
      _dedupedData = _dedupe(data);
      _dedupeSourceLength = data.length;
    }

    final int oldLength = oldWidget.delegate.listOfData.length;
    final int newLength = data.length;
    final EnhancedStatus oldStatus = oldWidget.delegate.status;
    final EnhancedStatus newStatus = widget.delegate.status;

    if (_paginationController.isLoadingMore) {
      // A tracked load-more request must always resolve — the in-flight lock
      // must never be left stuck (which would permanently disable load-more).
      if (newStatus == EnhancedStatus.error) {
        // Failed: clear the lock but hold the page so a retry re-requests it.
        _paginationController.markLoadFailed();
      } else if (newLength > oldLength ||
          (oldStatus == EnhancedStatus.loading &&
              newStatus == EnhancedStatus.loaded)) {
        // Resolved with new data (or a loading→loaded round-trip): advance
        // the page and clear the lock.
        _paginationController.markDataReceived();
      }
      // Otherwise still waiting (e.g. the frame between requesting and the
      // consumer emitting `loading`) — keep the lock held.
    } else if (oldStatus == EnhancedStatus.loading &&
        newStatus == EnhancedStatus.loaded) {
      // Consumer-driven page load (e.g. a bloc's initial fetch) with no
      // widget-tracked request in flight. Local edits that keep the status
      // `loaded` must not advance the page, so this only reacts to a genuine
      // loading→loaded transition.
      _paginationController.markDataReceived();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    if (_ownsPaginationController) {
      _paginationController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scheduleViewportFillCheck();

    final bool isEmpty = widget.delegate.listOfData.isEmpty;
    Widget content;
    if (isEmpty && widget.delegate.status == EnhancedStatus.loading) {
      content = _wrapEmptyState(
        LoadingWidget(
          config: widget.config.loadingConfig,
          type: EnhancedLoadingType.page,
        ),
      );
    } else if (isEmpty && widget.delegate.status == EnhancedStatus.error) {
      content = _wrapEmptyState(
        ErrorPageWidget(config: widget.config.errorPageConfig),
      );
    } else {
      content = widget._buildContent(
        context: context,
        data: _dedupedData,
        status: widget.delegate.status,
        page: _paginationController.page,
        scrollController: _scrollController,
        physics: _effectivePhysics,
      );
    }

    final Future<void> Function()? onRefresh = widget.onRefresh;
    if (onRefresh != null) {
      content = widget.refreshBuilder != null
          ? widget.refreshBuilder!(context, _handleRefresh, content)
          : RefreshIndicator(onRefresh: _handleRefresh, child: content);
    }

    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: content,
    );
  }
}
