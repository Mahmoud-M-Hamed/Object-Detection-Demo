import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tensorflow_ml_project/controller/camera_controller/scan_controller.dart';
import 'package:flutter_tensorflow_ml_project/controller/object_detector_controller/object_detector.dart';
import 'package:flutter_tensorflow_ml_project/core/dependency_injection/injected_objects.dart';
import 'package:flutter_tensorflow_ml_project/services/tensorflow_service/ssd_mobilenet_model_service.dart';
import 'package:get/get.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScanController>(
      init: ScanController(
        objectDetectorController: ObjectDetectorController(
          tensorflowServiceRepo: SSDMobilenetModelService(),
        ),
      ),
      builder: (controller) {
        return controller.isCameraReady.value
            ? Stack(
                children: [
                  CameraPreview(controller.cameraController),
                  Obx(() {
                    return Positioned(
                      top: controller.objectDetectorController.y * 700,
                      right: controller.objectDetectorController.x * 500,
                      child: Container(
                        width: controller.objectDetectorController.w * 100 * context.width / 100,
                        height: controller.objectDetectorController.h * 100 * context.height / 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.green,
                            width: 4,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              color: Colors.white,
                              child: Text(
                                controller.objectDetectorController.objectLabel.toString(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}
