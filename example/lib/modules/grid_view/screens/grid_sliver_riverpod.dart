import 'package:enhanced_paginated_view/enhanced_paginated_view.dart';
import 'package:example/modules/list_view/bloc/paginated_bloc.dart';
import 'package:example/modules/list_view/riverpod/list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GridSliverRiverpod extends ConsumerWidget {
  const GridSliverRiverpod({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(listPProvider);
    return switch (state.status) {
      PaginatedStatus.initError => const Center(
          child: Text('An error occurred'),
        ),
      PaginatedStatus.initLoading => const Center(
          child: CircularProgressIndicator(),
        ),
      _ => EnhancedPaginatedView.slivers(
          delegate: EnhancedDelegate(
            listOfData: state.data,
            showError: state.status == PaginatedStatus.error,
            showLoading: state.status == PaginatedStatus.loading,
          ),
          isMaxReached: state.hasReachedMax,
          onLoadMore: (page) {
            ref.read(listPProvider.notifier).fetchData(page);
          },
          itemsPerPage: 10,
          builder: (context, data) {
            return SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        data[index],
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        'Index: $index',
                        style: const TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                );
              },
            );
          },
        ),
    };
  }
}
