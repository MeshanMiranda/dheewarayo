import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dheewarayo/screens/community_screen.dart';
import 'package:dheewarayo/screens/notification_screen.dart';
import 'package:dheewarayo/screens/ai_fishing_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../services/weather_api_service.dart';
import '../services/ml_service.dart';
import '../services/pfz_ml_service.dart';
import '../services/copernicus_service.dart';
import 'base_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherApiService _weatherApiService = WeatherApiService();
  final MLService _mlService = MLService();
  final PfzMlService _pfzMlService = PfzMlService();

  bool _isLoading = true;
  String _errorMessage = '';

  WeatherData? _currentWeather;
  TidePoint? _nextHighTide;
  Map<String, double>? _weatherPredictions;

  double? _pfzProbability;

  Map<String, dynamic>? _latestPost;

  @override
  void initState() {
    super.initState();
    _initServicesAndData();
  }

  Future<void> _initServicesAndData() async {
    try {
      await _mlService.initialize();
      await _pfzMlService.init();

      // 1. Weather & Tides
      final weather = await _weatherApiService.fetchWeatherForCurrentLocation();
      final tides = await _weatherApiService.fetchTideData();

      final prediction = _mlService.predictWeatherChanges(
        weather.temperature,
        weather.humidity,
        weather.windSpeed,
        weather.pressure,
      );

      TidePoint? nextHighTide;
      final now = DateTime.now();
      for (var tide in tides) {
        if (tide.time.isAfter(now)) {
          nextHighTide = tide;
          break;
        }
      }

      // 2. AI Fishing Insight (Mock realistic ocean data based on location)
      final math.Random random = math.Random();
      MarineData mockData = MarineData(
        sst: 26.0 + random.nextDouble() * 3.5,
        chlorophyll: 0.1 + random.nextDouble() * 4.0,
        ssh: -0.1 + random.nextDouble() * 0.3,
      );
      final pfzProb = await _pfzMlService.predictPfz(mockData);

      // 3. Community Post
      final postsSnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      Map<String, dynamic>? latestPost;
      if (postsSnapshot.docs.isNotEmpty) {
        latestPost = postsSnapshot.docs.first.data();
      }

      if (mounted) {
        setState(() {
          _currentWeather = weather;
          _weatherPredictions = prediction;
          _nextHighTide = nextHighTide;
          _pfzProbability = pfzProb;
          _latestPost = latestPost;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BaseScreen(
      titleWidget: Image.asset('assets/img/dheewarayoLogo.png', height: 65),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (_errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        'Error: $_errorMessage',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),

                  // 1. Weather Summary Card
                  _buildWeatherSummaryCard(context, l10n),
                  const SizedBox(height: 20),

                  // 2. AI Fishing Insight Card
                  _buildAIFishingInsightCard(context, l10n),
                  const SizedBox(height: 20),

                  // 3. Latest Community Post Snippet
                  _buildCommunitySnippetCard(context, l10n),
                  const SizedBox(height: 20),

                  // 4. Notifications Card
                  _buildNotificationsCard(context, l10n),
                ],
              ),
            ),
    );
  }

  Widget _buildWeatherSummaryCard(BuildContext context, AppLocalizations l10n) {
    String tempStr = _currentWeather != null ? "${_currentWeather!.temperature}°C" : "--";
    String descStr = _currentWeather != null ? _currentWeather!.description.toUpperCase() : "--";
    String tideStr = _nextHighTide != null
        ? DateFormat('hh:mm a').format(_nextHighTide!.time)
        : "--";

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.weatherSummary,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.wb_sunny,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 40,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      tempStr,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(descStr),
                    if (_nextHighTide != null) ...[
                      const SizedBox(height: 4),
                      Text(l10n.nextHighTideShort),
                      Text(
                        tideStr,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIFishingInsightCard(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    String probStr = "Analyzing...";
    String statusStr = "Unknown";
    Color statusColor = Theme.of(context).colorScheme.primary;

    if (_pfzProbability != null) {
      probStr = "${(_pfzProbability! * 100).toStringAsFixed(1)}%";
      if (_pfzProbability! > 0.70) {
        statusStr = l10n.excellent;
        statusColor = Colors.red;
      } else if (_pfzProbability! > 0.50) {
        statusStr = l10n.good;
        statusColor = Colors.orange;
      } else {
        statusStr = l10n.moderate;
        statusColor = Colors.yellow.shade800;
      }
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.aiFishingInsights,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.radar,
                  color: statusColor,
                  size: 40,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      statusStr,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text("Prob: $probStr"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AIFishingScreen(),
                          ),
                        );
                      },
                      child: Text(
                        l10n.viewHotspotMap,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommunitySnippetCard(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    String username = l10n.unknownUser;
    String snippet = "";
    String? profilePicUrl;

    if (_latestPost != null) {
      username = _latestPost!['username'] as String? ?? username;
      snippet = _latestPost!['caption'] as String? ?? '';
      profilePicUrl = _latestPost!['userProfilePic'] as String?;
    } else {
      snippet = l10n.noPostsYet;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.latestCommunityPost,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const Divider(),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                backgroundImage: profilePicUrl != null && profilePicUrl.isNotEmpty
                    ? NetworkImage(profilePicUrl)
                    : null,
                child: profilePicUrl == null || profilePicUrl.isEmpty
                    ? Icon(
                        Icons.person,
                        color: Theme.of(context).colorScheme.onSecondary,
                      )
                    : null,
              ),
              title: Text(username),
              subtitle: Text(
                snippet,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CommunityScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsCard(BuildContext context, AppLocalizations l10n) {
    bool isCritical = false;
    String title = l10n.conditionsGoodTitle;
    String desc = l10n.conditionsGoodDesc;
    IconData icon = Icons.check_circle_outline;
    Color color = Colors.green;

    if (_weatherPredictions != null) {
      final wind = _weatherPredictions!['wind'] ?? 0.0;
      final wave = _weatherPredictions!['wave'] ?? 0.0;
      final rain = _weatherPredictions!['rain'] ?? 0.0;

      final bool highWind = wind >= 10.0;
      final bool highWaves = wave >= 2.0;
      final bool highRain = rain >= 70.0;
      isCritical = highWind || highWaves || highRain;

      if (isCritical) {
        title = l10n.headsUpRoughWeather; 
        desc = l10n.roughWeatherDesc;
        icon = Icons.warning_amber_rounded;
        color = Theme.of(context).colorScheme.error;
      }
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.notifications,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const Divider(),
            ListTile(
              leading: Icon(
                icon,
                color: color,
                size: 30,
              ),
              title: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(desc),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
