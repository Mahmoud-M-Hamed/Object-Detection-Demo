
import 'package:flutter_tensorflow_ml_project/services/tensorflow_service/tensorflow_repo.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

class MobilenetModelService implements TensorflowServiceRepo {
  static const String _tfliteFile = 'assets/mobilenet_v1_1.0_224.tflite';
  static const String _txtFile = 'assets/mobilenet_v1_1.0_224.txt';

  @override
  Future<void> loadingTensorflowModel() async {
    await Tflite.loadModel(
      model: _tfliteFile,
      labels: _txtFile,
      isAsset: true,
      numThreads: 1,
      useGpuDelegate: false,
    );
  }

}