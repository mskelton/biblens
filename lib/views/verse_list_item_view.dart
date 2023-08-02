import 'package:biblens/data/librarian.dart';
import 'package:flutter/material.dart';
import 'package:reference_parser/reference_parser.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xml/xml.dart';

class VerseListItem extends StatelessWidget {
  const VerseListItem({
    Key? key,
    required this.ref,
    required this.data,
  }) : super(key: key);

  final Reference ref;
  final XmlDocument data;

  @override
  Widget build(BuildContext context) {
    var text = getVerseText(data, ref);

    return ExpansionTile(
      title: Text(ref.toString()),
      subtitle: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      childrenPadding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
          title: Text(text),
          contentPadding: const EdgeInsets.only(left: 8),
        ),
        TextButton(
          child: const Text('Open in Bible App'),
          onPressed: () {
            final uri = _buildUri(ref);
            if (uri == null) return;

            _launchUrl(uri);
          },
        )
      ],
    );
  }

  String getVerseText(XmlDocument? data, Reference ref) {
    var refChapter = ref.startChapterNumber.toString();
    var refVerses = ref.verses?.map((v) => v.verseNumber.toString());

    try {
      var book = data
          ?.getElement('bible')
          ?.childElements
          .singleWhere((el) => el.getAttribute('n') == ref.book);

      var chapter = book?.childElements
          .singleWhere((el) => el.getAttribute('n') == refChapter)
          .childElements;

      var verses = refVerses == null
          ? chapter?.join(' ')
          : getVerses(refVerses, chapter) ?? '';

      return verses ?? 'Passage not found';
    } catch (e) {
      return 'Passage not found';
    }
  }

  String? getVerses(Iterable<String> refVerses, Iterable<XmlElement>? chapter) {
    return chapter
        ?.where((el) => refVerses.contains(el.getAttribute('n')))
        .map((v) => v.firstChild?.value)
        .join(' ');
  }

  String? _formatRef(Reference ref) {
    final book = ref.osisBook;

    return book == null
        ? null
        : '${Librarian.getParatextFromOsis(book)}.${ref.startChapterNumber}';
  }

  Uri? _buildUri(Reference ref) {
    final reference = _formatRef(ref);

    return reference != null
        ? Uri.parse('youversion://bible?reference=$reference')
        : null;
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
