import 'package:biblens/data/librarian.dart';
import 'package:flutter/material.dart';
import 'package:reference_parser/reference_parser.dart';
import 'package:url_launcher/url_launcher.dart';

import 'verse_recognizer_view.dart';

class VerseView extends StatefulWidget {
  const VerseView({Key? key}) : super(key: key);

  @override
  State<VerseView> createState() => _VerseViewState();
}

class _VerseViewState extends State<VerseView> {
  List<Reference> _refs = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 1,
              child: VerseRecognizerView(
                onRecognized: (refs) {
                  setState(() {
                    _refs = refs;
                  });
                },
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _refs.length,
            itemBuilder: (context, index) {
              final ref = _refs[index];

              return ListTile(
                title: Text(ref.toString()),
                onTap: () {
                  final uri = _buildUri(ref);
                  if (uri == null) return;

                  _launchUrl(uri);
                },
              );
            },
          ),
        ),
      ],
    );
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
