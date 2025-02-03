
# Enhanced Paginated View
<a href="https://pub.dev/packages/enhanced_paginated_view"><img src="https://img.shields.io/pub/v/enhanced_paginated_view.svg" alt="Pub"></a>
<a href="https://pub.dev/packages/enhanced_paginated_view/score"><img src="https://img.shields.io/pub/likes/enhanced_paginated_view?logo=flutter" alt="Pub likes"></a>
<a href="https://pub.dev/packages/enhanced_paginated_view"><img src="https://img.shields.io/pub/dt/enhanced_paginated_view?logo=flutter" alt="downloads"></a>
<a href="https://pub.dev/packages/enhanced_paginated_view/score"><img src="https://img.shields.io/pub/points/enhanced_paginated_view?logo=flutter" alt="Pub points"></a>

## Overview

The `EnhancedPaginatedView` package offers a flexible, highly customizable builder function that supports various scrollable widgets like `ListView`, `GridView`, or Slivers. With dynamic layout rendering and options for handling loading states, errors, and scroll behavior, it simplifies the implementation of paginated views. Whether using `box-based` or `sliver-based` layouts, it optimizes performance for large data sets while enhancing the user experience without the need to rewrite code for each widget.

| List View                                                                                                                                               | Grid View                                                                                                                                              |
| ------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| <img src="https://github.com/Mustafa7Ibrahim/enhanced_paginated_view/blob/main/assets/list_example.gif?raw=true" alt="List View" style="width: 200px;"> | <img src="https://github.com/Mustafa7Ibrahim/enhanced_paginated_view/blob/main/assets/grid_example.gif?raw=true" alt="GridView" style="width: 200px;"> |

## Features

- Supports box-based or sliver-based views for flexible UI layouts
- Customizable scroll direction (forward or reverse)
- Integrated error handling and retry mechanisms
- Customizable loading indicators
- Support for infinite scrolling and manual pagination control
- Delegate-based architecture for data handling
- Compatible with various state management solutions (e.g., BLoC, Riverpod)
- **New**: Pull-to-Refresh support with the `onRefresh` callback
- **New**: Custom refresh indicator with the `refreshBuilder` function

## Getting Started

To use `EnhancedPaginatedView`, add it to your `pubspec.yaml`:

```yaml
dependencies:
  enhanced_paginated_view: ^latest_version
```

Then import it in your Dart file:

```dart
import 'package:enhanced_paginated_view/enhanced_paginated_view.dart';
```

## Usage

`EnhancedPaginatedView` can be used in two primary modes: box-based view and sliver-based view. Choose the one that best fits your layout needs.

### Box-Based View Example

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
      physics: physics,
      shrinkWrap: shrinkWrap,
      reverse: reverse,
      itemBuilder: (context, index) {
        return ListTile(title: Text(items[index].toString()));
      },
    );
  },
)
```

### Sliver-Based View Example

```dart
EnhancedPaginatedView.slivers(
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
)
```

## New Features (v2.0.2)

### Pull-to-Refresh Support

With version `2.0.2`, the package now supports pull-to-refresh functionality. You can implement the `onRefresh` callback to refresh the list when the user pulls down. If no callback is provided, the refresh indicator will be disabled by default.

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
  onRefresh: () async {
    // Trigger data refresh
  },
  builder: (items, physics, reverse, shrinkWrap) {
    return ListView.builder(
      itemCount: items.length,
      physics: physics,
      reverse: reverse,
      shrinkWrap: shrinkWrap,
      itemBuilder: (context, index) {
        return ListTile(title: Text(items[index].toString()));
      },
    );
  },
)
```

### Custom Refresh Indicator

You can now specify a custom refresh indicator using the `refreshBuilder` parameter. This allows for complete control over the look and feel of the refresh indicator.

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
  onRefresh: () async {
    // Trigger data refresh
  },
  refreshBuilder: (context, onRefresh, child) {
    return RefreshIndicator(
      color: Colors.white,
      backgroundColor: Colors.green,
      onRefresh: onRefresh,
      child: child,
    );
  },
  builder: (items, physics, reverse, shrinkWrap) {
    return ListView.builder(
      itemCount: items.length,
      physics: physics,
      reverse: reverse,
      shrinkWrap: shrinkWrap,
      itemBuilder: (context, index) {
        return ListTile(title: Text(items[index].toString()));
      },
    );
  },
)
```

## Key Components

### 1. EnhancedPaginatedView Widget

The primary widget in the package, supporting both box-based and sliver-based views.

#### Constructor Parameters:
- `onLoadMore` (required): Callback function triggered when scrolling to the list bottom.
- `hasReachedMax` (required): Boolean controlling whether to load more items.
- `itemsPerPage`: Optional integer setting items loaded per page (default: 15).
- `delegate` (required): `EnhancedDelegate` instance providing data and configuration.
- `builder` (required): Function for building each scroll view.
- `direction`: Defines scroll direction (default: `EnhancedViewDirection.forward`).
- `onRefresh`: Optional callback for pull-to-refresh functionality.
- `refreshBuilder`: Optional builder function for customizing the refresh indicator.

### 2. EnhancedDelegate Class

Manages data and provides configuration options for `EnhancedPaginatedView`.

#### Properties:
- `listOfData` (required): List of items to display.
- `status` (required): Current status (loading, loaded, or error).
- `physics`: Custom scroll physics (optional).
- `removeDuplicatedItems`: Boolean to remove duplicates (default: `true`).
- `scrollDirection`: Scroll direction (default: `Axis.vertical`).
- `crossAxisAlignment`: Alignment of children along cross-axis (default: `CrossAxisAlignment.center`).
- `header`: Widget displayed at list top (optional).
- `emptyWidgetConfig`: Configuration for empty state widget.
- `loadingConfig`: Configuration for loading widget.
- `errorPageConfig`: Configuration for error page.
- `errorLoadMoreConfig`: Configuration for load-more error message.

### 3. Loading, Error, and Empty States

Customizable UI components for various states:

#### LoadingConfig
```dart
LoadingConfig(
  pageWidget: CircularProgressIndicator(),
  loadMoreWidget: CircularProgressIndicator(),
)
```

#### ErrorPageConfig
```dart
ErrorPageConfig(
  title: "Error loading data",
  description: "Something went wrong.",
  btnText: "Retry",
  onRetry: () => loadMore(1),
  customButton: CustomButton(),
  customView: CustomErrorPageView()
)
```

#### EmptyWidgetConfig
```dart
EmptyWidgetConfig(
  title: "No data found",
  customView: CustomEmptyView(),
)
```

## Enum Types

### EnhancedStatus
```dart
enum EnhancedStatus {
  loading,
  loaded,
  error
}
```

### EnhancedViewDirection
```dart
enum EnhancedViewDirection {
  forward,
  reverse
}
```

## Examples with Different State Management Approaches

The package includes examples demonstrating integration with various state management solutions:

1. **Native Flutter (setState)**: A basic example using Flutter's built-in state management.
2. **BLoC**: An example showcasing integration with the BLoC (Business Logic Component) pattern.
3. **Riverpod**: Demonstrates usage with the Riverpod state management library.

These examples can be found in the package's GitHub repository under the [`example`](https://github.com/Mustafa7Ibrahim/enhanced_paginated_view/tree/main/example) folder. They provide clear, concise implementations to help you integrate `EnhancedPaginatedView` with your preferred state management solution.

## License

This project is licensed under the MIT License. See the [LICENSE](https://github.com/Mustafa7Ibrahim/enhanced_paginated_view/blob/main/LICENSE) file for details.

## Author

- [Mustafa Ibrahim](https://github.com/Mustafa7Ibrahim)

For more information, feature requests, or bug reports, please visit the [GitHub repository](https://github.com/Mustafa7Ibrahim/enhanced_paginated_view).