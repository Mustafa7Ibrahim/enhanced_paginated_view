import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:enhanced_paginated_view/enhanced_paginated_view.dart';
import 'package:equatable/equatable.dart';
import 'package:example/core/fake_date.dart';

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

  /// fetch data
  Future<void> _fetchData(
    FetchDataEvent event,
    Emitter<PaginatedState> emit,
  ) async {
    emit(state.copyWith(status: EnhancedStatus.loading));

    await Future.delayed(
      const Duration(seconds: 1),
      () {
        if (event.isEmpty) {
          emit(
            state.copyWith(
              status: EnhancedStatus.loaded,
              data: [],
              hasReachedMax: true,
            ),
          );
          return;
        }
        if (event.page == event.failPage) {
          emit(
            state.copyWith(status: EnhancedStatus.error, error: 'Error'),
          );
          return;
        }
        List<String> initList = [];
        if (event.page == 1) {
          initList.addAll(item1);
        }
        if (event.page == 2) {
          initList.addAll(items2);
        }
        if (event.page == 3) {
          initList.addAll(items3);
        }
        emit(
          state.copyWith(
            status: EnhancedStatus.loaded,
            data: [...state.data, ...initList],
            hasReachedMax: 3 <= event.page,
          ),
        );
      },
    );
  }
}
