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
import 'package:geolocator/geolocator.dart';
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
  final CopernicusService _copernicusService = CopernicusService();

  bool _isLoading = true;

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

      final weather = await _weatherApiService.fetchWeatherForCurrentLocation();
      final tides = await _weatherApiService.fetchTideData();

      final prediction = _mlService.predictWeatherChanges(
        weather.temperature,
        weather.humidity,
        weather.windSpeed,
        weather.pressure,
      );

      //final prediction = _mlService.predictWeatherChanges(24, 95, 35, 995);

      TidePoint? nextHighTide;
      final now = DateTime.now();
      for (var tide in tides) {
        if (tide.time.isAfter(now)) {
          nextHighTide = tide;
          break;
        }
      }

      Position position = await Geolocator.getCurrentPosition();
      MarineData? realData = await _copernicusService.fetchMarineData(
        position.latitude,
        position.longitude,
      );

      double? pfzProb;
      if (realData != null) {
        pfzProb = await _pfzMlService.predictPfz(realData);
      } else {
        pfzProb = await _pfzMlService.predictPfz(
          MarineData(sst: 28.5, chlorophyll: 1.2, ssh: 0.1),
        );
      }

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
      debugPrint('HomeScreen Data Fetch Error: $e');
      if (mounted) {
        setState(() {
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
                  _buildWeatherSummaryCard(context, l10n),
                  const SizedBox(height: 20),

                  _buildAIFishingInsightCard(context, l10n),
                  const SizedBox(height: 20),

                  _buildCommunitySnippetCard(context, l10n),
                  const SizedBox(height: 20),

                  _buildNotificationsCard(context, l10n),
                ],
              ),
            ),
    );
  }

  Widget _buildWeatherSummaryCard(BuildContext context, AppLocalizations l10n) {
    String tempStr = _currentWeather != null
        ? "${_currentWeather!.temperature}°C"
        : "--";
    String descStr = _currentWeather != null
        ? _currentWeather!.description.toUpperCase()
        : "--";
    String tideStr = _nextHighTide != null
        ? DateFormat('hh:mm a').format(_nextHighTide!.time)
        : "--";
    String windStr = _currentWeather != null
        ? "${_currentWeather!.windSpeed} km/h"
        : "--";
    String humStr = _currentWeather != null
        ? "${_currentWeather!.humidity}%"
        : "--";
    String pressStr = _currentWeather != null
        ? "${_currentWeather!.pressure} hPa"
        : "--";

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade800, Colors.blue.shade500],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.weatherSummary,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(
                    Icons.cloud_outlined,
                    color: Colors.white70,
                    size: 28,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tempStr,
                        style: Theme.of(context).textTheme.displayLarge
                            ?.copyWith(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        descStr,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const Icon(Icons.wb_sunny, color: Colors.amber, size: 64),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildWeatherDetailItem(
                      Icons.air,
                      windStr,
                      l10n.windLabel,
                    ),
                  ),
                  Expanded(
                    child: _buildWeatherDetailItem(
                      Icons.water_drop_outlined,
                      humStr,
                      l10n.humidityLabel,
                    ),
                  ),
                  Expanded(
                    child: _buildWeatherDetailItem(
                      Icons.speed,
                      pressStr,
                      l10n.pressureLabel,
                    ),
                  ),
                ],
              ),
              if (_nextHighTide != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.waves, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        "${l10n.nextHighTideShort} $tideStr",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherDetailItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildAIFishingInsightCard(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    String probStr = "Analyzing...";
    String statusStr = "Unknown";
    Color statusColor = Theme.of(context).colorScheme.primary;
    IconData statusIcon = Icons.radar;

    if (_pfzProbability != null) {
      probStr = "${(_pfzProbability! * 100).toStringAsFixed(1)}%";
      if (_pfzProbability! > 0.70) {
        statusStr = l10n.excellent;
        statusColor = Colors.green.shade600;
        statusIcon = Icons.check_circle;
      } else if (_pfzProbability! > 0.50) {
        statusStr = l10n.good;
        statusColor = Colors.orange.shade600;
        statusIcon = Icons.info_outline;
      } else {
        statusStr = l10n.moderate;
        statusColor = Colors.red.shade600;
        statusIcon = Icons.warning_amber_rounded;
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: statusColor.withOpacity(0.3), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.insights, color: statusColor, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.aiFishingInsights,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      statusStr,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: statusColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Prob: $probStr",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Icon(statusIcon, color: statusColor, size: 48),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AIFishingScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.map, color: Colors.white),
                label: Text(
                  l10n.viewHotspotMap.replaceAll(' ->', ''),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: statusColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
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

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.forum,
                        color: Colors.purple,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      l10n.latestCommunityPost,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 16),
                  onPressed: () {
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
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    backgroundImage:
                        profilePicUrl != null && profilePicUrl.isNotEmpty
                        ? NetworkImage(profilePicUrl)
                        : null,
                    child: profilePicUrl == null || profilePicUrl.isEmpty
                        ? Icon(
                            Icons.person,
                            color: Theme.of(context).colorScheme.onSecondary,
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          snippet,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
    IconData icon = Icons.shield_outlined;
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

    return Container(
      decoration: BoxDecoration(
        color: isCritical ? color.withOpacity(0.1) : color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationScreen(),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        desc,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: color.withOpacity(0.5),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
