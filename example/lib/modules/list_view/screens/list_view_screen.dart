import 'package:enhanced_paginated_view/enhanced_paginated_view.dart';
import 'package:example/main.dart';
import 'package:example/modules/list_view/screens/bloc_list_example.dart';
import 'package:example/modules/list_view/screens/riverpod_list_example.dart';
import 'package:flutter/material.dart';

class ListViewScreen extends StatelessWidget {
  const ListViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('List Example'),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: 'VANILLA'.toUpperCase()),
              Tab(text: 'BLOC'.toUpperCase()),
              Tab(text: 'RIVERPOD'.toUpperCase()),
              Tab(text: 'Page Error'.toUpperCase()),
              Tab(text: 'Loading Error'.toUpperCase()),
              Tab(text: 'Empty'.toUpperCase()),
              Tab(text: 'Reversed'.toUpperCase()),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            VanillaListExample(),
            BlocListExample(),
            RiverpodListExample(),
            BlocListExample(failPage: 1),
            BlocListExample(failPage: 2),
            BlocListExample(isEmpty: true),
            BlocListExample(direction: EnhancedViewDirection.reverse),
          ],
        ),
      ),
    );
  }
}
