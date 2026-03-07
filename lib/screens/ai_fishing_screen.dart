import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../l10n/app_localizations.dart';
import 'base_screen.dart';

class AIFishingScreen extends StatefulWidget {
  const AIFishingScreen({super.key});

  @override
  State<AIFishingScreen> createState() => _AIFishingScreenState();
}

class _AIFishingScreenState extends State<AIFishingScreen> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(7.8731, 80.7718);

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
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          l10n.predictedHotspot,
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
      ],
    );
  }
}
