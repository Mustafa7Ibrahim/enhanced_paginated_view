import 'package:enhanced_paginated_view/enhanced_paginated_view.dart';
import 'package:example/bloc_example/view/bloc_view.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Enhanced Paginated View',
      home: VanillaView(),
    );
  }
}

class VanillaView extends StatefulWidget {
  const VanillaView({super.key});

  @override
  State<VanillaView> createState() => _VanillaViewState();
}

class _VanillaViewState extends State<VanillaView> {
  final initList = List<int>.generate(10, (int index) => index);
  bool isLoading = false;
  final maxItems = 100;
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
          initList.addAll(List<int>.generate(10, (int index) => index));
          isLoading = false;
        },
      ),
    );
  }

  /// remove an item from the list
  void removeItem(int index) {
    setState(() {
      initList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vanilla Example'),
      ),
      body: SafeArea(
        child: EnhancedPaginatedView<int>(
          listOfData: initList,
          showLoading: isLoading,
          isMaxReached: isMaxReached,
          onLoadMore: loadMore,

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
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const BlocView(),
                      ),
                    );
                  },
                  child: const Text('Bloc Example'),
                ),
              ],
            ),
          ),

          /// the `reverse` parameter is a boolean that will be used
          /// to reverse the list and its children
          /// it code be handy when you are building a chat app for example
          /// and you want to reverse the list to show the latest messages

          builder: (physics, items, shrinkWrap, reverse) {
            return ListView.separated(
              // here we must pass the physics, items and shrinkWrap
              // that came from the builder function
              reverse: reverse,
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
                  onTap: () => removeItem(index),
                  title: Text('Item ${index + 1}'),
                  subtitle: Text('Item ${items[index]}'),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
