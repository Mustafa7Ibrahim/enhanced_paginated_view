import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'paginated_event.dart';
part 'paginated_state.dart';

class PaginatedBloc extends Bloc<PaginatedEvent, PaginatedState> {
  PaginatedBloc() : super(const PaginatedState()) {
    on<PaginatedEvent>(
      (event, emit) async {
        switch (event) {
          case FetchDataEvent():
            await _fetchData(event, emit);
        }
      },
    );
  }

  bool _isMaxReached = false;
  final int _maxPageNumber = 5;
  final List<int> _listOfData = [];

  /// fetch data
  Future<void> _fetchData(
    FetchDataEvent event,
    Emitter<PaginatedState> emit,
  ) async {
    if (state.status != PaginatedStatus.initial) {
      emit(state.copyWith(status: PaginatedStatus.loading));
    }
    await Future.delayed(
      const Duration(seconds: 3),
      () {
        if (event.page == 3) {
          emit(state.copyWith(status: PaginatedStatus.error, error: 'Error'));
          return;
        }
        _isMaxReached = _maxPageNumber <= event.page;
        _listOfData.addAll(List<int>.generate(10, (index) => index + 1));
        emit(
          state.copyWith(
            status: PaginatedStatus.loaded,
            listOfData: _listOfData,
            isMaxReached: _isMaxReached,
          ),
        );
      },
    );
  }
}
