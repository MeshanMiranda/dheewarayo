import 'package:tflite_flutter/tflite_flutter.dart';
import 'copernicus_service.dart';

// PfzMlService runs an AI model to detect Potential Fishing Zones (PFZ)
class PfzMlService {
  // The interpreter that runs the TensorFlow Lite model
  Interpreter? _interpreter;
  // A flag indicating whether the model is ready to use
  bool _isModelLoaded = false;

  // Loads the AI model from the app's assets folder
  Future<void> init() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/models/pfz_model.tflite');
      _isModelLoaded = true;
      print('PFZ TFLite model loaded successfully.');
    } catch (e) {
      print('Failed to load PFZ model: $e');
      _isModelLoaded = false;
    }
  }

  /// Predicts the probability of a location being a Potential Fishing Zone (PFZ)
  /// Returns a value between 0.0 and 1.0
  Future<double> predictPfz(MarineData data) async {
    if (!_isModelLoaded || _interpreter == null) {
      print('Model not loaded, cannot predict.');
      return 0.0;
    }

    // Input shape is [1, 3] for [SST, Chlorophyll-a, SSH]
    // The Python model expects float32
    var input = [
      [data.sst, data.chlorophyll, data.ssh]
    ];

    // Output shape is [1, 1] for PFZ probability
    var output = List<List<double>>.filled(1, List<double>.filled(1, 0.0));

    try {
      _interpreter!.run(input, output);
      // The model outputs a probability (0.0 to 1.0)
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
