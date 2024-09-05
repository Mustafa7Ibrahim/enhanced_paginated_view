// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$listPHash() => r'47c6d1fa096e73584869ad1f4e884b8e94d43875';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$ListP extends BuildlessAutoDisposeNotifier<PaginatedState> {
  late final int? failPage;

  PaginatedState build({
    int? failPage,
  });
}

/// See also [ListP].
@ProviderFor(ListP)
const listPProvider = ListPFamily();

/// See also [ListP].
class ListPFamily extends Family<PaginatedState> {
  /// See also [ListP].
  const ListPFamily();

  /// See also [ListP].
  ListPProvider call({
    int? failPage,
  }) {
    return ListPProvider(
      failPage: failPage,
    );
  }

  @override
  ListPProvider getProviderOverride(
    covariant ListPProvider provider,
  ) {
    return call(
      failPage: provider.failPage,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'listPProvider';
}

/// See also [ListP].
class ListPProvider
    extends AutoDisposeNotifierProviderImpl<ListP, PaginatedState> {
  /// See also [ListP].
  ListPProvider({
    int? failPage,
  }) : this._internal(
          () => ListP()..failPage = failPage,
          from: listPProvider,
          name: r'listPProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$listPHash,
          dependencies: ListPFamily._dependencies,
          allTransitiveDependencies: ListPFamily._allTransitiveDependencies,
          failPage: failPage,
        );

  ListPProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.failPage,
  }) : super.internal();

  final int? failPage;

  @override
  PaginatedState runNotifierBuild(
    covariant ListP notifier,
  ) {
    return notifier.build(
      failPage: failPage,
    );
  }

  @override
  Override overrideWith(ListP Function() create) {
    return ProviderOverride(
      origin: this,
      override: ListPProvider._internal(
        () => create()..failPage = failPage,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        failPage: failPage,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<ListP, PaginatedState> createElement() {
    return _ListPProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ListPProvider && other.failPage == failPage;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, failPage.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ListPRef on AutoDisposeNotifierProviderRef<PaginatedState> {
  /// The parameter `failPage` of this provider.
  int? get failPage;
}

class _ListPProviderElement
    extends AutoDisposeNotifierProviderElement<ListP, PaginatedState>
    with ListPRef {
  _ListPProviderElement(super.provider);

  @override
  int? get failPage => (origin as ListPProvider).failPage;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
