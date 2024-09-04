import 'package:enhanced_paginated_view/enhanced_paginated_view.dart';
import 'package:example/core/fake_date.dart';
import 'package:example/nav_bar.dart';
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
    return const MaterialApp(
      title: 'Enhanced Paginated View',
      home: NavBar(),
    );
  }
}

class VanillaListExample extends StatefulWidget {
  const VanillaListExample({super.key});

  @override
  State<VanillaListExample> createState() => _VanillaListExampleState();
}

class _VanillaListExampleState extends State<VanillaListExample> {
  final initList = [];
  bool isLoading = false;
  final maxItems = 30;
  bool isMaxReached = false;
  bool showError = false;

  Future<void> loadMore(int page) async {
    // here we simulate that the list reached the end
    // and we set the isMaxReached to true to stop
    // the loading widget from showing
    if (initList.length >= maxItems) {
      setState(() => isMaxReached = true);
      return;
    }
    Future.microtask(() => setState(() => isLoading = true));
    await Future.delayed(const Duration(seconds: 3));
    // here we simulate the loading of new items
    // from the server or any other source
    // we pass the page number to the onLoadMore function
    // that the package provide to load the next page
    Future.microtask(
      () => setState(
        () {
          if (page == 5) {
            showError = true;
            isLoading = false;
            return;
          }
          if (page == 1) {
            initList.addAll(item1);
          }
          if (page == 2) {
            initList.addAll(items2);
          }
          if (page == 3) {
            initList.addAll(items3);
          }
          isLoading = false;
        },
      ),
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
        showLoading: isLoading,

        /// [showError] is a boolean that will be used
        /// to control the error widget
        /// this boolean will be set to true when an error occurs
        showError: showError,
        errorWidget: (page) => Center(
          child: Column(
            children: [
              const Text('No items found'),
              ElevatedButton(
                onPressed: () {
                  showError = false;
                  loadMore(page);
                },
                child: const Text('Reload'),
              )
            ],
          ),
        ),
        header: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                'Header',
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ],
          ),
        ),
      ),

      isMaxReached: isMaxReached,
      onLoadMore: loadMore,
      itemsPerPage: 10,

      /// the `reverse` parameter is a boolean that will be used
      /// to reverse the list and its children
      /// it code be handy when you are building a chat app for example
      /// and you want to reverse the list to show the latest messages

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
              onTap: () => removeItem(index),
              title: Text('Item ${items[index]}'),
              subtitle: Text('Item ${index + 1}'),
            );
          },
        );
      },
    );
  }
}
