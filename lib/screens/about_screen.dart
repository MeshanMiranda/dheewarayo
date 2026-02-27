import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'base_screen.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BaseScreen(
      title: l10n.aboutDheewarayo,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/img/appIcon.png'),
              backgroundColor: Colors.transparent,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              l10n.dheewarayoTitle,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              l10n.appVersion,
              style: TextStyle(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _InfoSection(
            title: l10n.projectDetails,
            content: l10n.projectDetailsContent,
            icon: Icons.info_outline,
          ),
          const SizedBox(height: 16),
          _InfoSection(
            title: l10n.developerDetails,
            content: l10n.developerDetailsContent,
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 16),
          _InfoSection(
            title: l10n.universityDetails,
            content: l10n.universityDetailsContent,
            icon: Icons.school_outlined,
          ),
          const SizedBox(height: 16),
          _InfoSection(
            title: l10n.researchDetails,
            content: l10n.researchDetailsContent,
            icon: Icons.science_outlined,
          ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;

  const _InfoSection({
    required this.title,
    required this.content,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(content, style: const TextStyle(height: 1.4)),
          ],
        ),
      ),
    );
  }
}
