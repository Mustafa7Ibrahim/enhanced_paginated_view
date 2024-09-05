part of 'paginated_bloc.dart';

sealed class PaginatedEvent extends Equatable {
  const PaginatedEvent();
}

class FetchDataEvent extends PaginatedEvent {
  const FetchDataEvent({this.page = 1, this.failPage});

  final int page;
  final int? failPage;

  @override
  List<Object> get props => [page, failPage ?? 0];
}
