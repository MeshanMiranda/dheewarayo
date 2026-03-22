import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class WeatherData {
  final double temperature;
  final double humidity;
  final double windSpeed;
  final double pressure;
  final String description;

  WeatherData({
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.description,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      temperature: (json['main']['temp'] as num).toDouble(),
      humidity: (json['main']['humidity'] as num).toDouble(),
      pressure: (json['main']['pressure'] as num).toDouble(),
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      description: json['weather'] != null && json['weather'].isNotEmpty
          ? json['weather'][0]['description'] as String
          : 'Unknown',
    );
  }
}

class WeatherApiService {
  // Replace with your actual OpenWeatherMap API key
  static const String apiKey = '4e713c36a0aae2a622638c328d2c20d7';
  static const String baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';

  Future<WeatherData> fetchWeatherForCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    Position position = await Geolocator.getCurrentPosition();

    final url = Uri.parse(
      '$baseUrl?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey&units=metric',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return WeatherData.fromJson(json.decode(response.body));
    } else {
      throw Exception(
        'Failed to load weather data. Status: ${response.statusCode}',
      );
    }
  }
}
