import 'package:flutter/foundation.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class MLService {
  static final MLService _instance = MLService._internal();

  factory MLService() {
    return _instance;
  }

  MLService._internal();

  Interpreter? _interpreter;

  Future<void> initialize() async {
    if (_interpreter != null) return;
    
    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/models/weather_model.tflite',
      );
      debugPrint('Weather model loaded successfully.');
    } catch (e) {
      debugPrint('Failed to load Weather model: $e');
    }
  }

  Map<String, double>? predictWeatherChanges(
    double tmp,
    double hum,
    double wind,
    double pres,
  ) {
    if (_interpreter == null) {
      debugPrint('Interpreter is not initialized.');
      return null;
    }

    try {
      var input = [
        [tmp, hum, pres, wind],
      ];

      var output = List<double>.filled(3, 0.0).reshape([1, 3]);

      _interpreter!.run(input, output);

      return {
        'wind': output[0][0] as double,
        'wave': output[0][1] as double,
        'rain': output[0][2] as double,
      };
    } catch (e) {
      debugPrint('Error running inference: $e');
      return null;
    }
  }
}
