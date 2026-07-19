# Enhanced Paginated View
<a href="https://pub.dev/packages/enhanced_paginated_view"><img src="https://img.shields.io/pub/v/enhanced_paginated_view.svg" alt="Pub"></a>
<a href="https://pub.dev/packages/enhanced_paginated_view/score"><img src="https://img.shields.io/pub/likes/enhanced_paginated_view?logo=flutter" alt="Pub likes"></a>
<a href="https://pub.dev/packages/enhanced_paginated_view/score"><img src="https://img.shields.io/pub/points/enhanced_paginated_view?logo=flutter" alt="Pub points"></a>

## Overview

A customizable Flutter widget for paginated `ListView`, `GridView`, and sliver layouts. It handles loading, error, and empty states, infinite scroll, and pull-to-refresh, so your screens only need to supply data and a builder.

| List View | Grid View |
| --- | --- |
| <img src="https://github.com/Mustafa7Ibrahim/enhanced_paginated_view/blob/main/assets/list_example.gif?raw=true" alt="List View" style="width: 200px;"> | <img src="https://github.com/Mustafa7Ibrahim/enhanced_paginated_view/blob/main/assets/grid_example.gif?raw=true" alt="GridView" style="width: 200px;"> |

## Features

- **Flexible layouts** – box-based (`ListView`/`GridView`) or sliver-based for use inside a `CustomScrollView`.
- **Forward or reverse scrolling** – set via `direction`.
- **Built-in error handling** – error and load-more-error states with retry callbacks.
- **Customizable loading indicators** – separate configs for the initial load and load-more.
- **Infinite scrolling** – automatic load-more as the user scrolls, with a tunable `loadMoreThreshold`.
- **Data/config separation** – `EnhancedDelegate` carries data only; `EnhancedConfig` carries all presentation/behavior options.
- **State management agnostic** – works with BLoC, Riverpod, Provider, or plain `setState`.
- **Pull-to-refresh** – `onRefresh` callback with an optional `refreshBuilder` for a custom indicator, in both scroll directions.
- **Pagination controller** – optional `EnhancedPaginationController` exposing the current `page` and `isLoadingMore` state.

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  enhanced_paginated_view: ^latest_version
```

Then import it:

```dart
import 'package:enhanced_paginated_view/enhanced_paginated_view.dart';
```

This also exports the `EnhancedBoxBuilder`, `EnhancedSliverBuilder`, and `EnhancedRefreshBuilder` typedefs, useful if you want to extract a `builder`/`refreshBuilder` into its own variable or method.

## Usage

`EnhancedPaginatedView` has two constructors: the default box-based builder, and `.slivers` for sliver-based layouts. `EnhancedDelegate` carries only **data** (`listOfData` + `status`); everything about presentation and behavior — physics, header, scroll direction, deduplication, loading/error/empty widgets — lives on a separate `EnhancedConfig` passed via `config:`.

> **Note:** The box-based builder renders eagerly inside a `SingleChildScrollView` (similar to `shrinkWrap: true`), laying out the whole list up front. For very large lists, prefer `EnhancedPaginatedView.slivers`, which renders lazily inside a `CustomScrollView`.

### Box-based view

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

### Sliver-based view

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

### Pull-to-refresh

Add `onRefresh` to the example above to enable pull-to-refresh in either scroll direction; without it, the refresh indicator is disabled. Customize its appearance with `refreshBuilder`:

```dart
EnhancedPaginatedView(
  // ...as above
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
)
```

### Presentation with `EnhancedConfig`

`config:` controls how the list looks and behaves — scroll physics, header, scroll direction, cross-axis alignment, deduplication, and the loading/error/empty widget configs. It defaults to `const EnhancedConfig()`, so pass it only to override something:

```dart
EnhancedPaginatedView(
  // ...as above
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
)
```

### `EnhancedPaginationController`

An optional `ChangeNotifier` that tracks the current `page` and whether a load-more request `isLoadingMore`. If you don't pass one, `EnhancedPaginatedView` creates and disposes one internally. The page only advances when the delegate's `status` transitions from `loading` to `loaded`, so make sure your state management emits `loading` before each page load — including the first one.

```dart
final controller = EnhancedPaginationController();

EnhancedPaginatedView(
  // ...as above
  controller: controller,
)
```

If your app **preloads** the first page (starts with non-empty data and status `loaded`, without an initial `loading` status), create the controller with `initialPage: 2` so the next requested page is correct:

```dart
final controller = EnhancedPaginationController(initialPage: 2);
```

You can also tune how early a load-more request fires via `loadMoreThreshold` (pixels from the end of the scrollable, default `200`):

```dart
EnhancedPaginatedView(
  loadMoreThreshold: 400,
  // ...
)
```

## API Reference

### `EnhancedPaginatedView`

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `delegate` | `EnhancedDelegate<T>` | Yes | Provides the data list and current status. |
| `config` | `EnhancedConfig` | No | Presentation/behavior configuration (default: `EnhancedConfig()`). |
| `hasReachedMax` | `bool` | Yes | Controls whether more items should be loaded. |
| `onLoadMore` | `void Function(int page)` | Yes | Called when scrolling near the end of the list. |
| `builder` | Function | Yes | Builds the scroll view (box) or slivers (`.slivers`). |
| `controller` | `EnhancedPaginationController` | No | Tracks `page` and `isLoadingMore`; auto-created if omitted. |
| `direction` | `EnhancedViewDirection` | No | Scroll direction (default: `forward`). |
| `onRefresh` | `Future<void> Function()` | No | Callback for pull-to-refresh. |
| `refreshBuilder` | Function | No | Customizes the refresh indicator. |
| `loadMoreThreshold` | `double` | No | Pixels from the end of the scrollable to trigger load-more (default: `200`). |

### `EnhancedDelegate`

| Property | Type | Required | Description |
| --- | --- | --- | --- |
| `listOfData` | `List<T>` | Yes | List of items to display. |
| `status` | `EnhancedStatus` | Yes | Current status (`loading`, `loaded`, or `error`). |

### `EnhancedConfig`

| Property | Type | Required | Description |
| --- | --- | --- | --- |
| `physics` | `ScrollPhysics` | No | Custom scroll physics. |
| `removeDuplicatedItems` | `bool` | No | Removes duplicates (default: `true`). |
| `scrollDirection` | `Axis` | No | Scroll direction (default: `Axis.vertical`). |
| `crossAxisAlignment` | `CrossAxisAlignment` | No | Aligns children along the cross-axis (default: `center`). |
| `header` | `Widget` | No | Widget displayed at the top of the list. |
| `emptyWidgetConfig` | `EmptyWidgetConfig` | No | Configuration for the empty state widget. |
| `loadingConfig` | `LoadingConfig` | No | Configuration for the loading widget. |
| `errorPageConfig` | `ErrorPageConfig` | No | Configuration for the error page. |
| `errorLoadMoreConfig` | `ErrorLoadMoreConfig` | No | Configuration for the load-more error message. |

### Loading, error, and empty states

**Loading (`LoadingConfig`)** – widgets for page-level loading and load-more:

```dart
LoadingConfig(
  pageWidget: CircularProgressIndicator(),
  loadMoreWidget: CircularProgressIndicator(),
)
```

**Error (`ErrorPageConfig`)** – full-page error with retry:

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

**Empty (`EmptyWidgetConfig`)** – shown when there's no data:

```dart
EmptyWidgetConfig(
  title: "No data found",
  customView: CustomEmptyView(),
)
```

### Deduplication

By default (`removeDuplicatedItems: true` on `EnhancedConfig`), items are deduplicated using their own `==`/`hashCode` via the `removeDuplication()` extension on `Iterable<T>`. Override `==` on your model, or use a package like `equatable`.

To deduplicate by a specific key without overriding `==`, use `removeDuplicationBy` directly on your list:

```dart
final uniqueUsers = users.removeDuplicationBy((user) => user.id);
```

### Enum types

```dart
enum EnhancedStatus { loading, loaded, error }

enum EnhancedViewDirection { forward, reverse }
```

## Migrating from v2 to v3

- **`EnhancedDelegate` is data-only** – it now accepts only `listOfData` and `status`. Move `physics`, `header`, `scrollDirection`, `crossAxisAlignment`, `removeDuplicatedItems`, `emptyWidgetConfig`, `loadingConfig`, `errorLoadMoreConfig`, and `errorPageConfig` to a new `EnhancedConfig` passed via `config:`.
- **`itemsPerPage` is removed** – page tracking is now internal (optionally exposed via `EnhancedPaginationController`). Delete it from your calls; there's no replacement parameter.
- **`EnhancedPaginationController` is optional** – pass one only if you need to read `page`/`isLoadingMore` externally, or if your app preloads page 1 (in which case initialize it with `initialPage: 2`). Otherwise the widget manages one internally.

```dart
// v2
EnhancedPaginatedView(
  itemsPerPage: 15,
  delegate: EnhancedDelegate(
    listOfData: yourDataList,
    status: EnhancedStatus.loaded,
    header: const HeaderWidget(),
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
    errorPageConfig: ErrorPageConfig(onRetry: () => loadMore(1)),
  ),
  // ...
)
```

## Examples

The [`example`](https://github.com/Mustafa7Ibrahim/enhanced_paginated_view/tree/main/example) folder has full, runnable integrations with:

- **Native Flutter** (`setState`)
- **BLoC**
- **Riverpod**

## License

MIT — see [LICENSE](https://github.com/Mustafa7Ibrahim/enhanced_paginated_view/blob/main/LICENSE).

## Author

[Mustafa Ibrahim](https://github.com/Mustafa7Ibrahim) — for feature requests or bug reports, visit the [GitHub repository](https://github.com/Mustafa7Ibrahim/enhanced_paginated_view).
