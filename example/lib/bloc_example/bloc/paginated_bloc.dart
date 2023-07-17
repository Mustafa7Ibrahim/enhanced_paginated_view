import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'paginated_event.dart';
part 'paginated_state.dart';

class PaginatedBloc extends Bloc<PaginatedEvent, PaginatedState> {
  bool _isMaxReached = false;
  final int _maxPageNumber = 5;

  PaginatedBloc() : super(PaginatedLoading()) {
    on<PaginatedEvent>((event, emit) {});

    on<FetchDataEvent>(
      (event, emit) async {
        emit(PaginatedLoading());
        await Future.delayed(
          const Duration(seconds: 2),
          () {
            emit(
              PaginatedLoaded(
                listOfData: List<int>.generate(10, (index) => index + 1),
                isMaxReached: _isMaxReached,
                isLoading: false,
              ),
            );
          },
        );
      },
    );

    on<NewDataEvent>(
      (event, emit) async {
        _isMaxReached = _maxPageNumber <= event.page;
        emit(
          PaginatedLoaded(
            listOfData: event.listOfData,
            isMaxReached: _isMaxReached,
            isLoading: true,
          ),
        );
        await Future.delayed(
          const Duration(seconds: 2),
          () {
            if (event.page == 3) {
              emit(
                PaginatedLoaded(
                  listOfData: event.listOfData,
                  isMaxReached: _isMaxReached,
                  isLoading: false,
                  error: 'Error',
                ),
              );
              return;
            }
            _isMaxReached = _maxPageNumber <= event.page;
            event.listOfData.addAll(
              List<int>.generate(10, (index) => index + 1),
            );
            emit(
              PaginatedLoaded(
                listOfData: event.listOfData,
                isMaxReached: _isMaxReached,
                isLoading: false,
              ),
            );
          },
        );
      },
    );
  }
}
