import 'package:equatable/equatable.dart';
import 'package:example/core/fake_date.dart';
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
    if (state.status != PaginatedStatus.initial) {
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
          listOfData: [
            ...state.listOfData,
            ...initList,
          ],
          isMaxReached: 3 <= page,
        );
      },
    );
  }
}

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
