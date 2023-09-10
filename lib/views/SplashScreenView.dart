import 'package:flutter/material.dart';

class SplashScreenView extends StatelessWidget {
  const SplashScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.camera, size: 100),
          SizedBox(height: 24),
          Text(
            'Welcome to Biblens',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 8),
          Text(
            'Press the camera button to recognize verses',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
