import 'package:biblens/views/verse_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reference_parser/reference_parser.dart';

import 'test_asset_bundle.dart';

void main() {
  testWidgets('Displays a single verse', (WidgetTester tester) async {
    var ref = parseReference('John 3:16');
    await tester.pumpWidget(VerseListItemTest(ref: ref));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsNothing);
    // expect(find.textContaining('For God so loved'), findsOneWidget);
    // expect(find.text('Open in Bible App'), findsNothing);
    //
    // await tester.tap(find.text('John 3:16'));
    // await tester.pump();
    //
    // expect(find.textContaining('everlasting life'), findsOneWidget);
    // expect(find.text('Open in Bible App'), findsOneWidget);
  });

  // testWidgets('Displays multiple verses', (WidgetTester tester) async {
  //   var ref = parseReference('John 3:16-17');
  //   await tester.pumpWidget(VerseListItemTest(ref: ref));
  //
  //   expect(find.textContaining('For God so loved'), findsOneWidget);
  //   expect(find.textContaining('condemn the world'), findsNothing);
  //   expect(find.text('Open in Bible App'), findsNothing);
  //
  //   await tester.tap(find.text('John 3:16-17'));
  //   await tester.pump();
  //
  //   expect(find.textContaining('condemn the world'), findsOneWidget);
  //   expect(find.textContaining('everlasting life'), findsOneWidget);
  //   expect(find.text('Open in Bible App'), findsOneWidget);
  // });
  //
  // testWidgets('Handles invalid references', (WidgetTester tester) async {
  //   var ref = Reference("Oops", 1, 1, 1, 1);
  //   await tester.pumpWidget(VerseListItemTest(ref: ref));
  //
  //   expect(find.textContaining('Passage not found'), findsOneWidget);
  //   expect(find.text('Open in Bible App'), findsNothing);
  //
  //   await tester.tap(find.text('John 3:16'));
  //   await tester.pump();
  //
  //   expect(find.text('Open in Bible App'), findsNothing);
  // });
}

class VerseListItemTest extends StatelessWidget {
  const VerseListItemTest({Key? key, required this.ref}) : super(key: key);

  final Reference ref;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultAssetBundle(
        bundle: TestAssetBundle(),
        child: Scaffold(
          body: VerseListView(refs: [ref]),
        ),
      ),
    );
  }
}
