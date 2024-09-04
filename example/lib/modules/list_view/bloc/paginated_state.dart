part of 'paginated_bloc.dart';

enum PaginatedStatus {
  initLoading,
  initError,
  loading,
  error,
  loaded;
}

final class PaginatedState extends Equatable {
  const PaginatedState({
    this.status = PaginatedStatus.initLoading,
    this.data = const [],
    this.hasReachedMax = false,
    this.error,
  });

  final PaginatedStatus status;
  final List<String> data;
  final bool hasReachedMax;
  final String? error;

  /// copyWith method is used to copy the current state
  /// and update the required fields.
  PaginatedState copyWith({
    PaginatedStatus? status,
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
