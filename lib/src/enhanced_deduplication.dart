extension EnhancedDeduplication<T> on Iterable<T> {
  /// Returns a new list with all duplicate elements removed.
  ///
  /// The order of the elements is preserved.
  ///
  /// Example:
  ///
  /// ```dart
  /// final list = [1, 2, 3, 1, 2, 3, 4, 5];
  /// final result = list.enhancedDeduplication();
  /// print(result); // [1, 2, 3, 4, 5]
  /// ```
  List<T> enhancedDeduplication() {
    // Convert the list to a set to remove duplicates
    Set<T> uniqueSet = Set<T>.from(this);

    // Convert the set back to a list
    List<T> resultList = uniqueSet.toList();

    return resultList;
  }
}
