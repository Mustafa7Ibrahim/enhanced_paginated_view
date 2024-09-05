import 'package:enhanced_paginated_view/enhanced_paginated_view.dart';
import 'package:example/core/riverpod/list_provider.dart';
import 'package:example/widgets/grid_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GridRiverpod extends ConsumerWidget {
  const GridRiverpod({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(listPProvider());
    return EnhancedPaginatedView(
      delegate: EnhancedDelegate(
        listOfData: state.data,
        status: state.status,
      ),
      hasReachedMax: state.hasReachedMax,
      onLoadMore: (page) {
        ref.read(listPProvider().notifier).fetchData(page);
      },
      itemsPerPage: 10,
      builder: (items, physics, reverse, shrinkWrap) {
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          physics: physics,
          shrinkWrap: shrinkWrap,
          itemCount: items.length,
          padding: const EdgeInsets.all(16),
          itemBuilder: (BuildContext context, int index) {
            return GridWidget(item: items[index], index: index);
          },
        );
      },
    );
  }
}
