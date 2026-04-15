import 'package:flutter/material.dart';
import 'weather_api_service.dart';

class AIService {
  Future<Map<String, dynamic>> verifyPostAccuracy({
    required String place,
    required DateTime date,
    required TimeOfDay time,
    required String weatherType,
    required String caption,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    try {
      final weatherService = WeatherApiService();
      final actualWeather = await weatherService.fetchWeatherForCity(place);

      final apiCondition = actualWeather.description.toLowerCase();
      final userCondition = weatherType.toLowerCase();
      final windSpeed = actualWeather.windSpeed;

      bool isMatch = false;

      if (userCondition.contains('rain')) {
        if (apiCondition.contains('rain') ||
            apiCondition.contains('drizzle') ||
            apiCondition.contains('shower')) {
          isMatch = true;
        }
      } else if (userCondition.contains('storm') ||
          userCondition.contains('thunder')) {
        if (apiCondition.contains('storm') ||
            apiCondition.contains('thunder') ||
            apiCondition.contains('extreme')) {
          isMatch = true;
        }
      } else if (userCondition.contains('high wind')) {
        if (windSpeed > 10.0) {
          isMatch = true;
        }
      } else if (userCondition.contains('tsunami')) {
        isMatch = false;
      } else {
        isMatch = false;
      }

      if (!isMatch) {
        return {
          'isAccurate': false,
          'reason':
              'AI Verification Failed: You reported "$weatherType", but real-time data for $place indicates "$apiCondition" (Wind: ${windSpeed}m/s). This post has been blocked to prevent false information.',
        };
      }

      return {'isAccurate': true, 'reason': 'Information appears accurate.'};
    } catch (e) {
      return {
        'isAccurate': false,
        'reason':
            'Verification failed: Could not retrieve real-time data for "$place". Please verify the place name is completely accurate.',
      };
    }
  }
}
