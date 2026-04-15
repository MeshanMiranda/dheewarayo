import 'package:tflite_flutter/tflite_flutter.dart';
import 'copernicus_service.dart';

class PfzMlService {
  Interpreter? _interpreter;
  bool _isModelLoaded = false;

  Future<void> init() async {
    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/models/pfz_model.tflite',
      );
      _isModelLoaded = true;
      print('PFZ TFLite model loaded successfully.');
    } catch (e) {
      print('Failed to load PFZ model: $e');
      _isModelLoaded = false;
    }
  }

  Future<double> predictPfz(MarineData data) async {
    if (!_isModelLoaded || _interpreter == null) {
      print('Model not loaded, cannot predict.');
      return 0.0;
    }

    var input = [
      [data.sst, data.chlorophyll, data.ssh],
    ];

    var output = List<List<double>>.filled(1, List<double>.filled(1, 0.0));

    try {
      _interpreter!.run(input, output);
      double probability = output[0][0];
      return probability.clamp(0.0, 1.0);
    } catch (e) {
      print('Error during PFZ prediction: $e');
      return 0.0;
    }
  }

  void dispose() {
    _interpreter?.close();
  }
}
