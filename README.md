##  Enhanced Paginated View


### Overview

The `EnhancedPaginatedView` package offers a flexible, highly customizable builder function that supports various scrollable widgets like `ListView`, `GridView`, or `Slivers`. With dynamic layout rendering and options for handling loading states, errors, and scroll behavior, it simplifies the implementation of paginated views. Whether using `box-based` or `sliver-based` layouts, it optimizes performance for large data sets while enhancing the user experience without the need to rewrite code for each widget.

| List View                                                                                                                              | Grid View                                                                                                                             |
| -------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| <img src="https://github.com/Mustafa7Ibrahim/enhanced_paginated_view/blob/main/assets/list_view_example.gif?raw=true" alt="List View"> | <img src="https://github.com/Mustafa7Ibrahim/enhanced_paginated_view/blob/main/assets/grid_view_example.gif?raw=true" alt="GridView"> |



### Features
- Supports box-based or sliver-based views for flexible UI layouts.
- Customizable scroll direction (forward or reverse).
- Integrated error handling and retry mechanisms.
- Customizable loading indicators.
- Support for infinite scrolling and manual pagination control.
- Delegate-based architecture for data handling.

### Getting Started

To use `EnhancedPaginatedView`, import the package into your Dart file:

```dart
import 'enhanced_paginated_view.dart';
```

### Usage

`EnhancedPaginatedView` can be used in two primary modes: box-based view and sliver-based view. You can choose the one that best fits your layout needs.

#### Box-Based View Example

```dart
EnhancedPaginatedView(
  onLoadMore: (int page) {
    // Load more data
  },
  hasReachedMax: false,
  itemsPerPage: 15,
  delegate: EnhancedDelegate(
    listOfData: yourDataList,
    status: EnhancedStatus.loaded,
  ),
  builder: (items, physics, reverse, shrinkWrap) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ListTile(title: Text(items[index].toString()));
      },
    );
  },
)
```

#### Sliver-Based View Example

```dart
return EnhancedPaginatedView.slivers(
  onLoadMore: (int page) {
    // Load more data
  },
  hasReachedMax: false,
  itemsPerPage: 15,
  delegate: EnhancedDelegate<YourDataType>(
    listOfData: yourDataList,
    status: EnhancedStatus.loaded,
  ),
  builder: (context, data) {
    return SliverGrid.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        return GridWidget(item: data[index], index: index);
      },
    );
  },
);
```

### Key Components

#### 1. EnhancedPaginatedView Widget

`EnhancedPaginatedView` is the primary widget in the package. It can be instantiated with either a box-based or sliver-based view.

##### Constructor Parameters:
- **onLoadMore (required)**: A callback function that is triggered when the user scrolls to the bottom of the list. It should accept an integer representing the current page number.
  
- **hasReachedMax (required)**: A boolean that controls whether the widget should load more items. If `true`, no more items will be loaded.
  
- **itemsPerPage**: An optional integer that sets how many items are loaded per page (default is 15).
  
- **delegate (required)**: An instance of `EnhancedDelegate` which provides data and configuration for the view.
  
- **builder (required)**: A function for building each scroll view. It should return a `ListView`, `GridView`, `SliverGrid` or any other scrollable widget.
  
- **direction**: Defines the scroll direction (default is `EnhancedViewDirection.forward`).

#### 2. EnhancedDelegate Class

`EnhancedDelegate` manages data and provides configuration options for the `EnhancedPaginatedView`.

##### Properties:
- **listOfData (required)**: A list of items of type `T` to be displayed.
- **status (required)**: An instance of `EnhancedStatus` which represents the current status (loading, loaded, or error).
- **physics**: Custom scroll physics (optional).
- **removeDuplicatedItems**: Boolean to remove duplicated items (optional, default is `true`).
- **scrollDirection**: Specifies the scroll direction, either `Axis.vertical` or `Axis.horizontal` (default is `Axis.vertical`).
- **crossAxisAlignment**: Defines the alignment of children along the cross-axis (default is `CrossAxisAlignment.center`).
- **header**: A widget to be displayed at the top of the list (optional).
- **emptyWidgetConfig**: Configuration for the empty state widget when no data is present.
- **loadingConfig**: Configuration for the loading widget.
- **errorPageConfig**: Configuration for the error page displayed on loading failure.
- **errorLoadMoreConfig**: Configuration for the error message when loading more items fails.

#### 3. Loading, Error, and Empty States

The package supports customizable UI components for loading, empty, and error states through the following configuration classes:

##### LoadingConfig
```dart
LoadingConfig(
  // Add custom loading indicator like shimmer 
  // or any other indicator you like that will show up in the first loading
  pageWidget: CircularProgressIndicator(),
  // Add custom loading indicator that will show every time the user reach the end of the list
  loadMoreWidget: CircularProgressIndicator(),
)
```


##### ErrorPageConfig
```dart
ErrorPageConfig(
  // to customize the pre defined error page 
  title: "Error loading data",
  description: "Something went wrong.",
  btnText: "Retry",
  onRetry: () => loadMore(1),
  customButton: CustomButton(),

  // to make your own custom view 
  customView: CustomErrorPageView()
)
```

###### Default Error Page

<img src="https://github.com/Mustafa7Ibrahim/enhanced_paginated_view/blob/main/assets/page_error.jpg?raw=true" alt="GridView" style="width: 400px;">


##### EmptyWidgetConfig
```dart
EmptyWidgetConfig(
  // To customize the default data in empty widget
  title: "No data found",
  svgIcon: "assets/icons/no_data.svg",

  // To make your own custom empty view.
  customView: CustomEmptyView(),
)
```

###### Default Empty Widget

<img src="https://github.com/Mustafa7Ibrahim/enhanced_paginated_view/blob/main/assets/empty_screen.jpg?raw=true" alt="GridView" style="width: 400px;">

### Enum Types

#### EnhancedStatus

- This class is exposed for you to use inside your state management class or use it as you like.
- The package will handle all things related to first loading page or load more, no need to handle thous your self.
```dart
enum EnhancedStatus {
  loading, // The view is loading data
  loaded,  // Data is successfully loaded
  error    // An error occurred while loading data
}
```

#### EnhancedViewDirection

- This would be handy in application like chat and others.
- make sure that if you use the box-based view to give the reverse that the builder give you to the scroll builder.
```dart
enum EnhancedViewDirection {
  forward,  // Scroll forward direction
  reverse   // Scroll reverse direction
}
```

### Example Code

```dart
class Example extends StatefulWidget {
  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  final List<int> initList = [];
  final int maxItems = 30;
  EnhancedStatus status = EnhancedStatus.loaded;
  bool isMaxReached = false;

  Future<void> loadMore(int page) async {
    if (initList.length >= maxItems) {
      setState(() => isMaxReached = true);
      return;
    }
    setState(() => status = EnhancedStatus.loading);
    await Future.delayed(Duration(seconds: 1), () {
      setState(() {
        initList.addAll(List.generate(10, (index) => index + page * 10));
        status = EnhancedStatus.loaded;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return EnhancedPaginatedView(
      onLoadMore: loadMore,
      hasReachedMax: isMaxReached,
      delegate: EnhancedDelegate(
        listOfData: initList,
        status: status,
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      builder: (context, item) => ListTile(title: Text('Item $item')),
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
