import 'package:flutter_tensorflow_ml_project/services/tensorflow_service/tensorflow_repo.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

class DeeplabV3ModelService implements TensorflowServiceRepo {
  static const String _tfliteFile = 'deeplabv3_257_mv_gpu.tflite';
  static const String _txtFile = 'deeplabv3_257_mv_gpu.txt';

  @override
  Future<void> loadingTensorflowModel() async {
    await Tflite.loadModel(
      model: _tfliteFile,
      labels: _txtFile,
      isAsset: true,
      numThreads: 1,
      useGpuDelegate: true,
    );
  }

}