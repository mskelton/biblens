import 'package:biblens/data/librarian.dart';
import 'package:flutter/material.dart';
import 'package:reference_parser/reference_parser.dart';
import 'package:url_launcher/url_launcher.dart';

class VerseListView extends StatelessWidget {
  const VerseListView({
    Key? key,
    required this.refs,
  }) : super(key: key);

  final List<Reference> refs;

  @override
  Widget build(BuildContext context) {
    if (refs.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 100),
            SizedBox(height: 24),
            Text(
              'No verses recognized',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 8),
            Text(
              'Press the camera button to recognize verses',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: refs.length,
      itemBuilder: (context, index) {
        final ref = refs[index];

        return ListTile(
          title: Text(ref.toString()),
          onTap: () {
            final uri = _buildUri(ref);
            if (uri == null) return;

            _launchUrl(uri);
          },
        );
      },
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
