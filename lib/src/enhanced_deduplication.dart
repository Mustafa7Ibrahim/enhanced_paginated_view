extension EnhancedDeduplication<T> on Iterable<T> {
  /// Returns a new List with all duplicate elements removed.
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
  ///
  /// If you want to manually remove duplicates, avoid using
  /// ```
  /// list.removeAt(index)
  /// ```
  ///
  /// Instead, use
  ///
  /// ```
  /// list.removeWhere((element) => element == item)
  /// ```
  ///
  /// This way, you ensure that all duplicate elements are removed, not just one.
  ///
  /// Returns: A new List with duplicate elements removed while preserving the
  /// original order.
  List<T> enhancedDeduplication() {
    // Convert the list to a set to remove duplicates
    Set<T> uniqueSet = Set<T>.from(this);

    // Convert the set back to a list
    List<T> resultList = uniqueSet.toList();

    return resultList;
  }
}
