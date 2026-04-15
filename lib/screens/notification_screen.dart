import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'base_screen.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final notifications = [
      {
        'title': l10n.notifHighWindTitle,
        'content': l10n.notifHighWindContent,
        'time': l10n.hoursAgo('2'),
        'icon': Icons.warning_amber_rounded,
        'color': Colors.red,
      },
      {
        'title': l10n.notifGoodFishingTitle,
        'content': l10n.notifGoodFishingContent,
        'time': l10n.hoursAgo('5'),
        'icon': Icons.phishing,
        'color': Colors.blue,
      },
      {
        'title': l10n.notifAppUpdateTitle,
        'content': l10n.notifAppUpdateContent,
        'time': l10n.daysAgo('1'),
        'icon': Icons.system_update,
        'color': Colors.green,
      },
    ];

    return BaseScreen(
      title: l10n.notifications,
      body: notifications.isEmpty
          ? Center(child: Text(l10n.noNotificationsMessage))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final note = notifications[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: (note['color'] as Color).withValues(
                        alpha: 0.2,
                      ),
                      child: Icon(
                        note['icon'] as IconData,
                        color: note['color'] as Color,
                      ),
                    ),
                    title: Text(
                      note['title'] as String,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(note['content'] as String),
                        const SizedBox(height: 4),
                        Text(
                          note['time'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
    );
  }
}
