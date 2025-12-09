import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';

import '../services/camera_service.dart';
import 'gallery_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  late final CameraService _cameraService;
  List<String> images = [];
  CameraController? get _controller => _cameraService.controller;
  int selectedCameraIndex = 0;

  // Future<void> _getCaptureMessage() async {
  //   final logResult = await platform.invokeMethod<String>('captureMessage');
  //   debugPrint('Log Result from Native :- - - $logResult - - -');
  // }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _cameraService.handleAppLifecycleState(state).then((_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _cameraService = CameraService();
    _cameraService.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  Future<void> _toggleCamera() async {
    await _cameraService.toggleCamera();
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _takePicture() async {
    final picture = await _cameraService.takePicture();
    if (picture == null) return;

    await Gal.putImage(picture.path); // save to gallery
    setState(() {
      images.add(picture.path);
    });
    debugPrint('Photo Clicked - ${picture.path}');
    if (mounted) {
      ScaffoldMessenger.of(context,).showSnackBar(const SnackBar(content: Text('Photo saved!')));
    }else {
      return;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (_controller == null ||
        _controller?.value.isInitialized == false) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      // appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: .spaceBetween,
                children: const [
                  Icon(Icons.flash_on),
                  Icon(Icons.hd_outlined) /*Icon(Icons.settings)*/,
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    // image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
                    // color: Colors.grey,
                    gradient: LinearGradient(
                      begin: .topLeft,
                      end: .bottomRight,
                      colors: [
                        Colors.grey.shade800,
                        Colors.black,
                        Colors.grey.shade800,
                      ],
                    ),
                    borderRadius: .circular(12),
                  ),
                  child: CameraPreview(_controller!),
                ),
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              child: Row(
                crossAxisAlignment: .center,
                mainAxisAlignment: .spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GalleryScreen(images: images),
                      ),
                    ),
                    child: Container(
                      width: 50,
                      height: 50,
                      // padding: EdgeInsets.all(4),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        // image: images.isNotEmpty
                        //     ? DecorationImage(
                        //   image: FileImage(File(images.last)),
                        //   fit: BoxFit.cover,
                        // ): null,
                        borderRadius: BorderRadius.circular(10),
                        // border: Border.all(width: 2, color: Colors.white),
                      ),
                      child: images.isNotEmpty
                          ? Image.file(File(images.last), fit: .cover)
                          : Icon(Icons.image),
                    ),
                  ),
                  GestureDetector(
                    onTap: _takePicture,
                    // onTap: () async {
                    //   XFile picture = await cameraController!.takePicture();
                    //   Gal.putImage(picture.path);
                    //   images.add(picture.path);
                    //
                    //   debugPrint('Photo Clicked');
                    // },
                    child: Container(
                      width: 72,
                      height: 72,
                      padding: EdgeInsets.all(4),
                      decoration: ShapeDecoration(
                        shape: const CircleBorder(
                          side: BorderSide(color: Colors.white, width: 4),
                        ),
                      ),
                      child: CircleAvatar(
                        backgroundColor: Colors.redAccent,
                        child: Icon(Icons.photo_camera_rounded),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: IconButton(
                      onPressed: _toggleCamera,
                      icon: Icon(Icons.flip_camera_android_rounded),
                      iconSize: 34,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
