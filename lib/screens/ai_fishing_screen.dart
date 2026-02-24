import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'base_screen.dart';
import '../theme.dart';
import '../services/ai_service.dart';
import 'dart:io';

class AIFishingScreen extends StatefulWidget {
  const AIFishingScreen({super.key});

  @override
  State<AIFishingScreen> createState() => _AIFishingScreenState();
}

class _AIFishingScreenState extends State<AIFishingScreen> {
  final AIService _aiService = AIService();
  File? _imageFile;
  Map<String, dynamic>? _aiResult;
  bool _isLoading = false;

  Future<void> _pickAndIdentifyImage() async {
    setState(() {
      _isLoading = true;
      _aiResult = null;
    });

    final pickedFile = await _aiService.pickImage();
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });

      // Show a loading indicator while the mock AI service runs
      final result = await _aiService.identifySpecies(pickedFile);
      setState(() {
        _aiResult = result;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BaseScreen(
      title: l10n.aiFishingInsights,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildHotspotMapPlaceholder(context, l10n),
            const SizedBox(height: 20),
            _buildSpeciesIDCard(context, l10n),
            const SizedBox(height: 20),
            _buildSustainableTipsCard(context, l10n),
          ],
        ),
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
            color: primaryDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 250,
          decoration: BoxDecoration(
            color: secondaryLight.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: secondaryLight),
          ),
          alignment: Alignment.center,
          child: Text(
            l10n.interactiveMapPlaceholder,
            style: const TextStyle(color: primaryDark),
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

  Widget _buildSpeciesIDCard(BuildContext context, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.speciesIdentification,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: primaryDark),
            ),
            const Divider(),
            Text(l10n.uploadCatchPhotoText),
            const SizedBox(height: 10),
            if (_imageFile != null) ...[
              // Display the picked image
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.file(_imageFile!, height: 150, fit: BoxFit.cover),
              ),
              const SizedBox(height: 10),
            ],
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _pickAndIdentifyImage,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: textSecondary,
                      ),
                    )
                  : const Icon(Icons.camera_alt),
              label: _isLoading
                  ? Text(l10n.identifying)
                  : Text(l10n.uploadCatchPhoto),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryDark,
                foregroundColor: textSecondary,
              ),
            ),
            if (_aiResult != null) ...[
              const SizedBox(height: 20),
              Text(
                l10n.aiResult,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              ListTile(
                title: Text(_aiResult!['species']),
                subtitle: Text(l10n.localName(_aiResult!['local_name'])),
                trailing: Text(
                  l10n.confidence(
                    (_aiResult!['confidence'] * 100).toStringAsFixed(0),
                  ),
                ),
              ),
              ListTile(
                title: Text(l10n.regulations),
                subtitle: Text(_aiResult!['regulations']),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSustainableTipsCard(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.sustainableFishingTips,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: primaryDark),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.eco, color: secondaryLight),
              title: Text(l10n.checkMinimumSize),
              subtitle: Text(l10n.checkMinimumSizeDesc),
            ),
            ListTile(
              leading: const Icon(
                Icons.restore_from_trash,
                color: secondaryLight,
              ),
              title: Text(l10n.catchAndRelease),
              subtitle: Text(l10n.catchAndReleaseDesc),
            ),
          ],
        ),
      ),
    );
  }
}
