
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
- **Data/Config Separation** – `EnhancedDelegate` carries data only; `EnhancedConfig` carries all presentation/behavior options.  
- **State Management Compatibility** – Works seamlessly with **BLoC, Riverpod, Provider, and other state management solutions**.  
- **Pull-to-Refresh Support** – Refresh the list dynamically with the `onRefresh` callback, in both `forward` and `reverse` directions.  
- **Custom Refresh Indicator** – Fully control the refresh UI using the `refreshBuilder` function.  
- **✨ New: `EnhancedPaginationController`** – Optional controller exposing the current `page` and `isLoadingMore` state.  
- **✨ New: Configurable Load-More Threshold** – Tune how close to the end of the list (`loadMoreThreshold`) a load-more request is triggered.  


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

This single import also exposes the `EnhancedBoxBuilder`, `EnhancedSliverBuilder`, and `EnhancedRefreshBuilder` typedefs, which are handy if you want to type a `builder`/`refreshBuilder` function that you extract into its own variable or method.

## Usage

`EnhancedPaginatedView` can be used in two primary modes: box-based view and sliver-based view. Choose the one that best fits your layout needs.

In v3, `EnhancedDelegate` only carries **data** (`listOfData` + `status`). All presentation/behavior options — physics, header, scroll direction, dedup, loading/error/empty widgets — now live on a separate `EnhancedConfig` passed via the `config:` parameter.

> **Note:** The box-based builder (`EnhancedPaginatedView(...)`) renders its content eagerly inside a `SingleChildScrollView` (similar to `shrinkWrap: true`), so the whole list is laid out up front. For very large lists, prefer `EnhancedPaginatedView.slivers`, which renders lazily inside a `CustomScrollView`.

### Box-Based View Example

```dart
EnhancedPaginatedView(
  onLoadMore: (page) {
    // Load more data for `page`
  },
  hasReachedMax: state.hasReachedMax,
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
    // Load more data for `page`
  },
  hasReachedMax: state.hasReachedMax,
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

The package supports pull-to-refresh functionality in both the `forward` and `reverse` directions. You can implement the `onRefresh` callback to refresh the list when the user pulls down. If no callback is provided, the refresh indicator will be disabled by default.  

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
  hasReachedMax: state.hasReachedMax,
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

### Presentation & Behavior with `EnhancedConfig`

Use `config:` to control everything about how the list looks and behaves — scroll physics, header, scroll direction, cross-axis alignment, deduplication, and the loading/error/empty widget configs:

```dart
EnhancedPaginatedView(
  delegate: EnhancedDelegate(
    listOfData: yourDataList,
    status: state.status,
  ),
  config: EnhancedConfig(
    header: const HeaderWidget(),
    removeDuplicatedItems: true,
    scrollDirection: Axis.vertical,
    errorPageConfig: ErrorPageConfig(
      onRetry: () => bloc.add(const FetchDataEvent(page: 1)),
    ),
    errorLoadMoreConfig: ErrorLoadMoreConfig(
      onRetry: (page) => bloc.add(FetchDataEvent(page: page)),
    ),
  ),
  hasReachedMax: state.hasReachedMax,
  onLoadMore: (page) => bloc.add(FetchDataEvent(page: page)),
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

`config` defaults to `const EnhancedConfig()` if omitted, so you only need to pass it when you want to override something.

### `EnhancedPaginationController`

`EnhancedPaginationController` is an optional `ChangeNotifier` that tracks the current `page` and whether a load-more request `isLoadingMore`. If you don't pass one, `EnhancedPaginatedView` creates and disposes one internally.

The page only advances when the delegate's `status` transitions from `loading` to `loaded`, so make sure your state management emits a `loading` status before each page load — including the first one.

```dart
final controller = EnhancedPaginationController();

EnhancedPaginatedView(
  controller: controller,
  delegate: EnhancedDelegate(
    listOfData: yourDataList,
    status: state.status,
  ),
  hasReachedMax: state.hasReachedMax,
  onLoadMore: (page) => bloc.add(FetchDataEvent(page: page)),
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

If your app **preloads** the first page (i.e. it starts with non-empty data and status `loaded`, without an initial `loading` status), create the controller with `initialPage: 2` so the *next* requested page is correct:

```dart
final controller = EnhancedPaginationController(initialPage: 2);
```

You can also tune how early a load-more request fires via `loadMoreThreshold` (in pixels from the end of the scrollable, default `200`):

```dart
EnhancedPaginatedView(
  loadMoreThreshold: 400,
  // ...
)
```

## Key Components  

### 1. `EnhancedPaginatedView` Widget  

| Parameter           | Type                          | Required | Description                                                          |
| -------------------- | ----------------------------- | -------- | ---------------------------------------------------------------------|
| `delegate`           | `EnhancedDelegate<T>`         | ✅        | Provides the data list and current status.                          |
| `config`              | `EnhancedConfig`               | ❌        | Presentation/behavior configuration (default: `EnhancedConfig()`).  |
| `hasReachedMax`       | `bool`                         | ✅        | Controls whether more items should be loaded.                       |
| `onLoadMore`          | `void Function(int page)`      | ✅        | Callback triggered when scrolling near the end of the list.         |
| `builder`             | Function                       | ✅        | Builds the scroll view (box) or slivers (`.slivers`).                |
| `controller`          | `EnhancedPaginationController` | ❌        | Tracks `page` and `isLoadingMore`; auto-created if omitted.         |
| `direction`           | `EnhancedViewDirection`        | ❌        | Defines scroll direction (default: `forward`).                      |
| `onRefresh`           | `Future<void> Function()`      | ❌        | Callback for pull-to-refresh functionality.                         |
| `refreshBuilder`      | Function                       | ❌        | Customizes the refresh indicator.                                   |
| `loadMoreThreshold`   | `double`                       | ❌        | Pixels from the end of the scrollable to trigger load-more (default: `200`). |

### 2. `EnhancedDelegate` Class  

| Property                | Type                 | Required | Description                                               |
| ----------------------- | -------------------- | -------- | ----------------------------------------------------------|
| `listOfData`             | `List<T>`             | ✅        | List of items to display.                                |
| `status`                 | `EnhancedStatus`      | ✅        | Current status (`loading`, `loaded`, or `error`).        |

### 3. `EnhancedConfig` Class  

| Property                | Type                 | Required | Description                                                |
| ----------------------- | -------------------- | -------- | ------------------------------------------------------------|
| `physics`                | `ScrollPhysics`       | ❌        | Custom scroll physics.                                     |
| `removeDuplicatedItems`  | `bool`                | ❌        | Removes duplicates (default: `true`).                      |
| `scrollDirection`        | `Axis`                | ❌        | Scroll direction (default: `Axis.vertical`).               |
| `crossAxisAlignment`     | `CrossAxisAlignment`  | ❌        | Aligns children along the cross-axis (default: `center`).  |
| `header`                 | `Widget`              | ❌        | Widget displayed at the top of the list.                   |
| `emptyWidgetConfig`      | `EmptyWidgetConfig`   | ❌        | Configuration for the empty state widget.                  |
| `loadingConfig`          | `LoadingConfig`       | ❌        | Configuration for the loading widget.                      |
| `errorPageConfig`        | `ErrorPageConfig`     | ❌        | Configuration for the error page.                          |
| `errorLoadMoreConfig`    | `ErrorLoadMoreConfig` | ❌        | Configuration for the load-more error message.             |

---

### 4. Loading, Error, and Empty States  

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

### 5. Deduplication  

By default (`removeDuplicatedItems: true` on `EnhancedConfig`), items are deduplicated using their own `==`/`hashCode` via the `removeDuplication()` extension on `Iterable<T>`. It's best practice to override `==` on your model, or use a package like `equatable`.

If you'd rather deduplicate by a specific key without overriding `==`, use the `removeDuplicationBy` extension directly on your own list:

```dart
final uniqueUsers = users.removeDuplicationBy((user) => user.id);
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

## Migrating from v2 to v3

v3 splits `EnhancedDelegate` into a data-only delegate plus a new `EnhancedConfig` for presentation/behavior, removes `itemsPerPage`, and adds an optional `EnhancedPaginationController`.

### 1. Delegate → Config split

`EnhancedDelegate` no longer accepts presentation options. Move `physics`, `header`, `scrollDirection`, `crossAxisAlignment`, `removeDuplicatedItems`, `emptyWidgetConfig`, `loadingConfig`, `errorLoadMoreConfig`, and `errorPageConfig` to a new `config:` parameter on the widget.

```dart
// v2
EnhancedPaginatedView(
  delegate: EnhancedDelegate(
    listOfData: yourDataList,
    status: EnhancedStatus.loaded,
    header: const HeaderWidget(),
    removeDuplicatedItems: true,
    errorPageConfig: ErrorPageConfig(onRetry: () => loadMore(1)),
  ),
  // ...
)

// v3
EnhancedPaginatedView(
  delegate: EnhancedDelegate(
    listOfData: yourDataList,
    status: EnhancedStatus.loaded,
  ),
  config: EnhancedConfig(
    header: const HeaderWidget(),
    removeDuplicatedItems: true,
    errorPageConfig: ErrorPageConfig(onRetry: () => loadMore(1)),
  ),
  // ...
)
```

### 2. `itemsPerPage` removed

`itemsPerPage` is gone — page tracking is now handled internally (optionally via `EnhancedPaginationController`). Simply delete it from your calls.

```dart
// v2
EnhancedPaginatedView(
  itemsPerPage: 15,
  // ...
)

// v3
EnhancedPaginatedView(
  // itemsPerPage removed — nothing to replace it with
  // ...
)
```

### 3. Optional `EnhancedPaginationController`

If you need to read the current page or in-flight loading state outside the widget, create and pass an `EnhancedPaginationController`. If your app preloads page 1 (starts with non-empty data and status `loaded`, without an initial `loading` status), initialize it with `initialPage: 2`:

```dart
// v3 — optional, only needed if you preload page 1 or want to read page/isLoadingMore
final controller = EnhancedPaginationController(initialPage: 2);

EnhancedPaginatedView(
  controller: controller,
  // ...
)
```

If you don't need any of this, you can omit `controller` entirely — the widget manages one internally.

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