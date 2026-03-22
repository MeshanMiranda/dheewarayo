import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'base_screen.dart';
import '../services/weather_api_service.dart';
import '../services/ml_service.dart';
import '../services/notification_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherApiService _weatherApiService = WeatherApiService();
  final MLService _mlService = MLService();

  bool _isLoading = true;
  String _errorMessage = '';
  WeatherData? _currentWeather;
  Map<String, double>? _weatherPredictions;

  @override
  void initState() {
    super.initState();
    _initServicesAndData();
  }

  Future<void> _initServicesAndData() async {
    try {
      await notificationService.initialize();
      await notificationService.requestPermissions();
      await _mlService.initialize();

      final weather = await _weatherApiService.fetchWeatherForCurrentLocation();

      // predict
      final prediction = _mlService.predictWeatherChanges(
        weather.temperature,
        weather.humidity,
        weather.windSpeed,
        weather.pressure,
      );

      if (mounted) {
        setState(() {
          _currentWeather = weather;
          _weatherPredictions = prediction;
          _isLoading = false;
        });
      }

      // Send a friendly weather notification
      if (prediction != null) {
        String predictionText =
            "🌬️ Wind: ${prediction['wind']!.toStringAsFixed(1)} m/s | "
            "🌊 Waves: ${prediction['wave']!.toStringAsFixed(1)} m | "
            "🌧️ Chance of Rain: ${prediction['rain']!.toStringAsFixed(0)}%";

        await notificationService.showPredictionNotification(
          "⚡ Weather Alert: Upcoming Conditions",
          predictionText,
        );
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
      title: l10n.weatherAndSafety,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (_errorMessage.isNotEmpty)
                    Text(
                      'Error: $_errorMessage',
                      style: const TextStyle(color: Colors.red),
                    ),
                  if (_currentWeather != null && _weatherPredictions != null)
                    _buildAlertsCard(context, l10n, _weatherPredictions!),
                  const SizedBox(height: 20),
                  if (_currentWeather != null)
                    _buildCurrentWeatherCard(context, _currentWeather!),
                  const SizedBox(height: 10),
                  _buildForecastHeader(context, l10n),
                  const SizedBox(height: 10),
                  _buildDailyForecast(
                    context,
                    l10n.today,
                    l10n.sunnyLowSwell,
                    '28°C',
                    l10n.nw10kts,
                    l10n,
                  ),
                  _buildDailyForecast(
                    context,
                    l10n.tomorrow,
                    l10n.cloudyHighWind,
                    '26°C',
                    l10n.e25kts,
                    l10n,
                  ),
                  _buildDailyForecast(
                    context,
                    l10n.day3,
                    l10n.rainModerateSwell,
                    '25°C',
                    l10n.s15kts,
                    l10n,
                  ),
                  const SizedBox(height: 20),
                  _buildTideChartPlaceholder(context, l10n),
                ],
              ),
            ),
    );
  }

  Widget _buildCurrentWeatherCard(BuildContext context, WeatherData weather) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Current Weather',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Icon(Icons.thermostat),
                    Text('${weather.temperature}°C'),
                  ],
                ),
                Column(
                  children: [
                    const Icon(Icons.water_drop),
                    Text('${weather.humidity}%'),
                  ],
                ),
                Column(
                  children: [
                    const Icon(Icons.air),
                    Text('${weather.windSpeed} m/s'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              weather.description.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertsCard(
    BuildContext context,
    AppLocalizations l10n,
    Map<String, double> prediction,
  ) {
    final wind = prediction['wind'] ?? 0.0;
    final wave = prediction['wave'] ?? 0.0;
    final rain = prediction['rain'] ?? 0.0;

    // Define thresholds for rough marine weather
    final bool highWind = wind >= 10.0;
    final bool highWaves = wave >= 2.0;
    final bool highRain = rain >= 70.0;
    final bool isCritical = highWind || highWaves || highRain;

    if (!isCritical) {
      return Card(
        color: Colors.green.withValues(alpha: 0.1),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.green.shade300, width: 1.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                Icons.check_circle_outline,
                color: Colors.green.shade700,
                size: 36,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Conditions look good!",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.green.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "The weather is expected to remain safe for the next hour.",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      color: Colors.red.shade50,
      elevation: 4,
      shadowColor: Colors.red.withValues(alpha: 0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.red.shade400, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.warning_rounded,
                    color: Colors.red.shade800,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Heads Up! Rough Weather",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.red.shade800,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Please be careful. Here's what to expect in the next hour:",
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildConditionIndicator(
                    context,
                    label: "Wind",
                    value: "${wind.toStringAsFixed(1)} m/s",
                    icon: Icons.air,
                    isHigh: highWind,
                  ),
                  _buildConditionIndicator(
                    context,
                    label: "Waves",
                    value: "${wave.toStringAsFixed(1)} m",
                    icon: Icons.water,
                    isHigh: highWaves,
                  ),
                  _buildConditionIndicator(
                    context,
                    label: "Rain",
                    value: "${rain.toStringAsFixed(0)}%",
                    icon: Icons.umbrella,
                    isHigh: highRain,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConditionIndicator(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required bool isHigh,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: isHigh ? Colors.red.shade600 : Colors.blueGrey.shade400,
          size: 28,
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isHigh ? Colors.red.shade700 : Colors.black87,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildForecastHeader(BuildContext context, AppLocalizations l10n) {
    return Text(
      l10n.sevenDayMarineForecast,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDailyForecast(
    BuildContext context,
    String day,
    String condition,
    String temp,
    String wind,
    AppLocalizations l10n,
  ) {
    return Card(
      child: ListTile(
        leading: Icon(
          Icons.water,
          color: Theme.of(context).colorScheme.secondary,
        ),
        title: Text(day, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$condition, $temp'),
        trailing: Text(l10n.windPrefix(wind)),
      ),
    );
  }

  Widget _buildTideChartPlaceholder(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.primary),
      ),
      alignment: Alignment.center,
      child: Text(
        l10n.tideChartPlaceholder,
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}
