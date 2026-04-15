import 'dart:convert';
import 'package:http/http.dart' as http;

class MarineData {
  final double sst;
  final double chlorophyll;
  final double ssh;

  MarineData({required this.sst, required this.chlorophyll, required this.ssh});
}

class CopernicusService {
  final String cmemsUsername = "prashansamm200327@gmail.com";
  final String cmemsPassword = "Copernicus@2003";
  final String chlDatasetUrl =
      'https://wmts.marine.copernicus.eu/teroWms/GLOBAL_ANALYSISFORECAST_BGC_001_028/cmems_mod_glo_bgc-pft_anfc_0.25deg_P1D-m_202311';
  final String phyDatasetUrl =
      'https://wmts.marine.copernicus.eu/teroWms/GLOBAL_ANALYSISFORECAST_PHY_001_024/cmems_mod_glo_phy_anfc_0.083deg_P1D-m_202406';

  Future<MarineData?> fetchMarineData(double lat, double lng) async {
    if (cmemsUsername.isEmpty || cmemsPassword.isEmpty) {
      print('Copernicus credentials missing. Cannot fetch real data.');
      return null;
    }

    try {
      double? chl = await _fetchWmsFeatureInfo(chlDatasetUrl, 'chl', lat, lng);
      double? sst = await _fetchWmsFeatureInfo(
        phyDatasetUrl,
        'thetao',
        lat,
        lng,
      );
      double? ssh = await _fetchWmsFeatureInfo(phyDatasetUrl, 'zos', lat, lng);

      if (chl == null || sst == null || ssh == null) {
        return null;
      }

      return MarineData(
        sst: sst.clamp(20.0, 35.0),
        chlorophyll: chl.clamp(0.0, 10.0),
        ssh: ssh.clamp(-1.0, 1.0),
      );
    } catch (e) {
      print('Copernicus API Error: $e');
      return null;
    }
  }

  Future<double?> _fetchWmsFeatureInfo(
    String baseUrl,
    String layer,
    double lat,
    double lng,
  ) async {
    double epsilon = 0.01;
    String bbox =
        '${lat - epsilon},${lng - epsilon},${lat + epsilon},${lng + epsilon}';

    final uri = Uri.parse(
      '$baseUrl?'
      'service=WMS&'
      'request=GetFeatureInfo&'
      'version=1.3.0&'
      'layers=$layer&'
      'query_layers=$layer&'
      'info_format=application/json&'
      'crs=EPSG:4326&'
      'width=2&height=2&'
      'i=1&j=1&'
      'bbox=$bbox',
    );

    final String basicAuth =
        'Basic ${base64Encode(utf8.encode("$cmemsUsername:$cmemsPassword"))}';

    final response = await http.get(uri, headers: {'Authorization': basicAuth});

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['features'] != null &&
          jsonResponse['features'].isNotEmpty) {
        var properties = jsonResponse['features'][0]['properties'];
        if (properties[layer] != null) {
          return (properties[layer] as num).toDouble();
        } else if (properties['value'] != null) {
          return (properties['value'] as num).toDouble();
        }
        for (var key in properties.keys) {
          if (properties[key] is num)
            return (properties[key] as num).toDouble();
        }
      }
    } else {
      print('WMS GetFeatureInfo failed for \$layer: \${response.statusCode}');
    }
    return null;
  }
}
