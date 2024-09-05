import 'package:enhanced_paginated_view/enhanced_paginated_view.dart';
import 'package:example/core/bloc/paginated_bloc.dart';
import 'package:example/widgets/grid_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GridBloc extends StatelessWidget {
  const GridBloc({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaginatedBloc()..add(const FetchDataEvent()),
      child: BlocBuilder<PaginatedBloc, PaginatedState>(
        builder: (context, state) {
          return EnhancedPaginatedView<String>(
            delegate: EnhancedDelegate(
              listOfData: state.data,
              status: state.status,
            ),
            itemsPerPage: 10,
            hasReachedMax: state.hasReachedMax,
            onLoadMore: (page) {
              context.read<PaginatedBloc>().add(FetchDataEvent(page: page));
            },
            builder: (items, physics, _, shrinkWrap) {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                padding: const EdgeInsets.all(16),
                physics: physics,
                shrinkWrap: shrinkWrap,
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  return GridWidget(item: items[index], index: index);
                },
              );
            },
          );
        },
      ),
    );
  }
}
