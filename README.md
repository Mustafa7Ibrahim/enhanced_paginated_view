# Enhanced Paginated View

Enhanced Paginated View is an unopinionated, extensible, and highly customizable package that provides a widget for lazy loading and displaying small chunks of items as the user scrolls down the screen. It is commonly used for implementing features like endless scrolling pagination, auto-pagination, lazy loading pagination, and progressive loading pagination.

Designed to feel like part of the Flutter framework.


<img src="https://github.com/Mustafa7Ibrahim/enhanced_paginated_view/blob/master/assets/bloc.gif" alt="Example Project" />

| Vanilla      | Bloc         |
|--------------|--------------|
| Content Cell | Content Cell |


## Features

- **Pagination Loading**: The package includes a loading widget that is displayed at the bottom of the list when new items are being loaded, giving visual feedback to the user.
- **Automatic Loading**: When the user reaches the end of the list, the package triggers the onLoadMore callback, allowing developers to fetch and load the next page of data.
- **Max Reached**: The package provides an option to set the isMaxReached flag, which stops the loading widget from showing when the end of the list is reached.
- **Header Widget**: Developers can add a header widget at the top of the list to display additional information or custom UI elements.
- **Empty Widget**: When the list is empty, developers can provide a custom widget to display a message or any other desired content.
- **Customizable Builder Function**: The builder function allows developers to build the widget using their own preferred widget, such as ListView, GridView, or any other widget that fits their requirements.
  Scroll Physics Control: The builder function provides the flexibility to customize the scroll physics for the widget, controlling the scrolling behavior.

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

there are 3 things you need to make for the package to work fine

1- `physics`: this parameter need to set as `NeverScrollableScrollPhysics()` or just sample pass the physics that the **builder** provide.

2- `shrinkWrap`: this parameter need to set to true or just pass the one that the **builder** provide.

3- `items`: this is the list of T that you previously pass when you declare the widget.

here is an example for the builder parameter

```dart
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
  final maxItems = 50;
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
          isLoadingState: isLoading,
          isMaxReached: isMaxReached,
          onLoadMore: loadMore,
          loadingWidget: const Center(child: CircularProgressIndicator()),
          header: Center(
            child: Padding(
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
          ),
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
      ),
    );
  }
}
```

For bloc usage examples, please take a look at our [bloc example](https://github.com/Mustafa7Ibrahim/enhanced_paginated_view/tree/master/example/lib/bloc_example).
