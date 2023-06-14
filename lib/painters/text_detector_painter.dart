import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:reference_parser/reference_parser.dart';

class TextRecognizerPainter extends CustomPainter {
  TextRecognizerPainter(
    this.recognizedText,
    this.absoluteImageSize,
    this.rotation,
  );

  final RecognizedText recognizedText;
  final Size absoluteImageSize;
  final InputImageRotation rotation;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.lightGreenAccent;

    final Paint background = Paint()..color = const Color(0x99000000);

    final ParagraphBuilder builder = ParagraphBuilder(
      ParagraphStyle(
        textAlign: TextAlign.left,
        fontSize: 16,
        textDirection: TextDirection.ltr,
      ),
    );

    builder.pushStyle(ui.TextStyle(
      color: Colors.lightGreenAccent,
      background: background,
    ));

    var refs = parseAllReferences(recognizedText.text);
    for (final ref in refs) {
      final reference = ref.reference;

      if (reference != null && ref.referenceType != ReferenceType.BOOK) {
        builder.addText('$reference\n');
      }
    }

    builder.pop();

    canvas.drawRect(
      const Rect.fromLTRB(0, 0, 0, 0),
      paint,
    );

    canvas.drawParagraph(
      builder.build()
        ..layout(const ParagraphConstraints(
          width: 300,
        )),
      const Offset(0, 0),
    );
  }

  @override
  bool shouldRepaint(TextRecognizerPainter oldDelegate) {
    return oldDelegate.recognizedText != recognizedText;
  }
}
