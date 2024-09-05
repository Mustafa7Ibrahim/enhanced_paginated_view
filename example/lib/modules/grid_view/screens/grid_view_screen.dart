import 'package:example/modules/grid_view/screens/grid_bloc.dart';
import 'package:example/modules/grid_view/screens/grid_riverpod.dart';
import 'package:example/modules/grid_view/screens/grid_sliver_bloc.dart';
import 'package:example/modules/grid_view/screens/grid_sliver_riverpod.dart';
import 'package:flutter/material.dart';

class GridViewScreen extends StatelessWidget {
  const GridViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Grid Example'),
          bottom: const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: 'BLOC'),
              Tab(text: 'BLOC SLIVER'),
              Tab(text: 'RIVERPOD'),
              Tab(text: 'RIVERPOD SLIVER'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            GridBloc(),
            GridSliverBloc(),
            GridRiverpod(),
            GridSliverRiverpod(),
          ],
        ),
      ),
    );
  }
}
