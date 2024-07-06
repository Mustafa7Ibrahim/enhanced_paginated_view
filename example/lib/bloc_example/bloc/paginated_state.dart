part of 'paginated_bloc.dart';

enum PaginatedStatus { initial, loading, loaded, error }

final class PaginatedState extends Equatable {
  const PaginatedState({
    this.status = PaginatedStatus.initial,
    this.listOfData = const [],
    this.isMaxReached = false,
    this.error,
  });

  final PaginatedStatus status;
  final List<String> listOfData;
  final bool isMaxReached;
  final String? error;

  /// copyWith method is used to copy the current state
  /// and update the required fields.
  PaginatedState copyWith({
    PaginatedStatus? status,
    List<String>? listOfData,
    bool? isMaxReached,
    String? error,
  }) {
    return PaginatedState(
      status: status ?? this.status,
      listOfData: listOfData ?? this.listOfData,
      isMaxReached: isMaxReached ?? this.isMaxReached,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [
        listOfData,
        isMaxReached,
        error ?? '',
        status,
      ];
}
