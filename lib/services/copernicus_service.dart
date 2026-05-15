import 'dart:convert';
import 'package:http/http.dart' as http;

class MarineData {
  final double sst;
  final double chlorophyll;
  final double ssh;
  final String status;

  MarineData({
    required this.sst,
    required this.chlorophyll,
    required this.ssh,
    this.status = 'success',
  });

  factory MarineData.fallback() =>
      MarineData(sst: 28.0, chlorophyll: 0.5, ssh: 0.0, status: 'fallback');
}

class CopernicusService {
  final String marineApiUrl =
      'https://dheewarayo-marine-api.onrender.com/api/marine_data';

  Future<MarineData> fetchMarineData(double lat, double lng) async {
    try {
      final uri = Uri.parse('$marineApiUrl?lat=$lat&lng=$lng');
      print('Request URL: $uri');

      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;

        final apiStatus = json['status'] as String? ?? 'unknown';
        final sst = (json['sst'] as num).toDouble().clamp(20.0, 35.0);
        final chl = (json['chlorophyll'] as num).toDouble().clamp(0.0, 10.0);
        final ssh = (json['ssh'] as num).toDouble().clamp(-1.0, 1.0);

        print(
          'Marine data received — SST: $sst, CHL: $chl, SSH: $ssh '
          '(status: $apiStatus)',
        );

        return MarineData(
          sst: sst,
          chlorophyll: chl,
          ssh: ssh,
          status: apiStatus,
        );
      } else {
        print('Marine API HTTP ${response.statusCode} — using fallback.');
        return MarineData.fallback();
      }
    } catch (e) {
      print('Marine API Error: $e — using fallback.');
      return MarineData.fallback();
    }
  }
}
