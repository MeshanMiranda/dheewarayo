import 'package:flutter/material.dart';
import 'base_screen.dart';
import '../theme.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Weather & Safety',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildAlertsCard(context),
            const SizedBox(height: 20),
            _buildForecastHeader(context),
            const SizedBox(height: 10),
            _buildDailyForecast(
              context,
              'Today',
              'Sunny, Low Swell',
              '28°C',
              'NW 10 kts',
            ),
            _buildDailyForecast(
              context,
              'Tomorrow',
              'Cloudy, High Wind',
              '26°C',
              'E 25 kts',
            ),
            _buildDailyForecast(
              context,
              'Day 3',
              'Rain, Moderate Swell',
              '25°C',
              'S 15 kts',
            ),
            const SizedBox(height: 20),
            _buildTideChartPlaceholder(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertsCard(BuildContext context) {
    return Card(
      color: Colors.red.shade100,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Colors.red,
              size: 30,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CRITICAL ALERT: High Wind Warning',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Winds up to 30 knots expected from 18:00 to 06:00. Exercise extreme caution.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForecastHeader(BuildContext context) {
    return Text(
      '7-Day Marine Forecast',
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        color: primaryDark,
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
  ) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.water, color: secondaryLight),
        title: Text(day, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$condition, $temp'),
        trailing: Text('Wind: $wind'),
      ),
    );
  }

  Widget _buildTideChartPlaceholder(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: primaryDark.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryDark),
      ),
      alignment: Alignment.center,
      child: const Text(
        'Tide Chart Placeholder (Interactive Map)',
        style: TextStyle(color: primaryDark),
      ),
    );
  }
}
