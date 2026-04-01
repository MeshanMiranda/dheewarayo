import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'base_screen.dart';

// SecurityPrivacyScreen displays the app's policies regarding data protection, location, etc.
class SecurityPrivacyScreen extends StatelessWidget {
  const SecurityPrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BaseScreen(
      title: l10n.securityPrivacy,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _PolicySection(
            title: l10n.dataProtectionPolicy,
            content: l10n.dataProtectionPolicyContent,
          ),
          const SizedBox(height: 16),
          _PolicySection(
            title: l10n.locationServices,
            content: l10n.locationServicesContent,
          ),
          const SizedBox(height: 16),
          _PolicySection(
            title: l10n.accountSecurityPolicy,
            content: l10n.accountSecurityPolicyContent,
          ),
          const SizedBox(height: 16),
          _PolicySection(
            title: l10n.dataSharingPolicy,
            content: l10n.dataSharingPolicyContent,
          ),
        ],
      ),
    );
  }
}

class _PolicySection extends StatelessWidget {
  final String title;
  final String content;

  const _PolicySection({required this.title, required this.content});

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
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(content, style: TextStyle(height: 1.4)),
          ],
        ),
      ),
    );
  }
}
