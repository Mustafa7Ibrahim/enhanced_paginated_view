import 'package:enhanced_paginated_view/enhanced_paginated_view.dart';
import 'package:example/core/riverpod/list_provider.dart';
import 'package:example/widgets/header_widget.dart';
import 'package:example/widgets/list_view_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RiverpodListExample extends ConsumerWidget {
  const RiverpodListExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(listPProvider());
    return EnhancedPaginatedView(
      delegate: EnhancedDelegate(
        listOfData: state.data,
        status: state.status,
        header: const HeaderWidget(),
      ),
      isMaxReached: state.hasReachedMax,
      onLoadMore: ref.read(listPProvider().notifier).fetchData,
      itemsPerPage: 10,
      builder: (items, physics, reverse, shrinkWrap) {
        return ListView.separated(
          physics: physics,
          shrinkWrap: shrinkWrap,
          itemCount: items.length,
          separatorBuilder: (__, _) => const Divider(height: 16),
          itemBuilder: (BuildContext context, int index) {
            return ListViewItem(item: items[index], index: index);
          },
        );
      },
    );
  }
}
