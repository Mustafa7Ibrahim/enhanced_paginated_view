import 'package:enhanced_paginated_view/enhanced_paginated_view.dart';
import 'package:example/core/bloc/paginated_bloc.dart';
import 'package:example/widgets/header_widget.dart';
import 'package:example/widgets/list_view_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocListExample extends StatelessWidget {
  const BlocListExample({super.key, this.failPage});
  final int? failPage;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PaginatedBloc()..add(FetchDataEvent(failPage: failPage)),
      child: BlocBuilder<PaginatedBloc, PaginatedState>(
        builder: (context, state) {
          return EnhancedPaginatedView<String>(
            delegate: EnhancedDelegate(
              listOfData: state.data,
              status: state.status,
              header: const HeaderWidget(),
              errorPageConfig: ErrorPageConfig(
                onRetry: () => context
                    .read<PaginatedBloc>()
                    .add(const FetchDataEvent(page: 1)),
              ),
              errorLoadMoreConfig: ErrorLoadMoreConfig(
                onRetry: (page) => context
                    .read<PaginatedBloc>()
                    .add(FetchDataEvent(page: page)),
              ),
            ),
            itemsPerPage: 10,
            hasReachedMax: state.hasReachedMax,
            onLoadMore: (page) {
              context
                  .read<PaginatedBloc>()
                  .add(FetchDataEvent(page: page, failPage: failPage));
            },
            builder: (items, physics, _, shrinkWrap) {
              return ListView.separated(
                // here we must pass the physics, items and shrinkWrap
                // that came from the builder function
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
        },
      ),
    );
  }
}
