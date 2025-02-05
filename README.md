
# Enhanced Paginated View
<a href="https://pub.dev/packages/enhanced_paginated_view"><img src="https://img.shields.io/pub/v/enhanced_paginated_view.svg" alt="Pub"></a>
<a href="https://pub.dev/packages/enhanced_paginated_view/score"><img src="https://img.shields.io/pub/likes/enhanced_paginated_view?logo=flutter" alt="Pub likes"></a>
<a href="https://pub.dev/packages/enhanced_paginated_view/score"><img src="https://img.shields.io/pub/points/enhanced_paginated_view?logo=flutter" alt="Pub points"></a>
<!-- <a href="https://pub.dev/packages/enhanced_paginated_view"><img src="https://img.shields.io/pub/dt/enhanced_paginated_view?logo=flutter" alt="downloads"></a> -->

## Overview 🚀  

`EnhancedPaginatedView` makes pagination effortless! It seamlessly integrates with `ListView`, `GridView`, and Slivers, providing a **highly customizable** builder that dynamically renders layouts while handling loading, errors, and scrolling—all without extra hassle.  

Designed for both **box-based** and **sliver-based** layouts, it optimizes performance for large datasets, **reducing boilerplate** and improving the user experience. Say goodbye to complex pagination logic—`EnhancedPaginatedView` lets you build smooth, efficient, and responsive lists with minimal effort!

| List View                                                                                                                                               | Grid View                                                                                                                                              |
| ------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| <img src="https://github.com/Mustafa7Ibrahim/enhanced_paginated_view/blob/main/assets/list_example.gif?raw=true" alt="List View" style="width: 200px;"> | <img src="https://github.com/Mustafa7Ibrahim/enhanced_paginated_view/blob/main/assets/grid_example.gif?raw=true" alt="GridView" style="width: 200px;"> |

## Features 🚀  

- **Flexible Layouts** – Supports both **box-based** and **sliver-based** views for seamless UI integration.  
- **Custom Scroll Direction** – Easily switch between **forward** or **reverse** scrolling.  
- **Built-in Error Handling** – Includes **retry mechanisms** for a smoother user experience.  
- **Customizable Loading Indicators** – Fully configurable loading states for both **initial load** and **load more** scenarios.  
- **Infinite Scrolling & Manual Pagination** – Supports both **automatic** and **controlled** pagination strategies.  
- **Delegate-Based Architecture** – Simplifies data management and enhances separation of concerns.  
- **State Management Compatibility** – Works seamlessly with **BLoC, Riverpod, Provider, and other state management solutions**.  
- **✨ New: Pull-to-Refresh Support** – Refresh the list dynamically with the `onRefresh` callback.  
- **✨ New: Custom Refresh Indicator** – Fully control the refresh UI using the `refreshBuilder` function.  


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
  onLoadMore: (page) {
    // Load more data
  },
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
  onLoadMore: (page) {
    // Load more data
  },
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

---

### Pull-to-Refresh with Custom Refresh Indicator  

Starting from version `2.0.2`, the package supports pull-to-refresh functionality. You can implement the `onRefresh` callback to refresh the list when the user pulls down. If no callback is provided, the refresh indicator will be disabled by default.  

Additionally, you can customize the refresh indicator using the `refreshBuilder` parameter, giving you complete control over its appearance and behavior.  

```dart
EnhancedPaginatedView(
  onLoadMore: (int page) {
    // Load more data
  },
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
  itemsPerPage: 15,
  delegate: EnhancedDelegate(
    listOfData: yourDataList,
    status: EnhancedStatus.loaded,
  ),
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

### 1. `EnhancedPaginatedView` Widget  

| Parameter        | Type                    | Required | Description                                      |
| ---------------- | ----------------------- | -------- | ------------------------------------------------ |
| `onLoadMore`     | Function                | ✅        | Callback triggered when scrolling to the bottom. |
| `hasReachedMax`  | `bool`                  | ✅        | Controls whether more items should be loaded.    |
| `itemsPerPage`   | `int`                   | ❌        | Number of items loaded per page (default: `15`). |
| `delegate`       | `EnhancedDelegate`      | ✅        | Provides data and configuration.                 |
| `builder`        | Function                | ✅        | Builds the scroll view.                          |
| `direction`      | `EnhancedViewDirection` | ❌        | Defines scroll direction (default: `forward`).   |
| `onRefresh`      | Function                | ❌        | Callback for pull-to-refresh functionality.      |
| `refreshBuilder` | Function                | ❌        | Customizes the refresh indicator.                |

### 2. `EnhancedDelegate` Class  

| Property                | Type                 | Required | Description                                               |
| ----------------------- | -------------------- | -------- | --------------------------------------------------------- |
| `listOfData`            | `List<dynamic>`      | ✅        | List of items to display.                                 |
| `status`                | `EnhancedStatus`     | ✅        | Current status (`loading`, `loaded`, or `error`).         |
| `physics`               | `ScrollPhysics`      | ❌        | Custom scroll physics.                                    |
| `removeDuplicatedItems` | `bool`               | ❌        | Removes duplicates (default: `true`).                     |
| `scrollDirection`       | `Axis`               | ❌        | Scroll direction (default: `Axis.vertical`).              |
| `crossAxisAlignment`    | `CrossAxisAlignment` | ❌        | Aligns children along the cross-axis (default: `center`). |
| `header`                | `Widget`             | ❌        | Widget displayed at the top of the list.                  |
| `emptyWidgetConfig`     | `Widget`             | ❌        | Configuration for the empty state widget.                 |
| `loadingConfig`         | `Widget`             | ❌        | Configuration for the loading widget.                     |
| `errorPageConfig`       | `Widget`             | ❌        | Configuration for the error page.                         |
| `errorLoadMoreConfig`   | `Widget`             | ❌        | Configuration for the load-more error message.            |

---

### 3. Loading, Error, and Empty States  

The package provides customizable UI components for handling different states:  

#### 🔄 Loading State (`LoadingConfig`)  
Defines widgets for page-level loading and load-more scenarios.  
```dart
LoadingConfig(
  pageWidget: CircularProgressIndicator(),
  loadMoreWidget: CircularProgressIndicator(),
)
```

#### ❌ Error State (`ErrorPageConfig`)  
Displays a custom error page with retry functionality.  
```dart
ErrorPageConfig(
  title: "Error loading data",
  description: "Something went wrong.",
  btnText: "Retry",
  onRetry: () => loadMore(1),
  customButton: CustomButton(),
  customView: CustomErrorPageView(),
)
```

#### 📭 Empty State (`EmptyWidgetConfig`)  
Provides a custom view when no data is available.  
```dart
EmptyWidgetConfig(
  title: "No data found",
  customView: CustomEmptyView(),
)
```

---

## 🏷 Enum Types  

### ✅ `EnhancedStatus`  
Defines possible states of the paginated view.  
```dart
enum EnhancedStatus {
  loading,
  loaded,
  error
}
```

### 🔃 `EnhancedViewDirection`  
Controls the scrolling direction of the list.  
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