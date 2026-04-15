import 'package:tflite_flutter/tflite_flutter.dart';

class MLService {
  Interpreter? _interpreter;

  Future<void> initialize() async {
    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/models/weather_model.tflite',
      );
      print('Weather model loaded successfully.');
    } catch (e) {
      print('Failed to load Weather model: $e');
    }
  }

  Map<String, double>? predictWeatherChanges(
    double tmp,
    double hum,
    double wind,
    double pres,
  ) {
    if (_interpreter == null) {
      print('Interpreter is not initialized.');
      return null;
    }

    try {
      var input = [
        [tmp, hum, wind, pres],
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
