import 'package:biblens/data/bible.dart';
import 'package:biblens/views/verse_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reference_parser/reference_parser.dart';
import 'package:xml/xml.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  var data = await loadBible();

  testWidgets('Displays a single verse', (WidgetTester tester) async {
    var ref = parseReference('John 3:16');
    await tester.pumpWidget(VerseListItemTest(data: data, ref: ref));
    expect(find.textContaining('For God so loved'), findsOneWidget);
    expect(find.textContaining('eternal life'), findsOneWidget);
    expect(find.text('Open in Bible App'), findsNothing);

    await tester.tap(find.text('John 3:16'));
    await tester.pump();

    expect(find.textContaining('eternal life'), findsNWidgets(2));
    expect(find.text('Open in Bible App'), findsOneWidget);
  });

  testWidgets('Displays multiple verses', (WidgetTester tester) async {
    var ref = parseReference('John 3:16-17');
    await tester.pumpWidget(VerseListItemTest(data: data, ref: ref));

    expect(find.textContaining('For God so loved'), findsOneWidget);
    expect(find.textContaining('condemn the world'), findsOneWidget);
    expect(find.text('Open in Bible App'), findsNothing);

    await tester.tap(find.text('John 3:16-17'));
    await tester.pump();

    expect(find.textContaining('condemn the world'), findsNWidgets(2));
    expect(find.textContaining('eternal life'), findsNWidgets(2));
    expect(find.text('Open in Bible App'), findsOneWidget);
  });

  testWidgets('Handles invalid references', (WidgetTester tester) async {
    var ref = Reference("Oops", 1, 1, 1, 1);
    await tester.pumpWidget(VerseListItemTest(data: data, ref: ref));

    expect(find.textContaining('Passage not found'), findsOneWidget);
    expect(find.text('Open in Bible App'), findsNothing);

    await tester.tap(find.text('Oops 1:1'));
    await tester.pump();

    expect(find.text('Open in Bible App'), findsNothing);
  }, skip: true);
}

class VerseListItemTest extends StatelessWidget {
  const VerseListItemTest({
    Key? key,
    required this.data,
    required this.ref,
  }) : super(key: key);

  final XmlDocument data;
  final Reference ref;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: VerseListView(
          data: data,
          refs: [ref],
        ),
      ),
    );
  }
}
