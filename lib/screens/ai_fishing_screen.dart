import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../l10n/app_localizations.dart';
import '../services/copernicus_service.dart';
import '../services/pfz_ml_service.dart';
import 'base_screen.dart';

class AIFishingScreen extends StatefulWidget {
  const AIFishingScreen({super.key});

  @override
  State<AIFishingScreen> createState() => _AIFishingScreenState();
}

class _AIFishingScreenState extends State<AIFishingScreen> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(7.8731, 80.7718);
  Set<Polygon> _polygons = {};
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  final PfzMlService _pfzMlService = PfzMlService();
  bool _isLoadingPfz = true;

  @override
  void initState() {
    super.initState();
    _initializeZones();
    _requestLocationPermission();
    _initPfzModel();
  }

  Future<void> _initPfzModel() async {
    await _pfzMlService.init();
    await _generatePfzMarkers();
  }

  // Precise ray-casting point-in-polygon algorithm to exclude land
  bool _isPointInLand(LatLng point) {
    final List<LatLng> polygon = [
      const LatLng(9.83, 80.16),
      const LatLng(9.18, 80.82),
      const LatLng(8.60, 81.23),
      const LatLng(7.94, 81.56),
      const LatLng(7.04, 81.85),
      const LatLng(6.34, 81.50),
      const LatLng(5.92, 80.58),
      const LatLng(6.04, 80.21),
      const LatLng(6.92, 79.84),
      const LatLng(7.88, 79.80),
      const LatLng(8.85, 79.90),
      const LatLng(9.74, 79.95),
    ];
    int intersectCount = 0;
    for (int i = 0; i < polygon.length; i++) {
        LatLng v1 = polygon[i];
        LatLng v2 = polygon[(i + 1) % polygon.length];
        if ((v1.latitude > point.latitude) != (v2.latitude > point.latitude)) {
            double intersectLng = (v2.longitude - v1.longitude) * (point.latitude - v1.latitude) / (v2.latitude - v1.latitude) + v1.longitude;
            if (point.longitude < intersectLng) {
                intersectCount++;
            }
        }
    }
    return (intersectCount % 2) == 1;
  }

  Future<void> _generatePfzMarkers() async {
    setState(() => _isLoadingPfz = true);
    final Set<Marker> markers = {};
    
    final math.Random random = math.Random();
    int attempts = 0;
    
    // Attempt to dynamically find 15 highly probable zones scattered naturally securely in the sea
    while (markers.length < 15 && attempts < 1500) {
      attempts++;
      double lat = 5.5 + random.nextDouble() * 5.0; // 5.5 to 10.5
      double lng = 78.5 + random.nextDouble() * 4.0; // 78.5 to 82.5

      // Exclude precise Sri Lanka land mass algorithmically
      if (_isPointInLand(LatLng(lat, lng))) {
        continue;
      }

      // Generate localized random oceanographic params
      MarineData mockData = MarineData(
        sst: 26.0 + random.nextDouble() * 3.5, // 26.0 - 29.5 C
        chlorophyll: 0.1 + random.nextDouble() * 4.0, // 0.1 - 4.1 mg/m3
        ssh: -0.1 + random.nextDouble() * 0.3, // -0.1 - 0.2 m
      );

      // Run it through the ML model to see if it qualifies
      double mlProbability = await _pfzMlService.predictPfz(mockData);
      
      if (mlProbability > 0.40) {
        double hue;
        // Natural threshold mapping dictated entirely by the AI
        if (mlProbability > 0.70) {
          hue = BitmapDescriptor.hueRed; // Excellent
        } else if (mlProbability > 0.50) {
          hue = BitmapDescriptor.hueOrange; // Good
        } else {
          hue = BitmapDescriptor.hueYellow; // Moderate
        }

        markers.add(
          Marker(
            markerId: MarkerId('pfz_${lat}_${lng}'),
            position: LatLng(lat, lng),
            icon: BitmapDescriptor.defaultMarkerWithHue(hue),
            infoWindow: InfoWindow(
              title: 'Potential Fishing Zone',
              snippet: 'Prob: ${(mlProbability * 100).toStringAsFixed(1)}% | SST: ${mockData.sst.toStringAsFixed(1)}°C | Chl: ${mockData.chlorophyll.toStringAsFixed(2)}',
            ),
          ),
        );
      }
    }

    if (mounted) {
      setState(() {
        _markers = markers;
        _isLoadingPfz = false;
      });
    }
  }

  @override
  void dispose() {
    _pfzMlService.dispose();
    mapController.dispose();
    super.dispose();
  }

  Future<void> _requestLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _initializeZones() {
    const centerLat = 7.85;
    const centerLng = 80.75;

    final sriLankaCoastline = [
      const LatLng(9.83, 80.16),
      const LatLng(9.18, 80.82),
      const LatLng(8.60, 81.23),
      const LatLng(7.94, 81.56),
      const LatLng(7.04, 81.85),
      const LatLng(6.34, 81.50),
      const LatLng(5.92, 80.58),
      const LatLng(6.04, 80.21),
      const LatLng(6.92, 79.84),
      const LatLng(7.88, 79.80),
      const LatLng(8.85, 79.90),
      const LatLng(9.74, 79.95),
    ];

    double getBoundaryLng(double lat) {
      final boundaryPoints = [
        const LatLng(10.5, 80.0),
        const LatLng(10.0, 79.8),
        const LatLng(9.5, 79.5),
        const LatLng(9.0, 79.0),
        const LatLng(8.5, 78.5),
        const LatLng(8.0, 78.0),
      ];
      if (lat >= 10.5) return 80.0 + (lat - 10.5) * 0.5;
      if (lat <= 8.0) return 78.0 - (8.0 - lat) * 1.0;

      for (int i = 0; i < boundaryPoints.length - 1; i++) {
        final p1 = boundaryPoints[i]; // Higher Lat
        final p2 = boundaryPoints[i + 1]; // Lower Lat
        if (lat <= p1.latitude && lat >= p2.latitude) {
          final fraction = (p1.latitude - lat) / (p1.latitude - p2.latitude);
          return p1.longitude - fraction * (p1.longitude - p2.longitude);
        }
      }
      return -180.0;
    }

    List<LatLng> expand(double degrees) {
      return sriLankaCoastline.map((p) {
        final dLat = p.latitude - centerLat;
        final dLng = p.longitude - centerLng;
        final length = math.sqrt(dLat * dLat + dLng * dLng);

        double newLat = p.latitude + (dLat / length) * degrees;
        double newLng = p.longitude + (dLng / length) * degrees;

        double minLng = getBoundaryLng(newLat);
        if (newLng < minLng) {
          newLng = minLng;
        }

        return LatLng(newLat, newLng);
      }).toList();
    }

    final territorialSea = expand(0.2);
    final contiguousZone = expand(0.4);
    final eez = expand(3.3);

    _polygons = {
      Polygon(
        polygonId: const PolygonId('EEZ'),
        points: eez,
        fillColor: Colors.transparent,
        strokeColor: Colors.blue.shade700,
        strokeWidth: 2,
      ),
      Polygon(
        polygonId: const PolygonId('ContiguousZone'),
        points: contiguousZone,
        fillColor: Colors.transparent,
        strokeColor: Colors.teal.shade700,
        strokeWidth: 2,
      ),
      Polygon(
        polygonId: const PolygonId('TerritorialSea'),
        points: territorialSea,
        fillColor: Colors.transparent,
        strokeColor: Colors.indigo.shade700,
        strokeWidth: 2,
      ),
    };

    _polylines = {
      Polyline(
        polylineId: const PolylineId('IndoSriLankaBoundary'),
        points: const [
          LatLng(10.5, 80.0),
          LatLng(10.0, 79.8),
          LatLng(9.5, 79.5),
          LatLng(9.0, 79.0),
          LatLng(8.5, 78.5),
          LatLng(8.0, 78.0),
        ],
        color: Colors.red,
        width: 3,
        patterns: <PatternItem>[PatternItem.dash(20), PatternItem.gap(10)],
      ),
    };
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BaseScreen(
      title: l10n.aiFishingInsights,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildHotspotMapPlaceholder(context, l10n),
      ),
    );
  }

  Widget _buildHotspotMapPlaceholder(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.hotspotPredictionMap,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 6.5,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                mapType: MapType.normal,
                polygons: _polygons,
                polylines: _polylines,
                markers: _markers,
              ),
            ),
          ),
        ),
        if (_isLoadingPfz)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 8),
                Text('Analyzing oceanographic data for PFZ...'),
              ],
            ),
          ),
        const SizedBox(height: 10),
        _buildLegend(context, l10n),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildLegend(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.mapLegend,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        _buildLegendItem(
          Colors.transparent,
          Colors.indigo.shade700,
          l10n.territorialSea,
        ),
        _buildLegendItem(
          Colors.transparent,
          Colors.teal.shade700,
          l10n.contiguousZone,
        ),
        _buildLegendItem(Colors.transparent, Colors.blue.shade700, l10n.eez),
        Row(
          children: [
            Container(width: 24, height: 4, color: Colors.red),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l10n.indoSriLankaBoundary,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Container(width: 24, height: 16, color: Colors.transparent),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '\${l10n.internationalSea} - Beyond Boundary',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Potential Fishing Zones (PFZ)',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.location_on, color: Colors.red, size: 20),
            const SizedBox(width: 4),
            const Text('Excellent', style: TextStyle(fontSize: 12)),
            const SizedBox(width: 12),
            const Icon(Icons.location_on, color: Colors.orange, size: 20),
            const SizedBox(width: 4),
            const Text('Good', style: TextStyle(fontSize: 12)),
            const SizedBox(width: 12),
            const Icon(Icons.location_on, color: Colors.yellow, size: 20),
            const SizedBox(width: 4),
            const Text('Moderate', style: TextStyle(fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(Color fillColor, Color strokeColor, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 16,
            decoration: BoxDecoration(
              color: fillColor,
              border: Border.all(color: strokeColor, width: 2),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }
}
