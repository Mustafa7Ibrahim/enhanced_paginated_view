part of 'paginated_bloc.dart';

enum PaginatedStatus { initial, loading, loaded, error }

final class PaginatedState extends Equatable {
  const PaginatedState({
    this.status = PaginatedStatus.initial,
    this.listOfData = const [],
    this.isMaxReached = false,
    this.hasError = false,
    this.error,
  });

  final PaginatedStatus status;
  final List<int> listOfData;
  final bool isMaxReached;
  final bool hasError;
  final String? error;

  /// copyWith method is used to copy the current state
  /// and update the required fields.
  PaginatedState copyWith({
    PaginatedStatus? status,
    List<int>? listOfData,
    bool? isMaxReached,
    bool? hasError,
    String? error,
  }) {
    return PaginatedState(
      status: status ?? this.status,
      listOfData: listOfData ?? this.listOfData,
      isMaxReached: isMaxReached ?? this.isMaxReached,
      hasError: hasError ?? this.hasError,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [
        listOfData,
        isMaxReached,
        error ?? '',
        status,
        hasError,
      ];
}
