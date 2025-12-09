import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class CameraService {

  List<CameraDescription> cameras = [];
  int selectedCameraIndex = 0;

  CameraController? cameraController;
  CameraController? get controller => cameraController;

  static const MethodChannel _platform = MethodChannel('com.example/capture');


  Future<void> initialize() async {
    await _getCaptureMessage();
    await _setupCameraController();
  }

  Future<void> handleAppLifecycleState(AppLifecycleState state) async {
    // if (cameraController == null || cameraController?.value.isInitialized == false) return;
    debugPrint('Camera lifecycle: $state');
    // if (state == AppLifecycleState.inactive) {
    //   await cameraController?.dispose();
    // } else
      if (state == AppLifecycleState.resumed) {
        if (cameraController == null ||
            !cameraController!.value.isInitialized) {
          await _setupCameraController();
        }
    }
  }

  Future<void> _getCaptureMessage() async {
    try {
      final logResult = await _platform.invokeMethod<String>('captureMessage');
      debugPrint('Log Result from Native :- - - $logResult - - -');
    } catch (e) {
      debugPrint('Error calling native captureMessage: $e');
    }
  }

  Future<void> _setupCameraController() async {
    try {
      cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        cameraController = CameraController(
          cameras[selectedCameraIndex],
          ResolutionPreset.high,
        );
        await cameraController!.initialize();
      }
    } catch (e) {
      debugPrint('fetching error: $e');
    }
  }

  Future<void> toggleCamera() async {
    if (cameras.length < 2) return;
    selectedCameraIndex = (selectedCameraIndex == 0) ? 1 : 0;
    await cameraController?.dispose();

    cameraController = CameraController(
      cameras[selectedCameraIndex],
      ResolutionPreset.high,
    );
    try {
      await cameraController!.initialize();
    } catch (e) {
      debugPrint('initializing error: $e');
    }
  }

  // Returns captured file or null if failed
  Future<XFile?> takePicture() async {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      debugPrint('Camera controller not initialized.');
      return null;
    }try {
      final XFile picture = await cameraController!.takePicture();
      await _getCaptureMessage();
      debugPrint('Photo Clicked - ${picture.path}');
      return picture;
    } catch (e) {
      debugPrint('taking picture error: $e');
      return null;
    }
  }

  void dispose() {
    cameraController?.dispose();
  }
}
