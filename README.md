# Enhanced Paginated View

Enhanced Paginated View is an unopinionated, extensible, and highly customizable package that provides a widget for lazy loading and displaying small chunks of items as the user scrolls down the screen. It is commonly used for implementing features like endless scrolling pagination, auto-pagination, lazy loading pagination, and progressive loading pagination.

Designed to feel like part of the Flutter framework.



| Vanilla                                                                                                                             | Bloc         |
|-------------------------------------------------------------------------------------------------------------------------------------|--------------|
| <img src="https://github.com/Mustafa7Ibrahim/enhanced_paginated_view/blob/master/assets/vanilla.gif?raw=true" alt="bloc Project" /> | <img src="https://github.com/Mustafa7Ibrahim/enhanced_paginated_view/blob/master/assets/bloc.gif?raw=true" alt="bloc Project" />|


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
          isLoadingState: isLoading,
          isMaxReached: isMaxReached,
          onLoadMore: loadMore,
          loadingWidget: const Center(child: CircularProgressIndicator()),

          /// [showErrorWidget] is a boolean that will be used
          /// to control the error widget
          /// this boolean will be set to true when an error occurs
          showErrorWidget: false,
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
          emptyWidget: const Center(child: Text('No items found')),
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
          reverse: false,
          builder: (physics, items, shrinkWrap, chatMode) {
            return ListView.separated(
              // here we must pass the physics, items and shrinkWrap
              // that came from the builder function
              reverse: chatMode,
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


## Bloc Usage

**States**

The `state` is divided into two parts:

- `PaginatedStatus`: An enum class that contains different view statuses.

- `PaginatedState`: A class that holds all the necessary data for state management.

```dart
enum PaginatedStatus { initial, loading, loaded, error }
```

```dart
final class PaginatedState extends Equatable {
  const PaginatedState({
    this.status = PaginatedStatus.initial,
    this.listOfData = const [],
    this.isMaxReached = false,
    this.error,
  });

  final PaginatedStatus status;
  final List<int> listOfData;
  final bool isMaxReached;
  final String? error;

  /// copyWith method is used to copy the current state
  /// and update the required fields.
  PaginatedState copyWith({
    PaginatedStatus? status,
    List<int>? listOfData,
    bool? isMaxReached,
    String? error,
  }) {
    return PaginatedState(
      status: status ?? this.status,
      listOfData: listOfData ?? this.listOfData,
      isMaxReached: isMaxReached ?? this.isMaxReached,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [
        listOfData,
        isMaxReached,
        error ?? '',
        status,
      ];
}
```

**Events**

There's a single event to manage the view:

- `FetchDataEvent`: Carries a `page` parameter to load the next page. This parameter is provided by the `EnhancedPaginatedView` widget.
```dart
class FetchDataEvent extends PaginatedEvent {
  const FetchDataEvent({this.page = 1});

  final int page;

  @override
  List<Object> get props => [page];
}
```

**Bloc**

The `bloc` is the central component of the package, responsible for handling view logic and state.

- Private parameters:
  - `_isMaxReached`: Indicates if the last page has been reached.
  - `_maxPageNumber`: Simulated last page number.
  - `_listOfData`: Holds the loaded data for each page.
```dart
  bool _isMaxReached = false;
  final int _maxPageNumber = 5;
  final List<int> _listOfData = [];
 ```

- Private method `_fetchData` handles the `FetchDataEvent`:
  - Accepts the page from the event.
  - If page is less than _maxPageNumber, adds 10 new items to _listOfData and emits the new state.
  - If page equals _maxPageNumber, sets _isMaxReached to true and emits the new state.
  - Simulates loading new items using Future.delayed for 3 seconds.
  - Simulates an error for page equal to 3 by emitting an error state.
  - Otherwise, emits the new state with the updated data.
  

```dart
/// fetch data
Future<void> _fetchData(
        FetchDataEvent event,
        Emitter<PaginatedState> emit,
        ) async {
  if (state.status != PaginatedStatus.initial) {
    emit(state.copyWith(status: PaginatedStatus.loading));
  }
  await Future.delayed(
    const Duration(seconds: 3),
            () {
      if (event.page == 3) {
        emit(state.copyWith(status: PaginatedStatus.error, error: 'Error'));
        return;
      }
      _isMaxReached = _maxPageNumber <= event.page;
      _listOfData.addAll(List<int>.generate(10, (index) => index + 1));
      emit(
        state.copyWith(
          status: PaginatedStatus.loaded,
          listOfData: _listOfData,
          isMaxReached: _isMaxReached,
        ),
      );
    },
  );
}
```

**View**

Here's the view responsible for displaying the results and handling different states.


```dart
class BlocView extends StatefulWidget {
  const BlocView({super.key});

  @override
  State<BlocView> createState() => _BlocViewState();
}

class _BlocViewState extends State<BlocView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bloc Example')),
      body: BlocProvider(
        create: (context) => PaginatedBloc()..add(const FetchDataEvent()),
        child: BlocBuilder<PaginatedBloc, PaginatedState>(
          builder: (context, state) {
            if (state.status == PaginatedStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }
            return SafeArea(
              child: EnhancedPaginatedView<int>(
                listOfData: state.listOfData,
                showLoading: state.status == PaginatedStatus.loading,
                showError: state.status == PaginatedStatus.error,
                isMaxReached: state.isMaxReached,
                onLoadMore: (page) {
                  context.read<PaginatedBloc>().add(FetchDataEvent(page: page));
                },
                loadingWidget: const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (page) => Column(
                  children: [
                    Center(child: Text(' ${state.error}')),
                    ElevatedButton(
                      onPressed: () {
                        context
                                .read<PaginatedBloc>()
                                .add(FetchDataEvent(page: page));
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
                builder: (physics, items, shrinkWrap, chatMode) {
                  return ListView.separated(
                    // here we must pass the physics, items and shrinkWrap
                    // that came from the builder function
                    physics: physics,
                    shrinkWrap: shrinkWrap,
                    itemCount: items.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(height: 16);
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
            );
          },
        ),
      ),
    );
  }
}
```


For more examples of bloc usage, refer to our [bloc example](https://github.com/Mustafa7Ibrahim/enhanced_paginated_view/tree/master/example/lib/bloc_example).
