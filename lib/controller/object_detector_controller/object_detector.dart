import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:flutter_tensorflow_ml_project/services/tensorflow_service/tensorflow_repo.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:get/get.dart';

class ObjectDetectorController extends GetxController {
  final TensorflowServiceRepo tensorflowServiceRepo;

  var x = 0.0.obs;
  var y = 0.0.obs;
  var h = 0.0.obs;
  var w = 0.0.obs;
  var objectLabel = ''.obs;

  ObjectDetectorController({required this.tensorflowServiceRepo});

  void initiateTensorflowModel() async => tensorflowServiceRepo.loadingTensorflowModel();

  Future<List<dynamic>?> _onObjectDetectionResult({
    required CameraImage cameraImage,
  }) async =>
      await Tflite.detectObjectOnFrame(
        bytesList: cameraImage.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        imageHeight: cameraImage.height,
        imageWidth: cameraImage.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        threshold: 0.1,
        asynch: true,
        model: "SSDMobileNet",
      );

  Future<void> objectDetector({
    required CameraImage cameraImage,
  }) async {
    try {
      var detectorResults = await _onObjectDetectionResult(
        cameraImage: cameraImage,
      );

      if (detectorResults == null || detectorResults.isEmpty) {
        log('No objects detected');
        return;
      }

      var detectorObject = detectorResults.first;
      _detectedObjectInfo(detectorObject: detectorObject);
    } catch (e) {
      FormatException('Error in object detection: $e');
      log('Error in object detection: $e');
    }
  }

  void _detectedObjectInfo({required dynamic detectorObject}) {
    if (detectorObject != null &&
        detectorObject['confidenceInClass'] != null &&
        detectorObject['confidenceInClass'] * 100 > 45) {
      if (detectorObject['rect'] != null) {
        x.value = detectorObject['rect']['x'];
        y.value = detectorObject['rect']['y'];
        h.value = detectorObject['rect']['h'];
        w.value = detectorObject['rect']['w'];
      }
      objectLabel.value = detectorObject['detectedClass'].toString();
    }
  }
}
