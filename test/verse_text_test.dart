import 'package:biblens/components/verse_text.dart';
import 'package:biblens/data/bible.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reference_parser/reference_parser.dart';
import 'package:xml/xml.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  var data = await loadBible();

  testWidgets('Hides verse number for single verses',
      (WidgetTester tester) async {
    var ref = parseReference('John 3:16');
    await tester.pumpWidget(VerseTextTest(data: data, reference: ref));
    expect(find.textContaining('For God', findRichText: true), findsOneWidget);
    expect(find.textContaining('16', findRichText: true), findsNothing);
  });

  testWidgets('Hides the first verse number for multiple verses',
      (WidgetTester tester) async {
    var ref = parseReference('John 3:16-17');
    await tester.pumpWidget(VerseTextTest(data: data, reference: ref));
    expect(find.textContaining('For God', findRichText: true), findsOneWidget);
    expect(find.textContaining('16', findRichText: true), findsNothing);
    expect(find.textContaining('17', findRichText: true), findsOneWidget);
  });
}

class VerseTextTest extends StatelessWidget {
  const VerseTextTest({
    Key? key,
    required this.data,
    required this.reference,
  }) : super(key: key);

  final XmlDocument data;
  final Reference reference;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: VerseText(
          data: data,
          reference: reference,
        ),
      ),
    );
  }
}
