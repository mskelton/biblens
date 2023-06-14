import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import "verse_view.dart";

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();

  runApp(const BiblensApp());
}

class BiblensApp extends StatelessWidget {
  const BiblensApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biblens'),
      ),
      body: const SafeArea(
        child: VerseView(),
      ),
    );
  }
}
