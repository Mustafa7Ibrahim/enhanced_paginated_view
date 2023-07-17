part of 'paginated_bloc.dart';

sealed class PaginatedEvent extends Equatable {
  const PaginatedEvent();
}

class FetchDataEvent extends PaginatedEvent {
  const FetchDataEvent();
  @override
  List<Object> get props => [];
}

class NewDataEvent extends PaginatedEvent {
  final List<int> listOfData;
  final int page;

  const NewDataEvent({
    required this.listOfData,
    required this.page,
  });
  @override
  List<Object> get props => [listOfData, page];
}
