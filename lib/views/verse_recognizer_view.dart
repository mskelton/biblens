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

  bool _isBusy = false;
  int _refCount = 0;

  @override
  void dispose() async {
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CameraView(
      refCount: _refCount,
      onImage: (image) async {
        if (image == null) return;

        var text = await processImage(image);
        if (text == null) return;

        if (mounted) {
          setState(() {
            _refCount = findRefs(text).length;
          });
        }
      },
      onCapture: (image) async {
        if (image == null) return;
        widget.onCapture();

        var text = await _textRecognizer.processImage(image);
        var refs = findRefs(text);
        widget.onRecognized(refs);
      },
    );
  }

  Future<RecognizedText?> processImage(InputImage image) async {
    if (!mounted || _isBusy) return null;

    _isBusy = true;
    setState(() {});

    var text = await _textRecognizer.processImage(image);

    _isBusy = false;
    if (mounted) {
      setState(() {});
    }

    return text;
  }

  List<Reference> findRefs(RecognizedText recognizedText) {
    return parseAllReferences(recognizedText.text)
        .where((ref) => ref.referenceType != ReferenceType.BOOK)
        .toList(growable: false);
  }
}
