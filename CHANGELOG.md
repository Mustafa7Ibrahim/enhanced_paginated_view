## 2.0.0

- Add support for slivers.
- Add support for custom loading widget.
- Add support for custom error widget.
- Add support for custom empty widget.
- Add support for custom scroll physics.
- **BREAKING** : Remove the showLoading, showError in favor of the `EnhancedStatus`.
- **BREAKING** : change `shouldDeduplicate` to `removeDuplicates`.
- **BREAKING** : change `isMaxReached` to `hasReachedMax`.
- Add New property `direction` to control the direction of the list and take `EnhancedViewDirection` as a value.
- Add a new EnhancedDelegate to control the behavior of the list and customize the widgets.
  

## 1.0.7

- Change the way of comparing the items to remove the duplicate items from the list.
- Fix docs.

## 1.0.6

- Fix docs.

## 1.0.5

- Add new property `itemsPerPage` to calculate page number more accurately.
- Add new property `shouldDeduplicate` to remove duplicate items from the list.
- Add new extension method `enhancedDeduplication()` to remove duplicate items from the list.

## 1.0.4

- Improve overall performance.
- Get rid of the `LoadingModes` and use a new way to trigger the `onLoadMore` behavior.

## 1.0.3

- Fix docs.

## 1.0.2

- Improve the performance of the `onLoadMore` behavior to have three modes.
  `LoadingMode.smooth`: is the default mode, it will trigger the `onLoadMore` when the user scroll to 75% of the list.
  `LoadingMode.restrict`: it will trigger the `onLoadMore` when the user scroll to 100% of the list.

- New default `emptyWidget` widget.
- New default `LoadingWidget` widget.
- New default `errorWidget` widget.
- Now it's possible to change the `ScrollPhysics` of the list.

## 1.0.1

- **BREAKING** : The `isLoadingState` is now `showLoading`.
- **BREAKING** : The `showErrorWidget` is now `showError`.
- **BREAKING** : The `emptyWidget` is now `emptyView`.
- Update the bloc example and the docs.

## 1.0.0

- Stable version.
- Add reverse support. that would be handy when you for example want to show a list of items in reverse order. in a chat app for example.
- Improve the example code with some of misunderstanding variables .
