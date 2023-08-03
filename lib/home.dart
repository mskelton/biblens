import 'package:biblens/data/bible.dart';
import 'package:biblens/views/verse_list_view.dart';
import 'package:biblens/views/verse_recognizer_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reference_parser/reference_parser.dart';
import 'package:xml/xml.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Future<XmlDocument> _data = loadBible();

  bool _isRecognizing = false;
  List<Reference> _references = kDebugMode
      ? [parseReference('John 3:16'), parseReference('1 John 3:1-5')]
      : [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Biblens')),
      floatingActionButton: _isRecognizing
          ? null
          : Container(
              margin: const EdgeInsets.all(8),
              child: SizedBox(
                height: 64,
                width: 64,
                child: FittedBox(
                  child: FloatingActionButton(
                    child: const Icon(Icons.camera_alt),
                    onPressed: () {
                      setState(() {
                        _isRecognizing = true;
                      });
                    },
                  ),
                ),
              ),
            ),
      body: _isRecognizing
          ? VerseRecognizerView(
              onCapture: (refs) {
                setState(() {
                  _isRecognizing = false;
                  _references = refs;
                });
              },
            )
          : FutureBuilder(
              future: _data,
              builder:
                  (BuildContext context, AsyncSnapshot<XmlDocument> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                return VerseListView(
                  data: snapshot.requireData,
                  references: _references,
                );
              },
            ),
    );
  }
}
