import 'package:flutter/foundation.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'copernicus_service.dart';

class PfzMlService {
  static final PfzMlService _instance = PfzMlService._internal();

  factory PfzMlService() {
    return _instance;
  }

  PfzMlService._internal();

  Interpreter? _interpreter;
  bool _isModelLoaded = false;

  Future<void> init() async {
    if (_isModelLoaded && _interpreter != null) return;

    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/models/pfz_model.tflite',
      );
      _isModelLoaded = true;
      debugPrint('PFZ TFLite model loaded successfully.');
    } catch (e) {
      debugPrint('Failed to load PFZ model: $e');
      _isModelLoaded = false;
    }
  }

  Future<double> predictPfz(MarineData data) async {
    if (!_isModelLoaded || _interpreter == null) {
      debugPrint('Model not loaded, cannot predict.');
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
      debugPrint('Error during PFZ prediction: $e');
      return 0.0;
    }
  }

  void dispose() {
    _interpreter?.close();
  }
}
