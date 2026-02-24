import 'package:flutter/material.dart';
import 'base_screen.dart';
import '../theme.dart';

class LogbookScreen extends StatelessWidget {
  const LogbookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Catch Logbook',
      actions: [
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () {
            // TODO: Implement Add New Catch form
          },
        ),
      ],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Recent Catches',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: primaryDark,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  _buildCatchEntry(
                    context,
                    'King Mackerel',
                    '2026-01-19',
                    '15.5 kg',
                    'Negombo',
                  ),
                  _buildCatchEntry(
                    context,
                    'Snapper',
                    '2026-01-17',
                    '5.2 kg',
                    'Negombo North',
                  ),
                  _buildCatchEntry(
                    context,
                    'Tuna',
                    '2026-01-12',
                    '45.0 kg',
                    'Wennapuwa',
                  ),
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text('No more entries. Tap + to add a new catch.'),
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

  Widget _buildCatchEntry(
    BuildContext context,
    String species,
    String date,
    String weight,
    String location,
  ) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.anchor, color: secondaryLight),
        title: Text(
          species,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Date: $date | Weight: $weight'),
        trailing: Text(location),
        onTap: () {
          // TODO: Implement view catch details
        },
      ),
    );
  }
}
