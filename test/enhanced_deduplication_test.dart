import 'package:enhanced_paginated_view/enhanced_paginated_view.dart';
import 'package:flutter_test/flutter_test.dart';

class _Person {
  const _Person(this.id, this.name);

  final int id;
  final String name;

  @override
  bool operator ==(Object other) =>
      other is _Person && other.id == id && other.name == name;

  @override
  int get hashCode => Object.hash(id, name);
}

void main() {
  group('removeDuplication', () {
    test('removes duplicate primitives while preserving order', () {
      const List<int> input = [1, 2, 2, 3, 1, 4, 3];

      final List<int> result = input.removeDuplication();

      expect(result, [1, 2, 3, 4]);
    });

    test('returns an empty list for an empty input', () {
      const List<int> input = [];

      expect(input.removeDuplication(), isEmpty);
    });

    test('keeps a list unchanged when there are no duplicates', () {
      const List<int> input = [5, 4, 3, 2, 1];

      expect(input.removeDuplication(), [5, 4, 3, 2, 1]);
    });

    test('uses value equality (==) to detect duplicates', () {
      const List<_Person> input = [
        _Person(1, 'John'),
        _Person(2, 'Alice'),
        _Person(1, 'John'), // duplicate of index 0 by ==
        _Person(3, 'Bob'),
      ];

      final List<_Person> result = input.removeDuplication();

      expect(result.length, 3);
      expect(result[0].name, 'John');
      expect(result[1].name, 'Alice');
      expect(result[2].name, 'Bob');
    });

    test('keeps the first occurrence when duplicates are not adjacent', () {
      const List<String> input = ['a', 'b', 'a', 'c', 'b', 'a'];

      expect(input.removeDuplication(), ['a', 'b', 'c']);
    });
  });

  group('removeDuplicationBy', () {
    test('deduplicates using the selected key, preserving order', () {
      const List<_Person> input = [
        _Person(1, 'John'),
        _Person(2, 'Alice'),
        _Person(1, 'Johnny'), // same id as index 0, different name
        _Person(3, 'Bob'),
        _Person(2, 'Alicia'), // same id as index 1
      ];

      final List<_Person> result = input.removeDuplicationBy((p) => p.id);

      expect(result.length, 3);
      expect(result.map((p) => p.id).toList(), [1, 2, 3]);
      // First occurrence for each key is kept.
      expect(result[0].name, 'John');
      expect(result[1].name, 'Alice');
      expect(result[2].name, 'Bob');
    });

    test('supports a different key type than the element type', () {
      const List<_Person> input = [
        _Person(1, 'John'),
        _Person(2, 'John'), // duplicate name, distinct id
        _Person(3, 'Alice'),
      ];

      final List<_Person> result = input.removeDuplicationBy((p) => p.name);

      expect(result.length, 2);
      expect(result.map((p) => p.name).toList(), ['John', 'Alice']);
    });

    test('returns an empty list for an empty input', () {
      const List<_Person> input = [];

      expect(input.removeDuplicationBy((p) => p.id), isEmpty);
    });

    test('keeps a list unchanged when all keys are unique', () {
      const List<_Person> input = [
        _Person(1, 'John'),
        _Person(2, 'Alice'),
        _Person(3, 'Bob'),
      ];

      final List<_Person> result = input.removeDuplicationBy((p) => p.id);

      expect(result, input);
    });
  });
}
