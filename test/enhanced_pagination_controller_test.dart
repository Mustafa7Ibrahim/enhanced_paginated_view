import 'package:enhanced_paginated_view/enhanced_paginated_view.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EnhancedPaginationController', () {
    test('page defaults to 1 and no load is in flight', () {
      final controller = EnhancedPaginationController();

      expect(controller.page, 1);
      expect(controller.isLoadingMore, isFalse);

      controller.dispose();
    });

    test('markLoadStarted sets isLoadingMore and notifies listeners', () {
      final controller = EnhancedPaginationController();
      int notifyCount = 0;
      controller.addListener(() => notifyCount++);

      controller.markLoadStarted();

      expect(controller.isLoadingMore, isTrue);
      expect(controller.page, 1);
      expect(notifyCount, 1);

      controller.dispose();
    });

    test('markLoadStarted no-ops when a load is already in flight', () {
      final controller = EnhancedPaginationController();
      int notifyCount = 0;
      controller.addListener(() => notifyCount++);

      controller.markLoadStarted();
      controller.markLoadStarted();
      controller.markLoadStarted();

      expect(controller.isLoadingMore, isTrue);
      expect(notifyCount, 1, reason: 'later calls should be no-ops');

      controller.dispose();
    });

    test('markDataReceived increments the page and clears the lock', () {
      final controller = EnhancedPaginationController();

      controller.markLoadStarted();
      expect(controller.isLoadingMore, isTrue);

      controller.markDataReceived();

      expect(controller.page, 2);
      expect(controller.isLoadingMore, isFalse);

      controller.dispose();
    });

    test('markDataReceived can advance the page across multiple pages', () {
      final controller = EnhancedPaginationController();

      controller
        ..markLoadStarted()
        ..markDataReceived()
        ..markLoadStarted()
        ..markDataReceived()
        ..markLoadStarted()
        ..markDataReceived();

      expect(controller.page, 4);
      expect(controller.isLoadingMore, isFalse);

      controller.dispose();
    });

    test('markLoadFailed clears the lock without advancing the page', () {
      final controller = EnhancedPaginationController();

      controller.markLoadStarted();
      controller.markLoadFailed();

      expect(
        controller.page,
        1,
        reason: 'a failed load must not advance the page',
      );
      expect(controller.isLoadingMore, isFalse);

      controller.dispose();
    });

    test(
      'markLoadFailed after a retry still allows the same page to be requested',
      () {
        final controller = EnhancedPaginationController();

        controller.markLoadStarted();
        controller.markLoadFailed();
        // Retry the same page.
        controller.markLoadStarted();
        controller.markDataReceived();

        expect(controller.page, 2);

        controller.dispose();
      },
    );

    test(
      'reset returns page to the default initialPage and clears the lock',
      () {
        final controller = EnhancedPaginationController();

        controller
          ..markLoadStarted()
          ..markDataReceived() // page -> 2
          ..markLoadStarted(); // lock engaged again

        controller.reset();

        expect(controller.page, 1);
        expect(controller.isLoadingMore, isFalse);

        controller.dispose();
      },
    );

    test('reset notifies listeners', () {
      final controller = EnhancedPaginationController();
      int notifyCount = 0;
      controller.addListener(() => notifyCount++);

      controller.reset();

      expect(notifyCount, 1);

      controller.dispose();
    });

    test('supports a custom initialPage', () {
      final controller = EnhancedPaginationController(initialPage: 2);

      expect(controller.page, 2);

      controller.markLoadStarted();
      controller.markDataReceived();
      expect(controller.page, 3);

      controller.reset();
      expect(
        controller.page,
        2,
        reason: 'reset should return to the custom initialPage',
      );

      controller.dispose();
    });
  });
}
