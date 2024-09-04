/// Represents the type of view for the enhanced paginated view.
///
/// The [EnhancedViewType] enum defines two possible values:
/// - `slivers`: Represents a sliver-based view.
/// - `box`: Represents a box-based view.
///
/// This enum is used internally by the `enhanced_paginated_view` package.
/// It allows users to specify the type of view they want to use when
/// creating an enhanced paginated view.
///
/// Example usage:
/// ```dart
/// EnhancedViewType viewType = EnhancedViewType.slivers;
/// ```
enum EnhancedViewType {
  sliver,
  box;
}
