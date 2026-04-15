import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workmanager/workmanager.dart';
import 'package:intl/intl.dart';
import 'l10n/app_localizations.dart';
import 'providers/locale_provider.dart';
import 'providers/theme_provider.dart';
import 'theme.dart';
import 'screens/home_screen.dart';
import 'screens/weather_screen.dart';
import 'screens/ai_fishing_screen.dart';
import 'screens/community_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/login_screen.dart';
import 'services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/weather_api_service.dart';
import 'services/ml_service.dart';
import 'services/notification_service.dart';

const String weatherUpdateTask = "weatherUpdateTask";

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case weatherUpdateTask:
        try {
          await Firebase.initializeApp();
          await notificationService.initialize();

          final mlService = MLService();
          await mlService.initialize();

          final weatherApi = WeatherApiService();
          final forecasts = await weatherApi.fetchUpcoming10HourForecasts(
            limit: 8, //8
          );

          DateTime? warningStart;
          DateTime? warningEnd;
          double maxWind = 0;

          for (var forecast in forecasts) {
            final prediction = mlService.predictWeatherChanges(
              forecast.temperature,
              forecast.humidity,
              forecast.windSpeed,
              forecast.pressure,
            );

            if (prediction != null) {
              final wind = prediction['wind'] ?? 0.0;
              if (wind >= 10.0) {
                //10.0
                if (warningStart == null) {
                  warningStart = forecast.time;
                  warningEnd = forecast.time.add(const Duration(hours: 3));
                } else {
                  warningEnd = forecast.time.add(const Duration(hours: 3));
                }
                if (wind > maxWind) maxWind = wind;
              } else if (warningStart != null) {
                break;
              }
            }
          }

          if (warningStart != null && warningEnd != null) {
            final format = DateFormat('HH:mm');
            final timeRange =
                "${format.format(warningStart)} - ${format.format(warningEnd)}";

            await notificationService.showPredictionNotification(
              "⚠️ High Wind Warning",
              "Expected winds up to ${maxWind.toStringAsFixed(1)} km/h between $timeRange.",
            );
          } else {
            await notificationService.showPredictionNotification(
              "✅ Weather Check Complete",
              "No high winds expected in the next 24 hours.",
            );
          }
        } catch (e) {
          print('Background task error: $e');
        }
        break;
    }
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  Workmanager().registerPeriodicTask(
    "weather_task_1",
    weatherUpdateTask,
    frequency: const Duration(minutes: 15), //15
    constraints: Constraints(networkType: NetworkType.connected),
  );

  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;
  final languageCode = prefs.getString('languageCode') ?? 'en';

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LocaleProvider(initialLocale: languageCode),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(initialDarkMode: isDarkMode),
        ),
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
      home: const AuthWrapper(),
      debugShowCheckedModeBanner: false,
      locale: localeProvider.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  late final Stream<User?> _authStream;

  @override
  void initState() {
    super.initState();
    _authStream = AuthService().authStateChanges;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return const MainScreen();
        }
        return const LoginScreen();
      },
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
