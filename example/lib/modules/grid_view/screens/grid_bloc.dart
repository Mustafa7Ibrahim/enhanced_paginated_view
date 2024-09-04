import 'package:enhanced_paginated_view/enhanced_paginated_view.dart';
import 'package:example/modules/list_view/bloc/paginated_bloc.dart';
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
          return EnhancedPaginatedView<String>(
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
            builder: (items, physics, _, shrinkWrap) {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                // here we must pass the physics, items and shrinkWrap
                // that came from the builder function
                physics: physics,
                shrinkWrap: shrinkWrap,
                itemCount: items.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          items[index],
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
          );
        },
      ),
    );
  }
}
