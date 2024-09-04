part of 'paginated_bloc.dart';

sealed class PaginatedEvent extends Equatable {
  const PaginatedEvent();
}

class FetchDataEvent extends PaginatedEvent {
  const FetchDataEvent({this.page = 1});

  final int page;

  @override
  List<Object> get props => [page];
}
