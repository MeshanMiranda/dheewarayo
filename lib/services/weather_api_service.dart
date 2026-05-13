import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class DailyForecast {
  final String day;
  final String condition;
  final double maxTemp;
  final double minTemp;
  final double windSpeed;

  DailyForecast({
    required this.day,
    required this.condition,
    required this.maxTemp,
    required this.minTemp,
    required this.windSpeed,
  });
}

class TidePoint {
  final DateTime time;
  final double height;

  TidePoint({required this.time, required this.height});
}

class IntervalForecast {
  final DateTime time;
  final double temperature;
  final double humidity;
  final double windSpeed;
  final double pressure;

  IntervalForecast({
    required this.time,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
  });
}

class WeatherData {
  final double temperature;
  final double humidity;
  final double windSpeed;
  final double pressure;
  final String description;
  final String name;

  WeatherData({
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.description,
    required this.name,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      temperature: (json['main']['temp'] as num).toDouble(),
      humidity: (json['main']['humidity'] as num).toDouble(),
      pressure: (json['main']['pressure'] as num).toDouble(),
      windSpeed: (json['wind']['speed'] as num).toDouble() * 3.6,
      description: json['weather'] != null && json['weather'].isNotEmpty
          ? json['weather'][0]['description'] as String
          : 'Unknown',
      name: json['name'] ?? 'Unknown',
    );
  }
}

class WeatherApiService {
  static const String apiKey = '4e713c36a0aae2a622638c328d2c20d7';
  static const String baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';
  static const String forecastUrl =
      'https://api.openweathermap.org/data/2.5/forecast';
  static const String worldTidesApiKey =
      '3b930da6-b951-4a4d-920b-e4e547a85873'; //3b930da6-b951-4a4d-920b-e4e547a85873

  Future<WeatherData> fetchWeatherForCity(String city) async {
    final url = Uri.parse('$baseUrl?q=$city&appid=$apiKey&units=metric');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return WeatherData.fromJson(json.decode(response.body));
    } else {
      throw Exception(
        'Failed to load weather data for city. Status: ${response.statusCode}',
      );
    }
  }

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

  Future<List<DailyForecast>> fetch5DayForecast() async {
    Position position = await Geolocator.getCurrentPosition();

    final url = Uri.parse(
      '$forecastUrl?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey&units=metric',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> list = jsonResponse['list'];

      Map<String, List<dynamic>> dailyData = {};

      for (var item in list) {
        final DateTime date = DateTime.fromMillisecondsSinceEpoch(
          item['dt'] * 1000,
          isUtc: true,
        ).toLocal();
        final String dayKey = DateFormat('yyyy-MM-dd').format(date);

        if (!dailyData.containsKey(dayKey)) {
          dailyData[dayKey] = [];
        }
        dailyData[dayKey]!.add(item);
      }

      List<DailyForecast> forecasts = [];

      dailyData.forEach((dayKey, items) {
        double maxTemp = -100;
        double minTemp = 100;
        double maxWind = 0;
        Map<String, int> conditions = {};

        for (var item in items) {
          final double temp = (item['main']['temp'] as num).toDouble();
          final double wind = (item['wind']['speed'] as num).toDouble() * 3.6;
          final String condition = item['weather'][0]['description'] as String;

          if (temp > maxTemp) maxTemp = temp;
          if (temp < minTemp) minTemp = temp;
          if (wind > maxWind) maxWind = wind;

          conditions[condition] = (conditions[condition] ?? 0) + 1;
        }

        String mainCondition = conditions.entries
            .reduce((a, b) => a.value > b.value ? a : b)
            .key;

        DateTime date = DateTime.parse(dayKey);
        String dayName = DateFormat('EEEE').format(date);
        if (dayKey == DateFormat('yyyy-MM-dd').format(DateTime.now())) {
          dayName = 'Today';
        } else if (dayKey ==
            DateFormat(
              'yyyy-MM-dd',
            ).format(DateTime.now().add(const Duration(days: 1)))) {
          dayName = 'Tomorrow';
        }

        forecasts.add(
          DailyForecast(
            day: dayName,
            condition: mainCondition,
            maxTemp: maxTemp,
            minTemp: minTemp,
            windSpeed: maxWind,
          ),
        );
      });

      return forecasts.take(7).toList();
    } else {
      throw Exception(
        'Failed to load forecast data. Status: ${response.statusCode}',
      );
    }
  }

  Future<List<IntervalForecast>> fetchUpcoming3HourForecasts({
    int limit = 8,
  }) async {
    Position? position;
    try {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 10),
      );
    } catch (e) {
      position = await Geolocator.getLastKnownPosition();
    }

    if (position == null) {
      throw Exception(
        'Could not determine location for background weather update.',
      );
    }

    final url = Uri.parse(
      '$forecastUrl?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey&units=metric',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> list = jsonResponse['list'];

      List<IntervalForecast> forecasts = [];

      for (var i = 0; i < list.length && i < limit; i++) {
        var item = list[i];
        forecasts.add(
          IntervalForecast(
            time: DateTime.fromMillisecondsSinceEpoch(
              item['dt'] * 1000,
              isUtc: true,
            ).toLocal(),
            temperature: (item['main']['temp'] as num).toDouble(),
            humidity: (item['main']['humidity'] as num).toDouble(),
            pressure: (item['main']['pressure'] as num).toDouble(),
            windSpeed: (item['wind']['speed'] as num).toDouble() * 3.6,
          ),
        );
      }
      return forecasts;
    } else {
      throw Exception(
        'Failed to load upcoming forecast data. Status: ${response.statusCode}',
      );
    }
  }

  Future<List<TidePoint>> fetchTideData() async {
    Position position = await Geolocator.getCurrentPosition();

    final url = Uri.parse(
      'https://www.worldtides.info/api/v3?heights&lat=${position.latitude}&lon=${position.longitude}&key=$worldTidesApiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> heights = jsonResponse['heights'] ?? [];

      List<TidePoint> tidePoints = heights.map((item) {
        return TidePoint(
          time: DateTime.fromMillisecondsSinceEpoch(
            item['dt'] * 1000,
            isUtc: true,
          ).toLocal(),
          height: (item['height'] as num).toDouble(),
        );
      }).toList();

      return tidePoints;
    } else {
      return _generateDummyTideData();
    }
  }

  List<TidePoint> _generateDummyTideData() {
    List<TidePoint> dummyData = [];
    DateTime now = DateTime.now();
    for (int i = 0; i < 24; i++) {
      dummyData.add(
        TidePoint(
          time: now.add(Duration(hours: i)),
          height: 1.5 + 1.0 * (i % 12 < 6 ? 1 : -1) * (i % 6) / 6,
        ),
      );
    }
    return dummyData;
  }
}
