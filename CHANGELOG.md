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
- update the bloc example and the docs.

## 1.0.0

- stable version.
- add reverse support. that would be handy when you for example want to show a list of items in reverse order. in a chat app for example.
- improve the example code with some of misunderstanding variables .

## 0.0.4

- some enhancement.

## 0.0.3

- add error widget.

## 0.0.2

- add some example and readme.

## 0.0.1

- init.
