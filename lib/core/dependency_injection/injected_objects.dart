import 'package:flutter_tensorflow_ml_project/controller/object_detector_controller/object_detector.dart';
import 'package:flutter_tensorflow_ml_project/services/tensorflow_service/ssd_mobilenet_model_service.dart';
import 'package:get/get.dart';

class InjectedObjects {
  static ObjectDetectorController ssdMobilenetObjectDetectorControllerInjector = Get.put(
    ObjectDetectorController(
      tensorflowServiceRepo: SSDMobilenetModelService(),
    ),
  );
}
