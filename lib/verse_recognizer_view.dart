import 'package:biblens/controllers/shutter_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:reference_parser/reference_parser.dart';

import 'camera_view.dart';

class VerseRecognizerView extends StatefulWidget {
  const VerseRecognizerView({
    super.key,
    required this.onRecognized,
    required this.controller,
  });

  final Function(List<Reference> reference) onRecognized;
  final ShutterController controller;

  @override
  State<VerseRecognizerView> createState() => _VerseRecognizerViewState();
}

class _VerseRecognizerViewState extends State<VerseRecognizerView> {
  final TextRecognizer _textRecognizer =
      TextRecognizer(script: TextRecognitionScript.latin);
  bool _canProcess = true;
  bool _isBusy = false;

  @override
  void dispose() async {
    _canProcess = false;
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CameraView(
      shutterController: widget.controller,
    );
  }

  Future<void> processImage(InputImage inputImage) async {
    if (!_canProcess || _isBusy) return;

    _isBusy = true;
    setState(() {});

    final recognizedText = await _textRecognizer.processImage(inputImage);
    final refs = parseAllReferences(recognizedText.text)
        .where((ref) => ref.referenceType != ReferenceType.BOOK)
        .toList(growable: false);

    if (refs.isNotEmpty) {
      widget.onRecognized(refs);
    }

    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}
