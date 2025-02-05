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