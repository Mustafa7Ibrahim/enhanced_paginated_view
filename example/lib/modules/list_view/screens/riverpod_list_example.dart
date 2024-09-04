import 'package:enhanced_paginated_view/enhanced_paginated_view.dart';
import 'package:example/modules/list_view/riverpod/list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RiverpodListExample extends ConsumerWidget {
  const RiverpodListExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(listPProvider);
    return switch (state.status) {
      PaginatedStatus.error => const Center(
          child: Text('An error occurred'),
        ),
      PaginatedStatus.initial => const Center(
          child: CircularProgressIndicator(),
        ),
      _ => EnhancedPaginatedView(
          delegate: EnhancedDelegate(
            listOfData: state.listOfData,
            showError: state.status == PaginatedStatus.error,
            showLoading: state.status == PaginatedStatus.loading,
          ),
          isMaxReached: state.isMaxReached,
          onLoadMore: (page) {
            ref.read(listPProvider.notifier).fetchData(page);
          },
          builder: (items, physics, reverse, shrinkWrap) {
            return ListView.separated(
              physics: physics,
              shrinkWrap: shrinkWrap,
              itemCount: items.length,
              separatorBuilder: (__, _) => const Divider(height: 16),
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text('Item ${items[index]}'),
                  subtitle: Text('Item ${index + 1}'),
                );
              },
            );
          },
        ),
    };
  }
}
