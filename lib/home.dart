import 'package:biblens/controllers/shutter_controller.dart';
import 'package:biblens/verse_list_view.dart';
import 'package:biblens/verse_recognizer_view.dart';
import 'package:flutter/material.dart';
import 'package:reference_parser/reference_parser.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final shutterController = ShutterController();
  bool _isRecognizing = false;
  List<Reference> _refs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Biblens')),
      floatingActionButtonLocation:
          _isRecognizing ? FloatingActionButtonLocation.centerFloat : null,
      floatingActionButton: FloatingActionButton(
        backgroundColor: _isRecognizing ? Colors.white : null,
        onPressed: () {
          if (_isRecognizing) {
            shutterController.capture();
            return;
          }

          setState(() {
            _isRecognizing = true;
          });
        },
        child: _isRecognizing ? null : const Icon(Icons.camera_alt),
      ),
      body: _isRecognizing
          ? VerseRecognizerView(
              controller: shutterController,
              onRecognized: (refs) {
                setState(() {
                  _refs = refs;
                  _isRecognizing = false;
                });
              },
            )
          : VerseListView(refs: _refs),
    );
  }
}
