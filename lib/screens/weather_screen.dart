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
            "🌬️ Wind: ${prediction['wind']!.toStringAsFixed(1)} m/s\n"
            "🌊 Waves: ${prediction['wave']!.toStringAsFixed(1)} m\n"
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
    String predictionText =
        "Next Hour -> Wind: ${prediction['wind']!.toStringAsFixed(1)} m/s, Waves: ${prediction['wave']!.toStringAsFixed(1)}m, Rain Risk: ${prediction['rain']!.toStringAsFixed(0)}%.";

    return Card(
      color: Theme.of(context).colorScheme.error.withValues(alpha: 0.2),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Theme.of(context).colorScheme.error,
              size: 30,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Critical ML Alert",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(predictionText),
                ],
              ),
            ),
          ],
        ),
      ),
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
