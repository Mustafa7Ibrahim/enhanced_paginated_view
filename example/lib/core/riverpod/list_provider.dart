import 'package:enhanced_paginated_view/enhanced_paginated_view.dart';
import 'package:example/core/fake_date.dart';
import 'package:example/core/bloc/paginated_bloc.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'list_provider.g.dart';

@riverpod
class ListP extends _$ListP {
  @override
  PaginatedState build({int? failPage}) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => fetchData(1, failPage: failPage),
    );
    return const PaginatedState();
  }

  /// fetch data
  Future<void> fetchData(int page, {int? failPage}) async {
    state = state.copyWith(status: EnhancedStatus.loading);

    await Future.delayed(
      const Duration(seconds: 1),
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
          status: EnhancedStatus.loaded,
          data: [...state.data, ...initList],
          hasReachedMax: 3 <= page,
        );
      },
    );
  }
}
