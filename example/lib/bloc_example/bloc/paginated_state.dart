part of 'paginated_bloc.dart';

sealed class PaginatedState extends Equatable {
  const PaginatedState();
}

class PaginatedLoading extends PaginatedState {
  @override
  List<Object> get props => [];
}

class PaginatedLoaded<T> extends PaginatedState {
  final List<int> listOfData;
  final bool isMaxReached;
  final bool isLoading;
  final String? error;

  const PaginatedLoaded({
    required this.listOfData,
    required this.isMaxReached,
    required this.isLoading,
    this.error,
  });

  @override
  List<Object> get props => [listOfData, isMaxReached, isLoading, error ?? ''];
}
