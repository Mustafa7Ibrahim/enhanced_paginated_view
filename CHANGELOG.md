## [3.0.0]

### Added  
- **`EnhancedConfig`**: New class that carries all presentation/behavior configuration (`physics`, `header`, `scrollDirection`, `crossAxisAlignment`, `removeDuplicatedItems`, `emptyWidgetConfig`, `loadingConfig`, `errorLoadMoreConfig`, `errorPageConfig`), passed to `EnhancedPaginatedView` via a new `config` parameter (defaults to `const EnhancedConfig()`).  
- **`EnhancedPaginationController`**: New optional `ChangeNotifier`-based controller exposing `page` and `isLoadingMore`, passed via a new `controller` parameter. If omitted, one is created and disposed internally.  
- **`loadMoreThreshold`**: New parameter (default `200`) controlling how many pixels before the end of the scrollable a load-more request is triggered.  
- **`removeDuplicationBy<K>`**: New extension method on `Iterable<T>` for deduplicating by a derived key (`K Function(T) keyOf`) without needing to override `==`.  
- **Exported builder typedefs**: `EnhancedBoxBuilder`, `EnhancedSliverBuilder`, and `EnhancedRefreshBuilder` are now exported from the package barrel file.  

### Changed  
- **Load-more trigger**: Now based on proximity to the end of the scrollable (`extentAfter <= loadMoreThreshold`) instead of an at-edge trigger, so it no longer misfires near the top of the list.  
- **Deduplication**: Deduplicated data is now computed once and memoized instead of being recomputed on every build.  
- **Reverse pull-to-refresh**: Pull-to-refresh now works correctly in the `reverse` direction; previously the refresh gesture was silently dropped.  
- **Full-page loading/error state**: Whether the page-level loading or error widget is shown is now keyed off an empty data list rather than `page == 1`, so consumer-triggered reloads on a non-empty list no longer incorrectly show the full-page state.  
- **Lints**: Bumped `flutter_lints` to `^5.0.0`.  
- **Flutter constraint**: Raised the minimum Flutter SDK to `>=3.10.0`.  

### Fixed  
- **Duplicate initial fetch**: The page counter no longer re-fetches page 1 when the consumer (rather than the widget) triggers the initial load.  
- **Load-more firing at the top**: Load-more no longer incorrectly triggers while scrolled near the top of the list.  
- **Reverse refresh dropped**: Fixed pull-to-refresh being silently ignored when `direction` is `EnhancedViewDirection.reverse`.  
- **Loading state hack removed**: Removed a 250ms `Future.delayed` used to fake loading-state transitions, replaced with tracking driven by actual status transitions and completion.  

### Breaking Changes  
- **`EnhancedDelegate` is now data-only**: It only accepts `listOfData` and `status`. All presentation/behavior fields (`physics`, `header`, `scrollDirection`, `crossAxisAlignment`, `removeDuplicatedItems`, `emptyWidgetConfig`, `loadingConfig`, `errorLoadMoreConfig`, `errorPageConfig`) have moved to the new `EnhancedConfig`, passed via `config`.  
- **`itemsPerPage` removed**: Page tracking is now handled internally (optionally exposed via `EnhancedPaginationController`); there is no replacement parameter.  
- **Config moved to `EnhancedConfig`**: Any code constructing `EnhancedDelegate` with presentation options must be updated to pass an `EnhancedConfig` via the new `config` parameter instead. See the README's "Migrating from v2 to v3" section for details.  

## [2.0.3]

### Chore  
- Update docs

## [2.0.2]

### Added  
- **Pull-to-Refresh Support**: Introduced the `onRefresh` callback, allowing users to refresh the list by pulling down. If not provided, the refresh indicator will be disabled.  
- **Custom Refresh Indicator**: Added `refreshBuilder`, enabling users to define a custom refresh indicator. If not specified, the default refresh indicator will be used.  

## [2.0.1]  

### Removed  
- **flutter_svg Dependency**: Eliminated reliance on the `flutter_svg` package to reduce dependencies.  

## [2.0.0]  

### Added  
- **Sliver Support**: Now supports slivers for better integration with `CustomScrollView`.  
- **Customization Options**: Introduced new properties for customization:  
  - Custom loading widget  
  - Custom error widget  
  - Custom empty widget  
  - Custom scroll physics  
- **New Direction Control**: Added the `direction` property, allowing users to control the list direction via `EnhancedViewDirection`.  
- **EnhancedDelegate**: Introduced `EnhancedDelegate` to provide greater control over list behavior and widget customization.  

### Breaking Changes  
- **State Management Update**:  
  - `showLoading` and `showError` were removed in favor of `EnhancedStatus`.  
  - `shouldDeduplicate` renamed to `removeDuplicates`.  
  - `isMaxReached` renamed to `hasReachedMax`.  

## [1.0.7]  

### Improved  
- **Duplicate Item Handling**: Enhanced the item comparison logic to better remove duplicate items from the list.  

### Fixed  
- **Documentation Updates**  

## [1.0.6]  

### Fixed  
- **Documentation Updates**  

## [1.0.5]  

### Added  
- **Pagination Enhancements**:  
  - Introduced `itemsPerPage` to improve page number calculations.  
  - Added `shouldDeduplicate` to remove duplicate items.  
  - New `enhancedDeduplication()` extension method to handle duplicate removal.  

## [1.0.4]  

### Improved  
- **Performance Enhancements**: Optimized loading behavior by removing `LoadingModes` in favor of a more efficient `onLoadMore` trigger mechanism.  

## [1.0.3]  

### Fixed  
- **Documentation Updates**  

## [1.0.2]  

### Improved  
- **OnLoadMore Performance**: Introduced new loading behaviors:  
  - `LoadingMode.smooth`: Triggers `onLoadMore` when scrolling reaches 75%.  
  - `LoadingMode.restrict`: Triggers `onLoadMore` at 100%.  

### Added  
- **Default Widgets**:  
  - New `emptyWidget`.  
  - New `LoadingWidget`.  
  - New `errorWidget`.  
- **Custom ScrollPhysics**: Users can now modify the `ScrollPhysics` of the list.  

## [1.0.1]  

### Breaking Changes  
- `isLoadingState` renamed to `showLoading`.  
- `showErrorWidget` renamed to `showError`.  
- `emptyWidget` renamed to `emptyView`.  

### Improved  
- **Bloc Example and Documentation Updates**  

## [1.0.0]  

### Stable Release  
- **Reverse Order Support**: Added support for reversing the list order (useful for chat applications).  
- **Example Code Refinements**: Improved clarity in example implementations.