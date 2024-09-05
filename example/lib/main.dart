import 'package:enhanced_paginated_view/enhanced_paginated_view.dart';
import 'package:example/core/fake_date.dart';
import 'package:example/nav_bar.dart';
import 'package:example/widgets/header_widget.dart';
import 'package:example/widgets/list_view_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Enhanced Paginated View', home: NavBar());
  }
}

class VanillaListExample extends StatefulWidget {
  const VanillaListExample({super.key});

  @override
  State<VanillaListExample> createState() => _VanillaListExampleState();
}

class _VanillaListExampleState extends State<VanillaListExample> {
  final initList = [];
  final maxItems = 30;
  EnhancedStatus status = EnhancedStatus.loaded;
  bool isMaxReached = false;

  Future<void> loadMore(int page) async {
    // here we simulate that the list reached the end
    // and we set the isMaxReached to true to stop
    // the loading widget from showing
    if (initList.length >= maxItems) {
      setState(() => isMaxReached = true);
      return;
    }
    setState(() => status = EnhancedStatus.loading);
    await Future.delayed(
      const Duration(seconds: 1),
      () {
        setState(() {
          if (page == 2) {
            initList.addAll(items2);
          }
          if (page == 3) {
            initList.addAll(items3);
          }
          status = EnhancedStatus.loaded;
        });
      },
    );
  }

  /// remove an item from the list
  void removeItem(int index) => setState(() => initList.removeAt(index));

  @override
  void initState() {
    super.initState();
    initList.addAll(item1);
  }

  @override
  Widget build(BuildContext context) {
    return EnhancedPaginatedView(
      delegate: EnhancedDelegate(
        listOfData: initList,
        status: status,
        header: const HeaderWidget(),
      ),
      hasReachedMax: isMaxReached,
      onLoadMore: loadMore,
      itemsPerPage: 10,
      builder: (items, physics, reverse, shrinkWrap) {
        return ListView.separated(
          physics: physics,
          shrinkWrap: shrinkWrap,
          reverse: reverse,
          itemCount: items.length,
          separatorBuilder: (__, _) => const Divider(height: 16),
          itemBuilder: (BuildContext context, int index) {
            return ListViewItem(item: items[index], index: index);
          },
        );
      },
    );
  }
}
