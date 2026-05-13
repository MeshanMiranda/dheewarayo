import 'dart:convert';
import 'package:http/http.dart' as http;

class MarineData {
  final double sst;
  final double chlorophyll;
  final double ssh;

  MarineData({required this.sst, required this.chlorophyll, required this.ssh});
}

class CopernicusService {
  // 10.0.2.2 is used to access localhost from an Android Emulator
  // Change to 127.0.0.1 if testing on web or windows
  final String marineApiUrl = 'http://192.168.8.127:8000/api/marine_data';

  Future<MarineData?> fetchMarineData(double lat, double lng) async {
    try {
      final uri = Uri.parse('$marineApiUrl?lat=$lat&lng=$lng');
      print("Request URL: $uri");

      // Increased timeout because the Python API fetches data via XArray which can take time
      final response = await http.get(uri).timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        double sst = (jsonResponse['sst'] as num).toDouble();
        double chl = (jsonResponse['chlorophyll'] as num).toDouble();
        double ssh = (jsonResponse['ssh'] as num).toDouble();

        return MarineData(
          sst: sst.clamp(20.0, 35.0),
          chlorophyll: chl.clamp(0.0, 10.0),
          ssh: ssh.clamp(-1.0, 1.0),
        );
      } else {
        print('Marine API failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Marine API Error: $e');
      return null;
    }
  }
}
