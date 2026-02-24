import 'package:flutter/material.dart';
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
    return BaseScreen(
      title: 'AI Fishing Insights',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildHotspotMapPlaceholder(context),
            const SizedBox(height: 20),
            _buildSpeciesIDCard(context),
            const SizedBox(height: 20),
            _buildSustainableTipsCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHotspotMapPlaceholder(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hotspot Prediction Map',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: primaryDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 250,
          decoration: BoxDecoration(
            color: secondaryLight.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: secondaryLight),
          ),
          alignment: Alignment.center,
          child: const Text(
            'Interactive Map Placeholder (Google Maps)',
            style: TextStyle(color: primaryDark),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Predicted Hotspot: 5km North-East (High Confidence)',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  Widget _buildSpeciesIDCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Species Identification',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: primaryDark),
            ),
            const Divider(),
            const Text(
              'Upload a photo of your catch to instantly identify the species and check local regulations.',
            ),
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
                  ? const Text('Identifying...')
                  : const Text('Upload Catch Photo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryDark,
                foregroundColor: textSecondary,
              ),
            ),
            if (_aiResult != null) ...[
              const SizedBox(height: 20),
              Text(
                'AI Result:',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              ListTile(
                title: Text(_aiResult!['species']),
                subtitle: Text('Local Name: ${_aiResult!['local_name']}'),
                trailing: Text(
                  'Confidence: ${(_aiResult!['confidence'] * 100).toStringAsFixed(0)}%',
                ),
              ),
              ListTile(
                title: const Text('Regulations'),
                subtitle: Text(_aiResult!['regulations']),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSustainableTipsCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sustainable Fishing Tips',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: primaryDark),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.eco, color: secondaryLight),
              title: Text('Check Minimum Size'),
              subtitle: Text(
                'Always verify the minimum legal size before keeping a fish.',
              ),
            ),
            const ListTile(
              leading: Icon(Icons.restore_from_trash, color: secondaryLight),
              title: Text('Catch and Release'),
              subtitle: Text(
                'Use proper techniques to ensure high survival rates for released fish.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
