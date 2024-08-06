
import 'package:flutter_tensorflow_ml_project/services/tensorflow_service/tensorflow_repo.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

class YoloV2TinyModelService implements TensorflowServiceRepo {
  static const String _tfliteFile = 'assets/yolov2_tiny.tflite';
  static const String _txtFile = 'assets/yolov2_tiny.txt';

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