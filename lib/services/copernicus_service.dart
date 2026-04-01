import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';

// A simple "data holder" class to neatly group marine data together
class MarineData {
  final double sst; // Sea Surface Temperature in Celsius
  final double chlorophyll; // Chlorophyll-a in mg/m^3
  final double ssh; // Sea Surface Height anomaly in meters

  // Constructor requires all three values to be provided when creating a MarineData object
  MarineData({required this.sst, required this.chlorophyll, required this.ssh});
}

// CopernicusService handles fetching real oceanographic data from the European Copernicus Marine Service
class CopernicusService {
  final Random _random = Random();

  // TODO: Enter your Copernicus Marine Service credentials here
  // These credentials are required to authenticate with the Copernicus API
  final String cmemsUsername = "prashansamm200327@gmail.com";
  final String cmemsPassword = "Copernicus@2003";

  /// WMS (Web Map Service) endpoints based on the dataset IDs provided
  /// These URLs point to the specific satellite datasets we want to read
  final String chlDatasetUrl =
      'https://wmts.marine.copernicus.eu/teroWms/GLOBAL_ANALYSISFORECAST_BGC_001_028/cmems_mod_glo_bgc-pft_anfc_0.25deg_P1D-m_202311';
  final String phyDatasetUrl =
      'https://wmts.marine.copernicus.eu/teroWms/GLOBAL_ANALYSISFORECAST_PHY_001_024/cmems_mod_glo_phy_anfc_0.083deg_P1D-m_202406';

  // Function to get the marine data for a specific location on the map
  Future<MarineData> fetchMarineData(double lat, double lng) async {
    // If no credentials are provided, tightly fallback to realistic mocked data
    // This prevents the app from crashing if the API keys are missing
    if (cmemsUsername.isEmpty || cmemsPassword.isEmpty) {
      return _getMockMarineData(lat, lng);
    }

    try {
      // Fetch actual Chlorophyll-a
      double chl =
          await _fetchWmsFeatureInfo(chlDatasetUrl, 'chl', lat, lng) ??
          _getMockMarineData(lat, lng).chlorophyll;

      // Fetch actual SST ('thetao') and SSH ('zos')
      double sst =
          await _fetchWmsFeatureInfo(phyDatasetUrl, 'thetao', lat, lng) ??
          _getMockMarineData(lat, lng).sst;
      double ssh =
          await _fetchWmsFeatureInfo(phyDatasetUrl, 'zos', lat, lng) ??
          _getMockMarineData(lat, lng).ssh;

      return MarineData(
        sst: sst.clamp(20.0, 35.0),
        chlorophyll: chl.clamp(0.0, 10.0),
        ssh: ssh.clamp(-1.0, 1.0),
      );
    } catch (e) {
      print('Copernicus API Error: \$e. Falling back to mock data.');
      return _getMockMarineData(lat, lng);
    }
  }

  Future<double?> _fetchWmsFeatureInfo(
    String baseUrl,
    String layer,
    double lat,
    double lng,
  ) async {
    // Small bounding box around our target point for WMS
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
      // WMS JSON usually returns an array of features
      if (jsonResponse['features'] != null &&
          jsonResponse['features'].isNotEmpty) {
        var properties = jsonResponse['features'][0]['properties'];
        // The key holding the value is sometimes named after the layer, e.g. properties['chl'] or properties['value']
        if (properties[layer] != null) {
          return (properties[layer] as num).toDouble();
        } else if (properties['value'] != null) {
          return (properties['value'] as num).toDouble();
        }
        // Custom logic to handle different OGC json structs if required:
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

  MarineData _getMockMarineData(double lat, double lng) {
    double baseSst = 28.0 - ((lat.abs() - 7.0) * 0.2);
    double baseChl = 0.5 + (_random.nextDouble() * 2.0);
    double baseSsh = 0.1;

    double sst = baseSst + (_random.nextDouble() * 4.0 - 2.0);
    double chlorophyll = baseChl + (_random.nextDouble() * 1.5 - 0.5);
    double ssh = baseSsh + (_random.nextDouble() * 0.4 - 0.2);

    return MarineData(
      sst: sst.clamp(20.0, 35.0),
      chlorophyll: chlorophyll.clamp(0.0, 10.0),
      ssh: ssh.clamp(-1.0, 1.0),
    );
  }
}
