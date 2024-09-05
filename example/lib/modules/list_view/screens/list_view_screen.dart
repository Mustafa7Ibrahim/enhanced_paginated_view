import 'package:example/main.dart';
import 'package:example/modules/list_view/screens/bloc_list_example.dart';
import 'package:example/modules/list_view/screens/riverpod_list_example.dart';
import 'package:flutter/material.dart';

class ListViewScreen extends StatelessWidget {
  const ListViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('List Example'),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              const Tab(text: 'VANILLA'),
              const Tab(text: 'BLOC'),
              const Tab(text: 'RIVERPOD'),
              Tab(text: 'Page Error'.toUpperCase()),
              Tab(text: 'Loading Error'.toUpperCase()),
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
          ],
        ),
      ),
    );
  }
}
