import 'package:biblens/home.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

List<CameraDescription> cameras = [];
Color appColor = const Color(0xFF565BD8);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();

  runApp(const BiblensApp());
}

class BiblensApp extends StatelessWidget {
  const BiblensApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColorDark: appColor,
        appBarTheme: AppBarTheme(
          backgroundColor: appColor,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: appColor,
          foregroundColor: Colors.white,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const Home(),
    );
  }
}
