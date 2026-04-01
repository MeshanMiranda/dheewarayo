import 'package:tflite_flutter/tflite_flutter.dart';

// MLService handles running local machine learning models on the device
// This allows the app to make predictions without needing an internet connection
class MLService {
  // The TensorFlow Lite interpreter that will execute the mathematical model
  Interpreter? _interpreter;

  // Function to load the AI model from the app's assets folder into memory
  Future<void> initialize() async {
    try {
      // Load the pre-trained weather prediction model (.tflite file)
      _interpreter = await Interpreter.fromAsset('assets/models/weather_model.tflite');
      print('TFLite model loaded successfully.');
    } catch (e) {
      // Print an error if the model file is missing or corrupted
      print('Failed to load TFLite model: $e');
    }
  }

  /// Predicts weather changes based on inputs.
  /// Returns a map with keys: 'wind', 'wave', 'rain'
  Map<String, double>? predictWeatherChanges(double tmp, double hum, double wind, double pres) {
    // Check if the model failed to load during initialization
    if (_interpreter == null) {
      print('Interpreter is not initialized.');
      return null;
    }

    try {
      var input = [
        [tmp, hum, wind, pres]
      ];

      var output = List<double>.filled(3, 0.0).reshape([1, 3]);

      _interpreter!.run(input, output);

      return {
        'wind': output[0][0] as double,
        'wave': output[0][1] as double,
        'rain': output[0][2] as double,
      };
    } catch (e) {
      print('Error running inference: $e');
      return null;
    }
  }
}
