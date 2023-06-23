import 'package:biblens/views/camera_view.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:reference_parser/reference_parser.dart';

class VerseRecognizerView extends StatefulWidget {
  const VerseRecognizerView({
    super.key,
    required this.onCapture,
    required this.onRecognized,
  });

  final Function onCapture;
  final Function(List<Reference> reference) onRecognized;

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
      onCapture: (image) {
        widget.onCapture();

        if (image == null) return;
        processImage(image);
      },
    );
  }

  Future<void> processImage(InputImage image) async {
    if (!_canProcess || _isBusy) return;

    _isBusy = true;
    setState(() {});

    final recognizedText = await _textRecognizer.processImage(image);
    final refs = parseAllReferences(recognizedText.text)
        .where((ref) => ref.referenceType != ReferenceType.BOOK)
        .toList(growable: false);

    widget.onRecognized(refs);
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}
