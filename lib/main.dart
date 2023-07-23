import 'package:biblens/home.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart';

List<CameraDescription> cameras = [];
XmlDocument? bibleData;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();

  runApp(const BiblensApp());
}

class BiblensApp extends StatelessWidget {
  const BiblensApp({super.key});

  @override
  Widget build(BuildContext context) {
    var primary = Colors.indigo[400];
    var accent = Colors.teal[400];

    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColorDark: primary,
        appBarTheme: AppBarTheme(
          backgroundColor: primary,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: accent),
        ),
        expansionTileTheme: ExpansionTileThemeData(
          textColor: Colors.white,
          iconColor: accent,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: primary,
          foregroundColor: Colors.white,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const Home(),
    );
  }
}
