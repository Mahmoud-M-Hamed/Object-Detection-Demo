import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter_tensorflow_ml_project/controller/camera_controller/mutex.dart';
import 'package:flutter_tensorflow_ml_project/controller/object_detector_controller/object_detector.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanController extends GetxController {

  ScanController({
    required this.objectDetectorController,
  });

  var _cameraCount = 0;
  RxBool isCameraReady = false.obs;
  late CameraController cameraController;
  late List<CameraDescription> cameras;
  ObjectDetectorController objectDetectorController;
  final Mutex _mutex = Mutex();


  @override
  void onInit() {
    super.onInit();
    initiateCameraScan().whenComplete(
      () => objectDetectorController.initiateTensorflowModel(),
    );
  }

  @override
  void dispose() {
    stopCamera();
    super.dispose();
  }

  Future<bool> get _onPermissionGranted async => await Permission.camera.request().isGranted;

  CameraController get _getCameraControllerObject => CameraController(
    cameras[0],
    ResolutionPreset.max,
    imageFormatGroup: ImageFormatGroup.jpeg,
  );

  void onCameraReady() => isCameraReady.value = true;

  void onCameraError() => isCameraReady.value = false;

  Future<void> initiateCameraScan() async {

    final bool cameraHasPermission = await _onPermissionGranted;
    if (!cameraHasPermission) return;
    await checkAndInitializeCameras();
    update();
  }

  Future<void> checkAndInitializeCameras() async {
    await checkForAvailableCameras();
    cameraController = _getCameraControllerObject;
    await initializeCameraController();
  }

  Future<void> initializeCameraController() async {
    await cameraController.initialize().whenComplete(() {
      checkAndStartCameraStreaming();
    }).catchError((e) {
      onCameraError();
    });
  }

  void checkAndStartCameraStreaming() {
    startCameraStreaming();
    isCameraReady(true);
    update();
  }

  void startCameraStreaming() {
    cameraController.startImageStream((CameraImage image) {
      _cameraCount++;
      if (_cameraCount % 10 == 0) {
        _cameraCount = 0;
        detectObject(image: image);
      }
    });
    update();
  }

  void detectObject({required CameraImage image}) {
    _mutex.acquire().whenComplete(() {
      objectDetectorController.objectDetector(cameraImage: image).whenComplete(() {
        _mutex.release();
      });
    });
  }

  Future<void> checkForAvailableCameras() async {
    cameras = await availableCameras();
  }

  void stopCamera() {
    cameraController.stopImageStream();
    cameraController.dispose();
  }
}
