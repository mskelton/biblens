import 'package:biblens/views/verse_list_item_view.dart';
import 'package:flutter/material.dart';
import 'package:reference_parser/reference_parser.dart';
import 'package:xml/xml.dart';

class VerseListView extends StatefulWidget {
  const VerseListView({
    Key? key,
    required this.refs,
  }) : super(key: key);

  final List<Reference> refs;

  @override
  State<VerseListView> createState() => _VerseListViewState();
}

class _VerseListViewState extends State<VerseListView> {
  Future<XmlDocument>? _data;

  @override
  Widget build(BuildContext context) {
    if (widget.refs.isEmpty) {
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

    _data ??= loadBible(context);

    return FutureBuilder(
      future: _data,
      builder: (BuildContext context, AsyncSnapshot<XmlDocument> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: widget.refs.length,
          itemBuilder: (context, index) {
            return VerseListItem(
              data: snapshot.requireData,
              ref: widget.refs[index],
            );
          },
        );
      },
    );
  }
}
