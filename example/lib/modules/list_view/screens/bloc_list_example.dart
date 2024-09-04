import 'package:enhanced_paginated_view/enhanced_paginated_view.dart';
import 'package:example/modules/list_view/bloc/paginated_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocListExample extends StatefulWidget {
  const BlocListExample({super.key});

  @override
  State<BlocListExample> createState() => _BlocListExampleState();
}

class _BlocListExampleState extends State<BlocListExample> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaginatedBloc()..add(const FetchDataEvent()),
      child: BlocBuilder<PaginatedBloc, PaginatedState>(
        builder: (context, state) {
          if (state.status == PaginatedStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }
          return EnhancedPaginatedView<String>(
            delegate: EnhancedDelegate(
              listOfData: state.listOfData,
              showLoading: state.status == PaginatedStatus.loading,
              showError: state.status == PaginatedStatus.error,
              errorWidget: (page) => Column(
                children: [
                  Center(child: Text(' ${state.error}')),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<PaginatedBloc>()
                          .add(FetchDataEvent(page: page));
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            itemsPerPage: 10,
            isMaxReached: state.isMaxReached,
            onLoadMore: (page) {
              context.read<PaginatedBloc>().add(FetchDataEvent(page: page));
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
                  return ListTile(
                    title: Text('Item ${items[index]}'),
                    subtitle: Text('Item ${index + 1}'),
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
