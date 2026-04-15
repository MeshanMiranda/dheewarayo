import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
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
  WeatherData? _currentWeather;
  Map<String, double>? _weatherPredictions;
  List<DailyForecast>? _dailyForecasts;
  List<IntervalForecast>? _hourlyForecasts;
  List<TidePoint>? _tideData;

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
      final forecasts = await _weatherApiService.fetch5DayForecast();
      final intervalForecasts = await _weatherApiService
          .fetchUpcoming3HourForecasts(limit: 4);
      final tides = await _weatherApiService.fetchTideData();

      final prediction = _mlService.predictWeatherChanges(
        weather.temperature,
        weather.humidity,
        weather.windSpeed,
        weather.pressure,
      );

      //final prediction = _mlService.predictWeatherChanges(24, 95, 35, 995);

      if (mounted) {
        setState(() {
          _currentWeather = weather;
          _weatherPredictions = prediction;
          _dailyForecasts = forecasts;
          _hourlyForecasts = intervalForecasts;
          _tideData = tides;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('WeatherScreen Data Fetch Error: $e');
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
      title: l10n.weatherAndSafety,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (_currentWeather != null && _weatherPredictions != null)
                    _buildAlertsCard(context, l10n, _weatherPredictions!),
                  const SizedBox(height: 20),
                  if (_currentWeather != null)
                    _buildCurrentWeatherCard(context, _currentWeather!),
                  const SizedBox(height: 10),
                  if (_hourlyForecasts != null) ...[
                    _build10HourForecastHeader(context, l10n),
                    const SizedBox(height: 10),
                    _build10HourForecastList(context, _hourlyForecasts!),
                    const SizedBox(height: 20),
                  ],
                  _buildForecastHeader(context, l10n),
                  const SizedBox(height: 10),
                  if (_dailyForecasts != null)
                    ..._dailyForecasts!.map(
                      (forecast) => _buildDailyForecast(
                        context,
                        forecast.day,
                        forecast.condition.toUpperCase(),
                        '${forecast.minTemp.toStringAsFixed(1)}°C - ${forecast.maxTemp.toStringAsFixed(1)}°C',
                        forecast.windSpeed.toStringAsFixed(1),
                        l10n,
                      ),
                    ),
                  const SizedBox(height: 20),
                  _buildTideChart(context, l10n),
                ],
              ),
            ),
    );
  }

  Widget _buildCurrentWeatherCard(BuildContext context, WeatherData weather) {
    final l10n = AppLocalizations.of(context)!;
    String tempStr = "${weather.temperature}°C";
    String descStr = weather.description.toUpperCase();
    String windStr = "${weather.windSpeed} km/h";
    String humStr = "${weather.humidity}%";
    String pressStr = "${weather.pressure} hPa";

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
                    l10n.currentWeatherTitle,
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

  Widget _buildAlertsCard(
    BuildContext context,
    AppLocalizations l10n,
    Map<String, double> prediction,
  ) {
    final wind = prediction['wind'] ?? 0.0;
    final wave = prediction['wave'] ?? 0.0;
    final rain = prediction['rain'] ?? 0.0;

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
                      l10n.conditionsGoodTitle,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.green.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.conditionsGoodDesc,
                      style: const TextStyle(fontSize: 14),
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
                        l10n.headsUpRoughWeather,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.red.shade800,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.roughWeatherDesc,
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
                    label: l10n.windLabel,
                    value: "${wind.toStringAsFixed(1)} km/h",
                    icon: Icons.air,
                    isHigh: highWind,
                  ),
                  _buildConditionIndicator(
                    context,
                    label: l10n.wavesLabel,
                    value: "${wave.toStringAsFixed(1)} m",
                    icon: Icons.water,
                    isHigh: highWaves,
                  ),
                  _buildConditionIndicator(
                    context,
                    label: l10n.rainLabel,
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

  Widget _buildTideChart(BuildContext context, AppLocalizations l10n) {
    if (_tideData == null || _tideData!.isEmpty) {
      return Container(
        height: 150,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).colorScheme.primary),
        ),
        alignment: Alignment.center,
        child: Text(
          l10n.noTideData,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      );
    }

    List<FlSpot> spots = [];
    double minHeight = double.maxFinite;
    double maxHeight = -double.maxFinite;

    for (int i = 0; i < _tideData!.length; i++) {
      final height = _tideData![i].height;
      spots.add(FlSpot(i.toDouble(), height));
      if (height < minHeight) minHeight = height;
      if (height > maxHeight) maxHeight = height;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.seaTideChartTitle,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        AspectRatio(
          aspectRatio: 1.70,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.only(
              right: 24,
              left: 12,
              top: 24,
              bottom: 12,
            ),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.withValues(alpha: 0.2),
                    strokeWidth: 1,
                  ),
                  getDrawingVerticalLine: (value) => FlLine(
                    color: Colors.grey.withValues(alpha: 0.2),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: (_tideData!.length / 5).ceilToDouble(),
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 &&
                            value.toInt() < _tideData!.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              DateFormat(
                                'HH:mm',
                              ).format(_tideData![value.toInt()].time),
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toStringAsFixed(1)}m',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: spots.length.toDouble() - 1,
                minY: minHeight - 0.5,
                maxY: maxHeight + 0.5,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: Theme.of(context).colorScheme.primary,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _build10HourForecastHeader(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return Text(
      l10n.tenHourMarineForecast,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _build10HourForecastList(
    BuildContext context,
    List<IntervalForecast> forecasts,
  ) {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: forecasts.length,
        itemBuilder: (context, index) {
          final forecast = forecasts[index];
          final timeString = DateFormat('ha').format(forecast.time);
          return Card(
            margin: const EdgeInsets.only(right: 14),
            child: Container(
              width: 80,
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    timeString,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    _getWeatherIconForWind(forecast.windSpeed),
                    color: Theme.of(context).colorScheme.secondary,
                    size: 32,
                  ),
                  Text(
                    '${forecast.temperature.toStringAsFixed(1)}°C',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    '${forecast.windSpeed.toStringAsFixed(1)} km/h',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getWeatherIconForWind(double windSpeed) {
    if (windSpeed > 20) return Icons.air;
    if (windSpeed > 10) return Icons.water;
    return Icons.wb_sunny;
  }
}
