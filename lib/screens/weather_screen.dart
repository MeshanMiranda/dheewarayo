import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'base_screen.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BaseScreen(
      title: l10n.weatherAndSafety,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildAlertsCard(context, l10n),
            const SizedBox(height: 20),
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

  Widget _buildAlertsCard(BuildContext context, AppLocalizations l10n) {
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
                    l10n.criticalAlertHighWind,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(l10n.highWindWarningDesc),
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
