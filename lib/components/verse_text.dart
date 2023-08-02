import 'package:flutter/material.dart';
import 'package:reference_parser/reference_parser.dart';
import 'package:xml/xml.dart';

class VerseText extends StatelessWidget {
  const VerseText({
    Key? key,
    required this.ref,
    required this.data,
  }) : super(key: key);

  final Reference ref;
  final XmlDocument data;

  @override
  Widget build(BuildContext context) {
    // Single verses don't require verse numbers
    if (ref.verses?.length == 1) {
      return Text(getVerseText(data, ref, ref.startVerse.verseNumber));
    }

    List<InlineSpan> verses = [];

    // Add all the verses with their corresponding verse numbers
    ref.verses?.asMap().forEach((index, verse) {
      var verseNumber = verse.verseNumber.toString();
      var verseText = getVerseText(data, ref, verse.verseNumber);

      verses.add(
        WidgetSpan(
          child: Transform.translate(
            offset: const Offset(0.0, -5.0),
            child: Text(
              (index == 0 ? '' : '  ') + verseNumber,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );

      verses.add(TextSpan(text: ' $verseText'));
    });

    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: verses,
      ),
    );
  }

  String getVerseText(XmlDocument? data, Reference ref, int verseNumber) {
    var refChapter = ref.startChapterNumber.toString();

    try {
      var book = data
          ?.getElement('bible')
          ?.childElements
          .singleWhere((el) => el.getAttribute('n') == ref.book);

      var chapter = book?.childElements
          .singleWhere((el) => el.getAttribute('n') == refChapter)
          .childElements;

      var verse = chapter
          ?.singleWhere((el) => el.getAttribute('n') == verseNumber.toString())
          .firstChild
          ?.value;

      return verse ?? "Passage not found";
    } catch (e) {
      return 'Passage not found';
    }
  }
}
