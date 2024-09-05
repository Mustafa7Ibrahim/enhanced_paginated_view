/// Represents the type of loading for the enhanced paginated view.
///
/// The [EnhancedLoadingType] enum has two possible values:
/// - `page`: Indicates that the loading is for a new page.
/// - `loadMore`: Indicates that the loading is for loading more data to an existing page.
///
/// This enum is used internally in the enhanced paginated view to determine the type of loading operation.
enum EnhancedLoadingType {
  /// Indicates that the loading is for a new page.
  page,

  /// Indicates that the loading is for loading more data to an existing page.
  loadMore,
}
