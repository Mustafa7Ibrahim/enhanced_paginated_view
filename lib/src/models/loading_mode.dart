enum LoadingMode {
  /// [LoadingMode.loosely] is a loading type that will
  /// call [onLoadMore] when the user reaches the half of the list
  /// that are loaded last time the [onLoadMore] is called
  loosely(0.50),

  /// [LoadingMode.smooth] is a loading type that will
  /// call [onLoadMore] when the user reaches a 75% of the list
  /// that are loaded last time the [onLoadMore] is called
  /// this is the default value
  smooth(0.75),

  /// [LoadingMode.strictLoading] is a loading type that will
  /// call [onLoadMore] when the user reaches the end of the list
  /// that are loaded last time the [onLoadMore] is called
  restrict(0.100);

  const LoadingMode(this.percentage);
  final double percentage;
}
