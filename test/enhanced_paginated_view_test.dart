import 'package:enhanced_paginated_view/enhanced_paginated_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/pagination_harness.dart';

void main() {
  group('Rendering', () {
    testWidgets('shows a full-page loading widget when empty + loading', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapInApp(
          PaginationHarness(
            initialData: const [],
            initialStatus: EnhancedStatus.loading,
            onLoadMore: (_) {},
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(ListView), findsNothing);
      expect(find.textContaining('item-'), findsNothing);
    });

    testWidgets('shows a full-page error widget when empty + error', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapInApp(
          PaginationHarness(
            initialData: const [],
            initialStatus: EnhancedStatus.error,
            onLoadMore: (_) {},
            config: const EnhancedConfig(
              errorPageConfig: ErrorPageConfig(title: 'Full Page Error'),
            ),
          ),
        ),
      );

      expect(find.text('Full Page Error'), findsOneWidget);
      expect(find.byType(ListView), findsNothing);
    });

    testWidgets('renders items when loaded', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapInApp(
          PaginationHarness(
            initialData: const [0, 1, 2],
            initialStatus: EnhancedStatus.loaded,
            onLoadMore: (_) {},
          ),
        ),
      );

      expect(find.text('item-0'), findsOneWidget);
      expect(find.text('item-1'), findsOneWidget);
      expect(find.text('item-2'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets(
      'renders items plus a footer loading indicator when non-empty + loading',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          wrapInApp(
            PaginationHarness(
              initialData: const [0, 1, 2],
              initialStatus: EnhancedStatus.loading,
              onLoadMore: (_) {},
            ),
          ),
        );

        expect(find.text('item-0'), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets(
      'renders items plus a footer error widget when non-empty + error',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          wrapInApp(
            PaginationHarness(
              initialData: const [0, 1, 2],
              initialStatus: EnhancedStatus.error,
              onLoadMore: (_) {},
              config: const EnhancedConfig(
                errorLoadMoreConfig: ErrorLoadMoreConfig(title: 'Footer Error'),
              ),
            ),
          ),
        );

        expect(find.text('item-0'), findsOneWidget);
        expect(find.text('Footer Error'), findsOneWidget);
      },
    );

    testWidgets('shows the empty widget when loaded with no data', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapInApp(
          PaginationHarness(
            initialData: const [],
            initialStatus: EnhancedStatus.loaded,
            onLoadMore: (_) {},
            config: const EnhancedConfig(
              emptyWidgetConfig: EmptyWidgetConfig(title: 'Nothing Here'),
            ),
          ),
        ),
      );

      expect(find.text('Nothing Here'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });

  group('Deduplication', () {
    testWidgets('removes duplicate items before building by default', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapInApp(
          PaginationHarness(
            initialData: const [1, 1, 2, 3, 3, 3],
            initialStatus: EnhancedStatus.loaded,
            onLoadMore: (_) {},
          ),
        ),
      );

      expect(find.textContaining('item-').evaluate().length, 3);
      expect(find.text('item-1'), findsOneWidget);
      expect(find.text('item-2'), findsOneWidget);
      expect(find.text('item-3'), findsOneWidget);
    });

    testWidgets(
      'keeps duplicate items when removeDuplicatedItems is false',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          wrapInApp(
            PaginationHarness(
              initialData: const [1, 1, 2],
              initialStatus: EnhancedStatus.loaded,
              onLoadMore: (_) {},
              config: const EnhancedConfig(removeDuplicatedItems: false),
            ),
          ),
        );

        expect(find.textContaining('item-').evaluate().length, 3);
      },
    );
  });

  group('Load-more scroll trigger (box)', () {
    testWidgets('scrolling to the end triggers onLoadMore with the current page', (
      WidgetTester tester,
    ) async {
      final List<int> calls = [];

      await tester.pumpWidget(
        wrapInApp(
          PaginationHarness(
            initialData: List<int>.generate(20, (i) => i),
            initialStatus: EnhancedStatus.loaded,
            onLoadMore: calls.add,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -3000),
      );
      await tester.pumpAndSettle();

      expect(calls, [1]);
    });

    testWidgets(
      'scrolling only slightly from the top of a tall list does NOT trigger onLoadMore',
      (WidgetTester tester) async {
        final List<int> calls = [];

        await tester.pumpWidget(
          wrapInApp(
            PaginationHarness(
              initialData: List<int>.generate(20, (i) => i),
              initialStatus: EnhancedStatus.loaded,
              onLoadMore: calls.add,
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.drag(
          find.byType(SingleChildScrollView),
          const Offset(0, -50),
        );
        await tester.pumpAndSettle();

        expect(calls, isEmpty);
      },
    );

    testWidgets(
      'does not call onLoadMore again while a load is already in flight',
      (WidgetTester tester) async {
        final List<int> calls = [];

        await tester.pumpWidget(
          wrapInApp(
            PaginationHarness(
              initialData: List<int>.generate(20, (i) => i),
              initialStatus: EnhancedStatus.loaded,
              onLoadMore: calls.add,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // First drag reaches the end and triggers exactly one request; the
        // in-flight lock is now engaged and the consumer has not yet
        // responded (status is still `loaded`).
        await tester.drag(
          find.byType(SingleChildScrollView),
          const Offset(0, -3000),
        );
        await tester.pumpAndSettle();
        expect(calls, [1]);

        // Further scroll activity at the end must not produce duplicate
        // requests while the lock is held.
        await tester.drag(
          find.byType(SingleChildScrollView),
          const Offset(0, -500),
        );
        await tester.pumpAndSettle();

        expect(calls, [1]);
      },
    );

    testWidgets('hasReachedMax suppresses load-more even at the end of the list', (
      WidgetTester tester,
    ) async {
      final List<int> calls = [];

      await tester.pumpWidget(
        wrapInApp(
          PaginationHarness(
            initialData: List<int>.generate(20, (i) => i),
            initialStatus: EnhancedStatus.loaded,
            initialHasReachedMax: true,
            onLoadMore: calls.add,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -3000),
      );
      await tester.pumpAndSettle();

      expect(calls, isEmpty);
    });

    testWidgets(
      'regression: page advances after a consumer-driven initial load, '
      'so the next scroll-triggered request asks for page 2 (not page 1)',
      (WidgetTester tester) async {
        final List<int> calls = [];
        final GlobalKey<PaginationHarnessState> key = GlobalKey();

        // Start empty + loading, as a consumer (e.g. a bloc) kicking off its
        // own initial page-1 fetch would.
        await tester.pumpWidget(
          wrapInApp(
            PaginationHarness(
              key: key,
              initialData: const [],
              initialStatus: EnhancedStatus.loading,
              onLoadMore: calls.add,
            ),
          ),
        );
        // Note: pumpAndSettle cannot be used here because the full-page
        // loading state renders an indefinitely-animating
        // CircularProgressIndicator.
        await tester.pump();
        expect(calls, isEmpty);

        // The consumer's page-1 fetch completes: loading -> loaded. This
        // status transition must advance the controller's page even though
        // `onLoadMore` was never called for it.
        key.currentState!.emit(
          status: EnhancedStatus.loaded,
          data: List<int>.generate(20, (i) => i),
        );
        await tester.pumpAndSettle();

        // Now the user scrolls to the end; the resulting request must ask
        // for page 2, proving the page did not stay stuck at 1.
        await tester.drag(
          find.byType(SingleChildScrollView),
          const Offset(0, -3000),
        );
        await tester.pumpAndSettle();

        expect(calls, [2]);
      },
    );

    testWidgets(
      'automatically requests more when the first page does not fill the viewport',
      (WidgetTester tester) async {
        final List<int> calls = [];

        await tester.pumpWidget(
          wrapInApp(
            PaginationHarness(
              initialData: const [0, 1], // 2 * 100px << 400px viewport
              initialStatus: EnhancedStatus.loaded,
              onLoadMore: calls.add,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(calls, [1]);
      },
    );

    testWidgets(
      'does NOT auto-request more when the first page does not fill the '
      'viewport but hasReachedMax is true',
      (WidgetTester tester) async {
        final List<int> calls = [];

        await tester.pumpWidget(
          wrapInApp(
            PaginationHarness(
              initialData: const [0, 1],
              initialStatus: EnhancedStatus.loaded,
              initialHasReachedMax: true,
              onLoadMore: calls.add,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(calls, isEmpty);
      },
    );
  });

  group('Load-more scroll trigger (slivers)', () {
    testWidgets('scrolling to the end triggers onLoadMore with the current page', (
      WidgetTester tester,
    ) async {
      final List<int> calls = [];

      await tester.pumpWidget(
        wrapInApp(
          PaginationHarness(
            initialData: List<int>.generate(20, (i) => i),
            initialStatus: EnhancedStatus.loaded,
            onLoadMore: calls.add,
            useSlivers: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.drag(
        find.byType(CustomScrollView),
        const Offset(0, -3000),
      );
      await tester.pumpAndSettle();

      expect(calls, [1]);
    });

    testWidgets('renders items and a footer error widget', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapInApp(
          PaginationHarness(
            initialData: const [0, 1, 2],
            initialStatus: EnhancedStatus.error,
            onLoadMore: (_) {},
            useSlivers: true,
            config: const EnhancedConfig(
              errorLoadMoreConfig: ErrorLoadMoreConfig(title: 'Sliver Footer Error'),
            ),
          ),
        ),
      );

      expect(find.text('item-0'), findsOneWidget);
      expect(find.text('Sliver Footer Error'), findsOneWidget);
    });
  });

  group('Pull to refresh', () {
    testWidgets(
      'wraps content in a RefreshIndicator when onRefresh is provided (forward)',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          wrapInApp(
            PaginationHarness(
              initialData: const [0, 1, 2],
              initialStatus: EnhancedStatus.loaded,
              onLoadMore: (_) {},
              direction: EnhancedViewDirection.forward,
              onRefresh: () async {},
            ),
          ),
        );

        expect(find.byType(RefreshIndicator), findsOneWidget);
      },
    );

    testWidgets(
      'wraps content in a RefreshIndicator when onRefresh is provided (reverse)',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          wrapInApp(
            PaginationHarness(
              initialData: const [0, 1, 2],
              initialStatus: EnhancedStatus.loaded,
              onLoadMore: (_) {},
              direction: EnhancedViewDirection.reverse,
              onRefresh: () async {},
            ),
          ),
        );

        expect(find.byType(RefreshIndicator), findsOneWidget);
      },
    );

    testWidgets('does not show a RefreshIndicator when onRefresh is absent', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapInApp(
          PaginationHarness(
            initialData: const [0, 1, 2],
            initialStatus: EnhancedStatus.loaded,
            onLoadMore: (_) {},
          ),
        ),
      );

      expect(find.byType(RefreshIndicator), findsNothing);
    });

    testWidgets('uses a provided refreshBuilder instead of the default RefreshIndicator', (
      WidgetTester tester,
    ) async {
      int refreshBuilderCalls = 0;

      await tester.pumpWidget(
        wrapInApp(
          PaginationHarness(
            initialData: const [0, 1, 2],
            initialStatus: EnhancedStatus.loaded,
            onLoadMore: (_) {},
            onRefresh: () async {},
            refreshBuilder: (context, onRefresh, child) {
              refreshBuilderCalls++;
              return Column(
                children: [
                  const Text('custom-refresh', key: Key('custom-refresh-marker')),
                  Expanded(child: child),
                ],
              );
            },
          ),
        ),
      );

      expect(find.byType(RefreshIndicator), findsNothing);
      expect(find.byKey(const Key('custom-refresh-marker')), findsOneWidget);
      expect(refreshBuilderCalls, greaterThan(0));
    });

    testWidgets(
      'pulling to refresh invokes onRefresh and resets the pagination controller',
      (WidgetTester tester) async {
        final EnhancedPaginationController controller =
            EnhancedPaginationController();
        addTearDown(controller.dispose);

        int refreshCalls = 0;
        final GlobalKey<PaginationHarnessState> key = GlobalKey();

        await tester.pumpWidget(
          wrapInApp(
            PaginationHarness(
              key: key,
              initialData: List<int>.generate(20, (i) => i),
              initialStatus: EnhancedStatus.loaded,
              onLoadMore: (_) {},
              controller: controller,
              onRefresh: () async {
                refreshCalls++;
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Advance the controller past page 1 by simulating a completed
        // load-more round trip, so we can prove refresh resets it.
        key.currentState!.emit(status: EnhancedStatus.loading);
        await tester.pump();
        key.currentState!.emit(
          status: EnhancedStatus.loaded,
          data: List<int>.generate(25, (i) => i),
        );
        await tester.pumpAndSettle();
        expect(controller.page, 2);

        await tester.fling(
          find.byType(RefreshIndicator),
          const Offset(0, 300),
          1000,
        );
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
        await tester.pumpAndSettle();

        expect(refreshCalls, 1);
        expect(controller.page, 1);
      },
    );
  });

  group('Load-more lock recovery (regression)', () {
    testWidgets(
      'a loaded->error fast-fail (no intervening loading) releases the '
      'in-flight lock so a later scroll can retry',
      (WidgetTester tester) async {
        final List<int> calls = [];
        final GlobalKey<PaginationHarnessState> key = GlobalKey();

        await tester.pumpWidget(
          wrapInApp(
            PaginationHarness(
              key: key,
              initialData: List<int>.generate(20, (i) => i),
              initialStatus: EnhancedStatus.loaded,
              onLoadMore: calls.add,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Scroll to the end to trigger the first load-more; the in-flight
        // lock is now engaged (status stays `loaded`).
        await tester.drag(
          find.byType(SingleChildScrollView),
          const Offset(0, -3000),
        );
        await tester.pumpAndSettle();
        expect(calls, [1]);

        // The consumer fast-fails directly from `loaded` to `error` without
        // ever emitting `loading`. Before the fix this left the lock stuck
        // `true`, permanently disabling automatic load-more.
        key.currentState!.emit(status: EnhancedStatus.error);
        await tester.pump();

        // The consumer retries and returns to `loaded` (still the same page,
        // since the previous attempt failed).
        key.currentState!.emit(status: EnhancedStatus.loaded);
        await tester.pumpAndSettle();

        // Scroll back to the top, then down to the end again to generate a
        // fresh end-of-list scroll event (the list was already at the end
        // from the first drag). This must trigger a new request, proving the
        // lock was released. The page is still 1 because the load failed.
        await tester.drag(
          find.byType(SingleChildScrollView),
          const Offset(0, 3000),
        );
        await tester.pumpAndSettle();
        await tester.drag(
          find.byType(SingleChildScrollView),
          const Offset(0, -3000),
        );
        await tester.pumpAndSettle();

        expect(calls, [1, 1]);
      },
    );
  });

  group('Nested scrollable (regression)', () {
    testWidgets(
      'scrolling an inner scrollable to its end does not trigger the outer '
      'load-more',
      (WidgetTester tester) async {
        final List<int> calls = [];

        await tester.pumpWidget(
          wrapInApp(
            EnhancedPaginatedView<int>(
              delegate: EnhancedDelegate<int>(
                listOfData: List<int>.generate(20, (i) => i),
                status: EnhancedStatus.loaded,
              ),
              hasReachedMax: false,
              onLoadMore: calls.add,
              builder: (
                List<int> items,
                ScrollPhysics physics,
                bool reverse,
                bool shrinkWrap,
              ) {
                return ListView.builder(
                  physics: physics,
                  reverse: reverse,
                  shrinkWrap: shrinkWrap,
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) => SizedBox(
                    height: 100,
                    child: ListView.builder(
                      key: ValueKey<String>('inner-$index'),
                      scrollDirection: Axis.horizontal,
                      itemCount: 10,
                      itemBuilder: (BuildContext context, int i) =>
                          const SizedBox(width: 200),
                    ),
                  ),
                );
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Drive the first item's inner horizontal list to its own end. Its
        // scroll notifications bubble up to the outer NotificationListener
        // with a non-zero depth and must be ignored.
        await tester.drag(
          find.byKey(const ValueKey<String>('inner-0')),
          const Offset(-3000, 0),
        );
        await tester.pumpAndSettle();

        expect(calls, isEmpty);
      },
    );
  });
}
