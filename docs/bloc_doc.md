## Bloc Usage

**States**

The `state` is divided into two parts:

- `PaginatedStatus`: An enum class that contains different view statuses.

- `PaginatedState`: A class that holds all the necessary data for state management.

```dart
enum PaginatedStatus { initial, loading, loaded, error }
```

```dart
final class PaginatedState extends Equatable {
  const PaginatedState({
    this.status = PaginatedStatus.initial,
    this.listOfData = const [],
    this.isMaxReached = false,
    this.error,
  });

  final PaginatedStatus status;
  final List<int> listOfData;
  final bool isMaxReached;
  final String? error;

  /// copyWith method is used to copy the current state
  /// and update the required fields.
  PaginatedState copyWith({
    PaginatedStatus? status,
    List<int>? listOfData,
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
```

**Events**

There's a single event to manage the view:

- `FetchDataEvent`: Carries a `page` parameter to load the next page. This parameter is provided by the `EnhancedPaginatedView` widget.

```dart
class FetchDataEvent extends PaginatedEvent {
  const FetchDataEvent({this.page = 1});

  final int page;

  @override
  List<Object> get props => [page];
}
```

**Bloc**

The `bloc` is the central component of the package, responsible for handling view logic and state.

- Private parameters:
  - `_isMaxReached`: Indicates if the last page has been reached.
  - `_maxPageNumber`: Simulated last page number.
  - `_listOfData`: Holds the loaded data for each page.

```dart
  bool _isMaxReached = false;
  final int _maxPageNumber = 5;
  final List<int> _listOfData = [];
```

- Private method `_fetchData` handles the `FetchDataEvent`:
  - Accepts the page from the event.
  - If page is less than \_maxPageNumber, adds 10 new items to \_listOfData and emits the new state.
  - If page equals \_maxPageNumber, sets \_isMaxReached to true and emits the new state.
  - Simulates loading new items using Future.delayed for 3 seconds.
  - Simulates an error for page equal to 3 by emitting an error state.
  - Otherwise, emits the new state with the updated data.

```dart
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
```

**View**

Here's the view responsible for displaying the results and handling different states.

```dart
class BlocView extends StatefulWidget {
  const BlocView({super.key});

  @override
  State<BlocView> createState() => _BlocViewState();
}

class _BlocViewState extends State<BlocView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bloc Example')),
      body: BlocProvider(
        create: (context) => PaginatedBloc()..add(const FetchDataEvent()),
        child: BlocBuilder<PaginatedBloc, PaginatedState>(
          builder: (context, state) {
            if (state.status == PaginatedStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }
            return SafeArea(
              child: EnhancedPaginatedView<int>(
                listOfData: state.listOfData,
                showLoading: state.status == PaginatedStatus.loading,
                showError: state.status == PaginatedStatus.error,
                isMaxReached: state.isMaxReached,
                onLoadMore: (page) {
                  context.read<PaginatedBloc>().add(FetchDataEvent(page: page));
                },
                loadingWidget: const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (page) => Column(
                  children: [
                    Center(child: Text(' ${state.error}')),
                    ElevatedButton(
                      onPressed: () {
                        context
                                .read<PaginatedBloc>()
                                .add(FetchDataEvent(page: page));
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
                builder: (physics, items, shrinkWrap, chatMode) {
                  return ListView.separated(
                    // here we must pass the physics, items and shrinkWrap
                    // that came from the builder function
                    physics: physics,
                    shrinkWrap: shrinkWrap,
                    itemCount: items.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(height: 16);
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text('Item ${index + 1}'),
                        subtitle: Text('Item ${items[index]}'),
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
```
