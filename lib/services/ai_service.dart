import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'weather_api_service.dart';

class AIService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  // Placeholder for AI Species Identification
  Future<Map<String, dynamic>> identifySpecies(File imageFile) async {
    // In a real application, this would send the image to a backend API
    // (as outlined in the design document) for processing by an ML model.
    
    // Simulating a network delay and a result
    await Future.delayed(const Duration(seconds: 2));

    // Mock AI response
    return {
      'species': 'King Mackerel (Scomberomorus cavalla)',
      'confidence': 0.95,
      'local_name': 'Thora',
      'regulations': 'Minimum size: 75cm. Season: Open year-round.',
    };
  }

  // Mock AI Accuracy Verification
  Future<Map<String, dynamic>> verifyPostAccuracy({
    required String place,
    required DateTime date,
    required TimeOfDay time,
    required String weatherType,
    required String caption,
  }) async {
    // Mock AI verification delay
    await Future.delayed(const Duration(seconds: 2));

    try {
      final weatherService = WeatherApiService();
      final actualWeather = await weatherService.fetchWeatherForCity(place);

      final apiCondition = actualWeather.description.toLowerCase();
      final userCondition = weatherType.toLowerCase();
      final windSpeed = actualWeather.windSpeed;

      bool isMatch = false;

      if (userCondition.contains('rain')) {
        if (apiCondition.contains('rain') || apiCondition.contains('drizzle') || apiCondition.contains('shower')) {
          isMatch = true;
        }
      } else if (userCondition.contains('storm') || userCondition.contains('thunder')) {
        if (apiCondition.contains('storm') || apiCondition.contains('thunder') || apiCondition.contains('extreme')) {
          isMatch = true;
        }
      } else if (userCondition.contains('high wind')) {
        if (windSpeed > 10.0) { // 10 m/s is ~36 km/h, considered high wind
          isMatch = true;
        }
      } else if (userCondition.contains('tsunami')) {
        // Tsunami cannot be verified by standard weather API; blocked to prevent fake news.
        isMatch = false;
      } else {
        // For any other weather type that isn't handled or doesn't match API
        isMatch = false;
      }

      if (!isMatch) {
         return {
          'isAccurate': false,
          'reason': 'AI Verification Failed: You reported "$weatherType", but real-time data for $place indicates "$apiCondition" (Wind: ${windSpeed}m/s). This post has been blocked to prevent false information.'
        };
      }

      return {
        'isAccurate': true,
        'reason': 'Information appears accurate.'
      };

    } catch (e) {
      // If the city could not be found or API error happens, enforce strict blocking.
      return {
        'isAccurate': false,
        'reason': 'Verification failed: Could not retrieve real-time data for "$place". Please verify the place name is completely accurate.'
      };
    }
  }
}
