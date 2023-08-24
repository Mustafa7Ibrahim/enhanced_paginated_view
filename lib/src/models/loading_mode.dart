enum LoadingMode {
  /// [LoadingMode.smooth] is a loading type that will
  /// call [onLoadMore] when the user reaches a 75% of the list
  /// that are loaded last time the [onLoadMore] is called
  /// this is the default value
  smooth(0.75),

  /// [LoadingMode.strictLoading] is a loading type that will
  /// call [onLoadMore] when the user reaches the end of the list
  /// that are loaded last time the [onLoadMore] is called
  restrict(1.0);

  const LoadingMode(this.percentage);
  final double percentage;
}
