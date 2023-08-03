import 'package:flutter/material.dart';
import 'package:reference_parser/reference_parser.dart';
import 'package:xml/xml.dart';

class VerseText extends StatelessWidget {
  const VerseText({
    Key? key,
    required this.reference,
    required this.data,
  }) : super(key: key);

  final Reference reference;
  final XmlDocument data;

  @override
  Widget build(BuildContext context) {
    List<InlineSpan> verses = [];

    // Add all the verses with their corresponding verse numbers
    reference.verses?.asMap().forEach((index, verse) {
      var verseNumber = verse.verseNumber.toString();
      var verseText = getVerseText(data, reference, verse.verseNumber) ??
          "Passage not found";

      if (index != 0) {
        verses.add(
          WidgetSpan(
            child: Transform.translate(
              offset: const Offset(0.0, -5.0),
              child: Text(
                '  $verseNumber',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }

      verses.add(TextSpan(text: (index == 0 ? '' : ' ') + verseText));
    });

    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: verses,
      ),
    );
  }

  String? getVerseText(XmlDocument? data, Reference ref, int verseNumber) {
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

      return verse;
    } catch (e) {
      return null;
    }
  }
}
