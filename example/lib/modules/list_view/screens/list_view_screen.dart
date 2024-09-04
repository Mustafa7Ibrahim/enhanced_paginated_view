import 'package:example/main.dart';
import 'package:example/modules/list_view/screens/bloc_list_example.dart';
import 'package:example/modules/list_view/screens/riverpod_list_example.dart';
import 'package:flutter/material.dart';

class ListViewScreen extends StatelessWidget {
  const ListViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('List Example'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'VANILLA'),
              Tab(text: 'BLOC'),
              Tab(text: 'RIVERPOD'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            VanillaListExample(),
            BlocListExample(),
            RiverpodListExample(),
          ],
        ),
      ),
    );
  }
}
