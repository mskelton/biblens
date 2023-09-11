import 'package:biblens/utils/merge.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reference_parser/reference_parser.dart';

void main() {
  test("merges identical references", () {
    var prev = [Ref('Genesis', 1, 1), Ref('Romans', 1, 1)];
    var next = [Ref('Genesis', 1, 1)];

    expect(
      mergeRefs(prev, next),
      equals([
        Ref('Genesis', 1, 1),
        Ref('Romans', 1, 1),
      ]),
    );
  });

  test("adds new refs", () {
    var prev = [Ref('Genesis', 1, 1), Ref('Romans', 1, 1)];
    var next = [Ref('1 John', 1, 9), Ref('Genesis', 1, 1)];

    expect(
      mergeRefs(prev, next),
      equals([
        Ref('Genesis', 1, 1),
        Ref('Romans', 1, 1),
        Ref('1 John', 1, 9),
      ]),
    );
  });

  test("ignores chapters if a verse with that chapter exists", () {
    var prev = [Ref('Genesis', 1), Ref('Romans', 1)];
    var next = [Ref('Genesis', 2, 12), Ref('Romans', 1, 3)];

    expect(
      mergeRefs(prev, next),
      equals([
        Ref('Genesis', 1),
        Ref('Genesis', 2, 12),
        Ref('Romans', 1, 3),
      ]),
    );
  });
}

// The base Reference doesn't support the equality matcher
class Ref extends Reference {
  Ref(String book, [int? schp, int? svn, int? echp, int? evn])
      : super(book, schp, svn, echp, evn);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Ref &&
          runtimeType == other.runtimeType &&
          reference == other.reference;

  @override
  int get hashCode => reference.hashCode;
}
