import 'package:biblens/data/librarian.dart';
import 'package:biblens/main.dart';
import 'package:flutter/material.dart';
import 'package:reference_parser/reference_parser.dart';
import 'package:url_launcher/url_launcher.dart';

class VerseListItem extends StatelessWidget {
  const VerseListItem({
    Key? key,
    required this.ref,
  }) : super(key: key);

  final Reference ref;

  @override
  Widget build(BuildContext context) {
    var text = getVerseText(ref);

    return ExpansionTile(
      title: Text(ref.toString()),
      subtitle: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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

  String getVerseText(Reference ref) {
    var data = bibleData!;
    var book = data
        .getElement('bible')
        ?.childElements
        .singleWhere((el) => el.getAttribute('n') == ref.book);

    var chapter = book?.childElements.singleWhere(
        (el) => el.getAttribute('n') == ref.startChapterNumber.toString());

    var verse = chapter?.childElements
        .singleWhere(
            (el) => el.getAttribute('n') == ref.startVerseNumber.toString())
        .firstChild
        ?.value;

    return verse ?? 'Verse not found';
  }

  String? _formatRef(Reference ref) {
    if (ref.osisBook == null) return null;
    var params =
        '${Librarian.getParatextFromOsis(ref.osisBook!)}.${ref.startChapterNumber}.${ref.startVerseNumber}';

    // If the start and end chapter are the same, we can do a version range.
    // Otherwise we have to just use the start chapter/verse.
    if (ref.startChapterNumber == ref.endChapterNumber &&
        ref.startVerseNumber != ref.endVerseNumber) {
      params += '-${ref.endVerseNumber}';
    }

    return params;
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
