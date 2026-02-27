import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'providers/locale_provider.dart';
import 'providers/theme_provider.dart';
import 'theme.dart';
import 'screens/home_screen.dart';
import 'screens/weather_screen.dart';
import 'screens/ai_fishing_screen.dart';
import 'screens/community_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const DheewarayoApp(),
    ),
  );
}

class DheewarayoApp extends StatelessWidget {
  const DheewarayoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Dheewarayo',
      themeMode: themeProvider.themeMode,
      theme: dheewarayoTheme,
      darkTheme: dheewarayoDarkTheme,
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
      locale: localeProvider.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const WeatherScreen(),
    const AIFishingScreen(),
    const CommunityScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: l10n.navBarHome,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.cloud),
            label: l10n.navBarWeather,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.radar),
            label: l10n.navBarAiFishing,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.people),
            label: l10n.navBarCommunity,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: l10n.navBarSettings,
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
