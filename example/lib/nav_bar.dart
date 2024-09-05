import 'package:enhanced_paginated_view/enhanced_paginated_view.dart';
import 'package:example/main.dart';
import 'package:example/modules/grid_view/screens/grid_bloc.dart';
import 'package:example/modules/grid_view/screens/grid_riverpod.dart';
import 'package:example/modules/grid_view/screens/grid_sliver_bloc.dart';
import 'package:example/modules/grid_view/screens/grid_sliver_riverpod.dart';
import 'package:example/modules/list_view/screens/bloc_list_example.dart';
import 'package:example/modules/list_view/screens/riverpod_list_example.dart';
import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text(
                'Enhanced Paginated View',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            ListTile(
              title: const Text('Vanilla List Example'),
              onTap: () => setState(() {
                currentPageIndex = 0;
                Navigator.pop(context);
              }),
            ),
            ListTile(
              title: const Text('Bloc List Example'),
              onTap: () => setState(() {
                currentPageIndex = 1;
                Navigator.pop(context);
              }),
            ),
            ListTile(
              title: const Text('Riverpod List Example'),
              onTap: () => setState(() {
                currentPageIndex = 2;
                Navigator.pop(context);
              }),
            ),
            ListTile(
              title: const Text('Bloc List Example Fail Page 1'),
              onTap: () => setState(() {
                currentPageIndex = 3;
                Navigator.pop(context);
              }),
            ),
            ListTile(
              title: const Text('Bloc List Example Fail Page 2'),
              onTap: () => setState(() {
                currentPageIndex = 4;
                Navigator.pop(context);
              }),
            ),
            ListTile(
              title: const Text('Bloc List Example Empty'),
              onTap: () => setState(() {
                currentPageIndex = 5;
                Navigator.pop(context);
              }),
            ),
            ListTile(
              title: const Text('Bloc List Example Reverse'),
              onTap: () => setState(() {
                currentPageIndex = 6;
                Navigator.pop(context);
              }),
            ),
            ListTile(
              title: const Text('Grid Bloc'),
              onTap: () => setState(() {
                currentPageIndex = 7;
                Navigator.pop(context);
              }),
            ),
            ListTile(
              title: const Text('Grid Sliver Bloc'),
              onTap: () => setState(() {
                currentPageIndex = 8;
                Navigator.pop(context);
              }),
            ),
            ListTile(
              title: const Text('Grid Riverpod'),
              onTap: () => setState(() {
                currentPageIndex = 9;
                Navigator.pop(context);
              }),
            ),
            ListTile(
              title: const Text('Grid Sliver Riverpod'),
              onTap: () => setState(() {
                currentPageIndex = 10;
                Navigator.pop(context);
              }),
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: currentPageIndex,
        children: const [
          VanillaListExample(),
          BlocListExample(),
          RiverpodListExample(),
          BlocListExample(failPage: 1),
          BlocListExample(failPage: 2),
          BlocListExample(isEmpty: true),
          BlocListExample(direction: EnhancedViewDirection.reverse),
          GridBloc(),
          GridSliverBloc(),
          GridRiverpod(),
          GridSliverRiverpod(),
        ],
      ),
    );
  }
}
