import 'package:enhanced_paginated_view/enhanced_paginated_view.dart';
import 'package:example/modules/list_view/bloc/paginated_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GridSliverBloc extends StatelessWidget {
  const GridSliverBloc({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaginatedBloc()..add(const FetchDataEvent()),
      child: BlocBuilder<PaginatedBloc, PaginatedState>(
        builder: (context, state) {
          if (state.status == PaginatedStatus.initLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == PaginatedStatus.initError) {
            return PageFailureWidget(
              pageFailureModel: PageFailureModel(
                description: state.error,
                onRetry: () {
                  context.read<PaginatedBloc>().add(const FetchDataEvent());
                },
              ),
            );
          }
          return EnhancedPaginatedView<String>.slivers(
            delegate: EnhancedDelegate(
              listOfData: state.data,
              showLoading: state.status == PaginatedStatus.loading,
              showError: state.status == PaginatedStatus.error,
            ),
            itemsPerPage: 10,
            isMaxReached: state.hasReachedMax,
            onLoadMore: (page) {
              context.read<PaginatedBloc>().add(FetchDataEvent(page: page));
            },
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
                          'sliver Index: $index',
                          style: const TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
