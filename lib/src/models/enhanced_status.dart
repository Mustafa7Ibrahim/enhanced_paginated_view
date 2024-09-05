/// Represents the status of an enhanced paginated view.
///
/// The possible values are:
/// - `loading`: Indicates that the view is currently loading data.
/// - `loaded`: Indicates that the view has successfully loaded data.
/// - `error`: Indicates that an error occurred while loading data.
enum EnhancedStatus {
  /// Indicates that the view is currently loading data.
  loading,

  /// Indicates that the view has successfully loaded data.
  loaded,

  /// Indicates that an error occurred while loading data.
  error,
}
