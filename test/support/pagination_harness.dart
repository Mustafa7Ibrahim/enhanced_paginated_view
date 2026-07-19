import 'package:enhanced_paginated_view/enhanced_paginated_view.dart';
import 'package:flutter/material.dart';

/// A small stateful harness that stands in for a real data source (e.g. a
/// bloc/cubit) driving an [EnhancedPaginatedView].
///
/// It owns the mutable `List<int>`, [EnhancedStatus] and `hasReachedMax`
/// that would normally live in application state, and exposes [emit] so
/// tests can simulate the consumer reacting to `onLoadMore` calls (start a
/// `loading` status, then flip to `loaded`/`error`).
class PaginationHarness extends StatefulWidget {
  const PaginationHarness({
    super.key,
    required this.initialData,
    required this.initialStatus,
    this.initialHasReachedMax = false,
    required this.onLoadMore,
    this.config = const EnhancedConfig(),
    this.direction = EnhancedViewDirection.forward,
    this.onRefresh,
    this.refreshBuilder,
    this.controller,
    this.useSlivers = false,
    this.itemExtent = 100.0,
    this.loadMoreThreshold = 200,
  });

  final List<int> initialData;
  final EnhancedStatus initialStatus;
  final bool initialHasReachedMax;
  final void Function(int page) onLoadMore;
  final EnhancedConfig config;
  final EnhancedViewDirection direction;
  final Future<void> Function()? onRefresh;
  final EnhancedRefreshBuilder<int>? refreshBuilder;
  final EnhancedPaginationController? controller;
  final bool useSlivers;
  final double itemExtent;
  final double loadMoreThreshold;

  @override
  State<PaginationHarness> createState() => PaginationHarnessState();
}

class PaginationHarnessState extends State<PaginationHarness> {
  late List<int> data = List<int>.of(widget.initialData);
  late EnhancedStatus status = widget.initialStatus;
  late bool hasReachedMax = widget.initialHasReachedMax;

  /// Mutates the simulated data source and rebuilds, mirroring what a real
  /// bloc/cubit listener would do in response to state changes.
  void emit({List<int>? data, EnhancedStatus? status, bool? hasReachedMax}) {
    setState(() {
      if (data != null) this.data = data;
      if (status != null) this.status = status;
      if (hasReachedMax != null) this.hasReachedMax = hasReachedMax;
    });
  }

  @override
  Widget build(BuildContext context) {
    final EnhancedDelegate<int> delegate = EnhancedDelegate<int>(
      listOfData: data,
      status: status,
    );

    if (widget.useSlivers) {
      return EnhancedPaginatedView<int>.slivers(
        delegate: delegate,
        config: widget.config,
        hasReachedMax: hasReachedMax,
        onLoadMore: widget.onLoadMore,
        controller: widget.controller,
        direction: widget.direction,
        onRefresh: widget.onRefresh,
        refreshBuilder: widget.refreshBuilder,
        loadMoreThreshold: widget.loadMoreThreshold,
        builder: (BuildContext context, List<int> items) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) => SizedBox(
                key: ValueKey<String>('item-$index-${items[index]}'),
                height: widget.itemExtent,
                child: Text('item-${items[index]}'),
              ),
              childCount: items.length,
            ),
          );
        },
      );
    }

    return EnhancedPaginatedView<int>(
      delegate: delegate,
      config: widget.config,
      hasReachedMax: hasReachedMax,
      onLoadMore: widget.onLoadMore,
      controller: widget.controller,
      direction: widget.direction,
      onRefresh: widget.onRefresh,
      refreshBuilder: widget.refreshBuilder,
      loadMoreThreshold: widget.loadMoreThreshold,
      builder: (
        List<int> items,
        ScrollPhysics physics,
        bool reverse,
        bool shrinkWrap,
      ) {
        return ListView.builder(
          physics: physics,
          reverse: reverse,
          shrinkWrap: shrinkWrap,
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) => SizedBox(
            key: ValueKey<String>('item-$index-${items[index]}'),
            height: widget.itemExtent,
            child: Text('item-${items[index]}'),
          ),
        );
      },
    );
  }
}

/// Wraps [child] in a [MaterialApp] + [Scaffold] with a bounded viewport, as
/// [EnhancedPaginatedView] expects to be laid out within finite constraints.
Widget wrapInApp(Widget child, {double height = 400, double width = 300}) {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: SizedBox(
          height: height,
          width: width,
          child: child,
        ),
      ),
    ),
  );
}
