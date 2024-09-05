part of 'paginated_bloc.dart';

final class PaginatedState extends Equatable {
  const PaginatedState({
    this.status = EnhancedStatus.loading,
    this.data = const [],
    this.hasReachedMax = false,
    this.error,
  });

  final EnhancedStatus status;
  final List<String> data;
  final bool hasReachedMax;
  final String? error;

  /// copyWith method is used to copy the current state
  /// and update the required fields.
  PaginatedState copyWith({
    EnhancedStatus? status,
    List<String>? data,
    bool? hasReachedMax,
    String? error,
  }) {
    return PaginatedState(
      status: status ?? this.status,
      data: data ?? this.data,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [
        data,
        hasReachedMax,
        error ?? '',
        status,
      ];
}
