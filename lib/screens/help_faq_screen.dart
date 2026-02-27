import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'base_screen.dart';

class HelpFaqScreen extends StatelessWidget {
  const HelpFaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final faqs = [
      {'q': l10n.faq1Question, 'a': l10n.faq1Answer},
      {'q': l10n.faq2Question, 'a': l10n.faq2Answer},
      {'q': l10n.faq3Question, 'a': l10n.faq3Answer},
      {'q': l10n.faq4Question, 'a': l10n.faq4Answer},
    ];

    return BaseScreen(
      title: l10n.helpFAQ,
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ExpansionTile(
              title: Text(
                faqs[index]['q']!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    faqs[index]['a']!,
                    style: const TextStyle(height: 1.4),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
