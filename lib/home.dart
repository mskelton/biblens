import 'package:biblens/views/verse_list_view.dart';
import 'package:biblens/views/verse_recognizer_view.dart';
import 'package:flutter/material.dart';
import 'package:reference_parser/reference_parser.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isRecognizing = false;
  List<Reference> _refs = [];

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
                  _refs = refs;
                });
              },
            )
          : VerseListView(refs: _refs),
    );
  }
}
