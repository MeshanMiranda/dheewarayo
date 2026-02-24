import 'package:flutter/material.dart';
import '../theme.dart';
import 'base_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Dheewarayo | ධීවරයෝ',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 1. Weather Summary Card
            _buildWeatherSummaryCard(context),
            const SizedBox(height: 20),

            // 2. AI Fishing Insight Card
            _buildAIFishingInsightCard(context),
            const SizedBox(height: 20),

            // 3. Latest Community Post Snippet
            _buildCommunitySnippetCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherSummaryCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weather Summary',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: primaryDark),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.wb_sunny, color: secondaryLight, size: 40),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Safe to Sail',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: secondaryLight,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const Text('Current: 28°C, Wind: 10 kts NW'),
                    const Text('Next High Tide: 14:30'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIFishingInsightCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AI Fishing Insight',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: primaryDark),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.radar, color: primaryDark, size: 40),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Best Fishing Window',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: primaryDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text('06:00 - 09:00 (High Probability)'),
                    TextButton(
                      onPressed: () {
                        // TODO: Navigate to AI Fishing Screen
                      },
                      child: const Text(
                        'View Hotspot Map ->',
                        style: TextStyle(color: secondaryLight),
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

  Widget _buildCommunitySnippetCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Latest Community Post',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: primaryDark),
            ),
            const Divider(),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: secondaryLight,
                child: Icon(Icons.person, color: primaryDark),
              ),
              title: const Text('Meshan Miranda'),
              subtitle: const Text(
                'Negombo North Side Eke Sahenna Malu Ahuwenawa.',
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: Navigate to Community Screen
              },
            ),
          ],
        ),
      ),
    );
  }
}
