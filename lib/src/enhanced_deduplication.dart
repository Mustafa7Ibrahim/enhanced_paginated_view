import 'dart:collection';

extension EnhancedDeduplication<T> on Iterable<T> {
  /// Returns a new List with all duplicate elements removed based on their values.
  ///
  /// The order of the elements is preserved.
  ///
  /// Example:
  ///
  /// ```dart
  /// final list = [Person("John"), Person("Alice"), Person("John"), Person("Bob")];
  /// final result = list.removeDuplication();
  /// print(result); // [Person("John"), Person("Alice"), Person("Bob")]
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
  ///
  /// NOTE: It's Always better if you use Equatable or override == operator
  /// in your class to compare objects.
  List<T> removeDuplication() {
    final uniqueSet = HashSet<T>();
    final resultList = <T>[];

    for (final item in this) {
      if (uniqueSet.add(item)) {
        resultList.add(item);
      }
    }

    return resultList;
  }
}
