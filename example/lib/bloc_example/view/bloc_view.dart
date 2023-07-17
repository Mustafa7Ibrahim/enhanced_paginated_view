import 'package:enhanced_paginated_view/enhanced_paginated_view.dart';
import 'package:example/bloc_example/bloc/paginated_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocView extends StatefulWidget {
  const BlocView({super.key});

  @override
  State<BlocView> createState() => _BlocViewState();
}

class _BlocViewState extends State<BlocView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bloc Example'),
      ),
      body: BlocProvider(
        create: (context) => PaginatedBloc()..add(const FetchDataEvent()),
        child: BlocBuilder<PaginatedBloc, PaginatedState>(
          builder: (context, state) {
            switch (state) {
              case PaginatedLoading():
                return const Center(child: CircularProgressIndicator());
              case PaginatedLoaded():
                return ListOfData(
                  listOfData: state.listOfData,
                  isLoading: state.isLoading,
                  isMaxReached: state.isMaxReached,
                );
            }
          },
        ),
      ),
    );
  }
}

class ListOfData extends StatelessWidget {
  const ListOfData({
    required this.listOfData,
    required this.isLoading,
    required this.isMaxReached,
    super.key,
  });

  final List<int> listOfData;
  final bool isMaxReached;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: EnhancedPaginatedView<int>(
        listOfData: listOfData,
        isLoadingState: isLoading,
        isMaxReached: isMaxReached,
        onLoadMore: (page) => context.read<PaginatedBloc>()
          ..add(NewDataEvent(listOfData: listOfData, page: page)),
        loadingWidget: const Center(child: CircularProgressIndicator()),
        builder: (physics, items, shrinkWrap) {
          return ListView.separated(
            // here we must pass the physics, items and shrinkWrap
            // that came from the builder function
            physics: physics,
            shrinkWrap: shrinkWrap,
            itemCount: items.length,
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(
                height: 16,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text('Item ${index + 1}'),
                subtitle: Text('Item ${items[index]}'),
              );
            },
          );
        },
      ),
    );
  }
}
