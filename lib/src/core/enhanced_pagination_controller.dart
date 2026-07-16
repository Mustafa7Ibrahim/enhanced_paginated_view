import 'package:flutter/foundation.dart';

/// Tracks pagination state for an `EnhancedPaginatedView`.
///
/// It owns two pieces of state:
/// - [page]: the page number that should be passed to the *next*
///   `onLoadMore` call.
/// - [isLoadingMore]: whether a load-more request is currently in flight.
///
/// Consumers may create and own an instance themselves (to read [page] or
/// [isLoadingMore] elsewhere in their UI) and pass it to
/// `EnhancedPaginatedView` via its `controller` parameter. If none is
/// provided, the widget creates and manages one internally.
///
/// Page advancement is driven by the delegate's status *transitions*: the
/// page is only incremented when the consumer's status goes from `loading`
/// to `loaded`. This means the consumer must emit a `loading` status before
/// each `loaded` status for a given page load (including the very first
/// page) for [page] to advance correctly. If a consumer instead preloads
/// the first page (i.e. starts with non-empty data and status `loaded`,
/// with no preceding `loading`), construct this controller with
/// `EnhancedPaginationController(initialPage: 2)` so the next requested
/// page is correct.
class EnhancedPaginationController extends ChangeNotifier {
  /// Creates a new [EnhancedPaginationController].
  ///
  /// The [initialPage] is the first page number that will be requested and
  /// the page [reset] returns to. It defaults to `1`.
  EnhancedPaginationController({int initialPage = 1})
      : _page = initialPage,
        _firstPage = initialPage;

  final int _firstPage;
  int _page;
  bool _isLoadingMore = false;

  /// The page number to pass to the next `onLoadMore` call.
  int get page => _page;

  /// Whether a load-more request is currently in flight.
  bool get isLoadingMore => _isLoadingMore;

  /// Marks that a load-more request has started.
  ///
  /// If a load is already in flight, this is a no-op.
  void markLoadStarted() {
    if (_isLoadingMore) return;
    _isLoadingMore = true;
    notifyListeners();
  }

  /// Marks that data for the current page was received successfully.
  ///
  /// Advances [page] to the next page and clears [isLoadingMore].
  void markDataReceived() {
    _page++;
    _isLoadingMore = false;
    notifyListeners();
  }

  /// Marks that the current page failed to load.
  ///
  /// Clears [isLoadingMore] without advancing [page], so the same page can
  /// be retried.
  void markLoadFailed() {
    _isLoadingMore = false;
    notifyListeners();
  }

  /// Resets pagination back to the first page.
  ///
  /// This is typically invoked when the caller performs a pull-to-refresh.
  void reset() {
    _page = _firstPage;
    _isLoadingMore = false;
    notifyListeners();
  }
}
