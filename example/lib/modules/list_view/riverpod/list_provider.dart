import 'package:example/core/fake_date.dart';
import 'package:example/modules/list_view/bloc/paginated_bloc.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'list_provider.g.dart';

@riverpod
class ListP extends _$ListP {
  @override
  PaginatedState build() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchData(1);
    });
    return const PaginatedState();
  }

  /// fetch data
  Future<void> fetchData(int page) async {
    if (state.status != PaginatedStatus.initLoading) {
      state = state.copyWith(status: PaginatedStatus.loading);
    }
    await Future.delayed(
      const Duration(seconds: 3),
      () {
        List<String> initList = [];
        if (page == 1) {
          initList.addAll(item1);
        }
        if (page == 2) {
          initList.addAll(items2);
        }
        if (page == 3) {
          initList.addAll(items3);
        }
        state = state.copyWith(
          status: PaginatedStatus.loaded,
          data: [
            ...state.data,
            ...initList,
          ],
          hasReachedMax: 3 <= page,
        );
      },
    );
  }
}
