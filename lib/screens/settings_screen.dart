import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';
import 'base_screen.dart';
import 'profile_screen.dart';
import '../theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = Provider.of<LocaleProvider>(context);
    final currentLocale = localeProvider.locale.languageCode;

    return BaseScreen(
      title: l10n.settings,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSettingsSection(
            context,
            title: l10n.account,
            children: [
              _buildSettingsTile(
                icon: Icons.person_outline,
                title: l10n.profile,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
              ),
              _buildSettingsTile(
                icon: Icons.security_outlined,
                title: l10n.securityPrivacy,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSettingsSection(
            context,
            title: l10n.appPreferences,
            children: [
              _buildSettingsTile(
                icon: Icons.notifications_none_outlined,
                title: l10n.notifications,
                onTap: () {},
              ),
              _buildSettingsTile(
                icon: Icons.language_outlined,
                title: l10n.language,
                trailing: DropdownButton<String>(
                  value: currentLocale,
                  underline: const SizedBox(),
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      localeProvider.setLocale(Locale(newValue));
                    }
                  },
                  items: const [
                    DropdownMenuItem(
                      value: 'en',
                      child: Text('English', style: TextStyle(fontSize: 14)),
                    ),
                    DropdownMenuItem(
                      value: 'si',
                      child: Text('සිංහල', style: TextStyle(fontSize: 14)),
                    ),
                  ],
                ),
                onTap: () {},
              ),
              _buildSettingsTile(
                icon: Icons.dark_mode_outlined,
                title: l10n.darkMode,
                trailing: Switch(
                  value: _isDarkMode,
                  onChanged: (bool value) {
                    setState(() {
                      _isDarkMode = value;
                    });
                  },
                ),
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSettingsSection(
            context,
            title: l10n.support,
            children: [
              _buildSettingsTile(
                icon: Icons.help_outline,
                title: l10n.helpFAQ,
                onTap: () {},
              ),
              _buildSettingsTile(
                icon: Icons.info_outline,
                title: l10n.aboutDheewarayo,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 30),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.logout),
              label: Text(l10n.logOut),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                foregroundColor: Colors.red,
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: primaryDark,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: primaryDark),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}
