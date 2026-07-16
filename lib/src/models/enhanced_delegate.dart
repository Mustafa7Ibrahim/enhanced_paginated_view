import 'package:enhanced_paginated_view/src/models/enhanced_status.dart';
import 'package:flutter/foundation.dart';

/// Immutable data holder for [EnhancedPaginatedView].
///
/// This delegate carries only the *data* related state of the paginated
/// view: the current [listOfData] and the [status] of the most recent load.
/// All presentation/behavior configuration lives on `EnhancedConfig` instead.
@immutable
class EnhancedDelegate<T> {
  /// Creates a new instance of the EnhancedDelegate class.
  ///
  /// The [listOfData] parameter is required and represents the list of data to be displayed.
  /// The [status] parameter is required and represents the current status of the EnhancedPaginatedView.
  const EnhancedDelegate({
    required this.listOfData,
    required this.status,
  });

  /// The list of data to be displayed in the EnhancedPaginatedView.
  final List<T> listOfData;

  /// The current status of the EnhancedPaginatedView.
  final EnhancedStatus status;

  /// Creates a copy of this delegate with the given fields replaced.
  EnhancedDelegate<T> copyWith({
    List<T>? listOfData,
    EnhancedStatus? status,
  }) {
    return EnhancedDelegate<T>(
      listOfData: listOfData ?? this.listOfData,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EnhancedDelegate<T> &&
        (identical(other.listOfData, listOfData) ||
            listEquals(other.listOfData, listOfData)) &&
        other.status == status;
  }

  @override
  int get hashCode => Object.hash(Object.hashAll(listOfData), status);
}
