import 'package:reference_parser/reference_parser.dart';

// Merge the existing refs with the new refs. This helps since camera shake
// can cause refs to be missed. With merging, we keep any existing refs and
// add anything new that is recognized so that we get the most complete list
// for the current recognition session.
List<Reference> mergeRefs(List<Reference> prev, List<Reference> next) {
  var refs = [...prev];
  var existing = refs.map((r) => r.shortReference).toSet();

  for (var ref in next) {
    if (!existing.contains(ref.shortReference)) {
      refs.add(ref);
    }
  }

  var verseRefChapters = refs
      .where((r) =>
          r.referenceType != ReferenceType.CHAPTER &&
          r.referenceType != ReferenceType.CHAPTER_RANGE)
      .map((r) => '${r.abbrBook}.${r.startChapterNumber}')
      .toSet();

  // Remove any full chapter refs if there are any verse refs in the same chapter
  refs.removeWhere((r) =>
      r.referenceType == ReferenceType.CHAPTER &&
      verseRefChapters.contains('${r.abbrBook}.${r.startChapterNumber}'));

  return refs;
}
