import 'dart:convert';
import 'dart:async';
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
  static const String _baseUrl = 'http://192.168.8.127:8000';

  Future<MarineData> fetchMarineData(double lat, double lng) async {
    const maxAttempts = 2;
    const timeoutPerAttempt = Duration(seconds: 15);

    final uri = Uri.parse('$_baseUrl/api/marine_data?lat=$lat&lng=$lng');
    print('[Marine API] Request URL: $uri');

    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        print('[Marine API] Attempt $attempt / $maxAttempts ...');
        final response = await http.get(uri).timeout(timeoutPerAttempt);

        if (response.statusCode == 200) {
          final json = jsonDecode(response.body) as Map<String, dynamic>;

          final apiStatus = json['status'] as String? ?? 'unknown';
          final sst = (json['sst'] as num).toDouble().clamp(20.0, 35.0);
          final chl = (json['chlorophyll'] as num).toDouble().clamp(0.0, 10.0);
          final ssh = (json['ssh'] as num).toDouble().clamp(-1.0, 1.0);

          print(
            '[Marine API] Data received — SST: $sst, CHL: $chl, SSH: $ssh '
            '(status: $apiStatus)',
          );

          return MarineData(
            sst: sst,
            chlorophyll: chl,
            ssh: ssh,
            status: apiStatus,
          );
        } else {
          print(
            '[Marine API] HTTP ${response.statusCode} on attempt $attempt'
            '${attempt < maxAttempts ? " — retrying..." : " — using fallback."}',
          );
        }
      } on TimeoutException {
        print(
          '[Marine API] Timeout on attempt $attempt'
          '${attempt < maxAttempts ? " — retrying..." : " — using fallback."}',
        );
      } catch (e) {
        print(
          '[Marine API] Error on attempt $attempt: $e'
          '${attempt < maxAttempts ? " — retrying..." : " — using fallback."}',
        );
      }

      if (attempt < maxAttempts) {
        await Future.delayed(Duration(seconds: attempt * 2));
      }
    }

    print('[Marine API] All attempts exhausted — using fallback values.');
    return MarineData.fallback();
  }
}
