import 'package:biblens/views/verse_list_item_view.dart';
import 'package:flutter/material.dart';
import 'package:reference_parser/reference_parser.dart';
import 'package:xml/xml.dart';

class VerseListView extends StatelessWidget {
  final XmlDocument data;

  final List<Reference> references;
  const VerseListView({
    Key? key,
    required this.data,
    required this.references,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (references.isEmpty) {
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
      padding: const EdgeInsets.only(bottom: 140),
      itemCount: references.length,
      itemBuilder: (context, index) {
        return VerseListItem(
          data: data,
          reference: references[index],
        );
      },
    );
  }
}
