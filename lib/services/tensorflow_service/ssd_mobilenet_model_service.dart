
import 'package:flutter_tensorflow_ml_project/services/tensorflow_service/tensorflow_repo.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

class SSDMobilenetModelService implements TensorflowServiceRepo {
  static const String _tfliteFile = 'assets/ssd_mobilenet.tflite';
  static const String _txtFile = 'assets/ssd_mobilenet.txt';

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