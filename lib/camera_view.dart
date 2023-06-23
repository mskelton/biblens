import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';

import '../main.dart';

enum ScreenMode { liveFeed, gallery }

class CameraView extends StatefulWidget {
  const CameraView({
    super.key,
    required this.onCapture,
  });

  final Function(InputImage? inputImage) onCapture;

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  CameraController? _controller;
  InputImage? _image;
  int _cameraIndex = -1;

  @override
  void initState() {
    super.initState();

    _cameraIndex = cameras.indexOf(cameras.firstWhere(
        (element) => element.lensDirection == CameraLensDirection.back));

    _startLiveFeed();
  }

  @override
  void dispose() {
    _stopLiveFeed();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller?.value.isInitialized == false) {
      return Container();
    }

    return _liveFeedBody();
  }

  Future _startLiveFeed() async {
    final camera = cameras[_cameraIndex];

    _controller = CameraController(
      camera,
      // Set to ResolutionPreset.high. Do NOT set it to ResolutionPreset.max
      // because for some phones does NOT work.
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );

    _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }

      _controller?.startImageStream(_processCameraImage);
      setState(() {});
    });
  }

  Future _stopLiveFeed() async {
    await _controller?.stopImageStream();
    await _controller?.dispose();
    _controller = null;
  }

  Widget _liveFeedBody() {
    if (_controller?.value.isInitialized == false) {
      return Container();
    }

    final size = MediaQuery.of(context).size;
    var scale = size.aspectRatio * _controller!.value.aspectRatio;
    if (scale < 1) scale = 1 / scale;

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Transform.scale(
          scale: scale,
          child: Center(
            child: CameraPreview(_controller!),
          ),
        ),
        Positioned(
          bottom: 32,
          left: 50,
          right: 50,
          child: SizedBox(
            width: 72,
            height: 72,
            child: FittedBox(
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                elevation: 2,
                onPressed: () {
                  widget.onCapture(_image);
                },
              ),
            ),
          ),
        )
      ],
    );
  }

  void _processCameraImage(CameraImage image) {
    final camera = cameras[_cameraIndex];
    final rotation =
        InputImageRotationValue.fromRawValue(camera.sensorOrientation);

    if (rotation == null) return;

    // Get image format
    final format = InputImageFormatValue.fromRawValue(image.format.raw);

    // Validate format depending on platform
    // * nv21 for Android
    // * bgra8888 for iOS
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) return;

    // Since format is constraint to nv21 or bgra8888, both only have one plane
    if (image.planes.length != 1) return;
    final plane = image.planes.first;

    // Compose InputImage using bytes
    _image = InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation, // Android
        format: format, // iOS
        bytesPerRow: plane.bytesPerRow, // iOS
      ),
    );
  }
}
