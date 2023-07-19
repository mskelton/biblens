import 'package:biblens/views/verse_list_item_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:reference_parser/reference_parser.dart';

Future<String> loadBibleData() async {
  return await rootBundle.loadString('assets/translations/ESV.xml');
}

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
        return VerseListItem(ref: refs[index]);
      },
    );
  }
}
