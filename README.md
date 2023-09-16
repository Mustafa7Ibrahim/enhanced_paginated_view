# Enhanced Paginated View

Enhanced Paginated View is an unopinionated, extensible, and highly customizable package that provides a widget for lazy loading and displaying small chunks of items as the user scrolls down the screen. It is commonly used for implementing features like endless scrolling pagination, auto-pagination, lazy loading pagination, and progressive loading pagination.

Designed to feel like part of the Flutter framework.

| Vanilla                                                                                                                         | Bloc                                                                                                                         |
| ------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| <img src="https://github.com/Mustafa7Ibrahim/enhanced_paginated_view/blob/main/assets/vanilla.gif?raw=true" alt="bloc Project"> | <img src="https://github.com/Mustafa7Ibrahim/enhanced_paginated_view/blob/main/assets/bloc.gif?raw=true" alt="bloc Project"> |

## Documentation

- [Basic Documentation](https://github.com/Mustafa7Ibrahim/enhanced_paginated_view/blob/master/README.md)
- [Bloc Documentation](https://github.com/Mustafa7Ibrahim/enhanced_paginated_view/blob/master/doc/bloc_doc.md)

## Examples

- [Basic example](https://github.com/Mustafa7Ibrahim/enhanced_paginated_view/blob/master/example/lib/main.dart)
- [bloc example](https://github.com/Mustafa7Ibrahim/enhanced_paginated_view/blob/master/example/lib/bloc_example/view/bloc_view.dart).

## Features

- **Pagination Loading**: The package includes a loading widget that is displayed at the bottom of the list when new items are being loaded, giving visual feedback to the user.
- **Automatic Loading**: When the user reaches the end of the list, the package triggers the onLoadMore callback, allowing developers to fetch and load the next page of data.
- **Max Reached**: The package provides an option to set the isMaxReached flag, which stops the loading widget from showing when the end of the list is reached.
- **Header Widget**: Developers can add a header widget at the top of the list to display additional information or custom UI elements.
- **Empty Widget**: When the list is empty, developers can provide a custom widget to display a message or any other desired content.
- **Customizable Builder Function**: The builder function allows developers to build the widget using their own preferred widget, such as ListView, GridView, or any other widget that fits their requirements.
  Scroll Physics Control: The builder function provides the flexibility to customize the scroll physics for the widget, controlling the scrolling behavior.
- **Reverse**: The builder function provides the flexibility to reverse the list and its children, which is useful when building a chat app, for example, and you want to reverse the list to show the latest messages.
- **Remove Deduplication** : The package provides an option to set the shouldDeduplicate flag, which removes duplicate items from the list.

## New Features in Version 1.0.5

We're excited to introduce some exciting enhancements in this latest release of our package, version 1.0.5. These improvements aim to make your experience smoother and more efficient:

### 1. Accurate Page Number Calculation

We've added a new property called `itemsPerPage`, which allows for more precise page number calculations. The default value for this property is set to 15. This enhancement ensures that your pagination logic works seamlessly.

### 2. Deduplication for Cleaner Lists

In response to user feedback, we've introduced the `shouldDeduplicate` property, which is set to `true` by default. This feature comes in handy when dealing with lists that may contain duplicate items due to multiple delete or update operations. It automatically removes duplicate items from the list when requesting the next page, keeping your data clean and clutter-free.

### Manual Deduplication with `enhancedDeduplication()`

For those who prefer more control over deduplication, we offer the `enhancedDeduplication()` extension method. You can use this method to remove duplicate items from your list manually. Here's an example of how to use it:

```dart
final list = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

// Here, we remove the duplicate items from the list
final result = list.enhancedDeduplication();
print(result);

// Result:
// [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
```

This feature is particularly useful when you want to customize the `onLoadMore` function and need to remove duplicate items from the list before fetching the next page.

## Usage

**header**: is a widget that will be displayed at the top of the list. some times we need to display some information or custom UI elements at the top of the list, so we can use this property to do that.

here is the example of the header parameter

```dart
header: Padding(
  padding: const EdgeInsets.all(8.0),
  child: Column(
    children: [
      Text(
        'Header Title',
        style: Theme.of(context).textLarge,
      ),
      Text(
        'Header subtitle',
        style: Theme.of(context).textLarge,
      ),
    ],
  ),
),
```

**builder**: is the builder where you put any kind of paginated view like `ListView`of `GrideView`or any list widget you can find.

there are 4 things you need to make for the package to work fine

1- `physics`: this parameter need to set as `NeverScrollableScrollPhysics()` or just sample pass the physics that the **builder** provide.

2- `shrinkWrap`: this parameter need to set to true or just pass the one that the **builder** provide.

3- `items`: this is the list of T that you previously pass when you declare the widget.

4- `reverse`: this is a boolean that will be used to reverse the list and its children it code be handy when you are building a chat app for example and you want to reverse the list to show the latest messages.

here is an example for the builder parameter

```dart
builder: (physics, items, shrinkWrap, reverse) {
  return ListView.separated(
    // here we must pass the physics, items and shrinkWrap
    // that came from the builder function
    physics: physics,
    shrinkWrap: shrinkWrap,
    itemCount: items.length,
    reverse: reverse,
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
```

Here is a full example of how to use the package:

```dart

class VanillaView extends StatefulWidget {
  const VanillaView({super.key});

  @override
  State<VanillaView> createState() => _VanillaViewState();
}

class _VanillaViewState extends State<VanillaView> {
  final initList = List<int>.generate(10, (int index) => index);
  bool isLoading = false;
  final maxItems = 30;
  bool isMaxReached = false;

  Future<void> loadMore(int page) async {
    // here we simulate that the list reached the end
    // and we set the isMaxReached to true to stop
    // the loading widget from showing
    if (initList.length >= maxItems) {
      setState(() => isMaxReached = true);
      return;
    }
    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 3));
    // here we simulate the loading of new items
    // from the server or any other source
    // we pass the page number to the onLoadMore function
    // that the package provide to load the next page
    setState(() {
      initList.addAll(List<int>.generate(10, (int index) => index));
      isLoading = false;
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
          loadingWidget: const Center(child: CircularProgressIndicator()),

          /// [showErrorWidget] is a boolean that will be used
          /// to control the error widget
          /// this boolean will be set to true when an error occurs
          showError: false,
          errorWidget: (page) => Center(
            child: Column(
              children: [
                const Text('No items found'),
                ElevatedButton(
                  onPressed: () => loadMore(page),
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
```

## License

``` text
MIT License

Copyright (c) 2023 Mustafa Ibrahim.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## Author

- [Mustafa Ibrahim](https://github.com/Mustafa7Ibrahim)
