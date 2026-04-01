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

// This identifier uniquely names the background task that checks for weather updates
const String weatherUpdateTask = "weatherUpdateTask";

// This tells Flutter that this function can be called from the background, even when the app is closed
@pragma('vm:entry-point')
void callbackDispatcher() {
  // Execute the background task
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case weatherUpdateTask:
        try {
          // Initialize Firebase so we can use its services in the background
          await Firebase.initializeApp();
          // Initialize notifications so we can send alerts to the user
          await notificationService.initialize();
          
          // Setup the machine learning service which predicts weather changes
          final mlService = MLService();
          await mlService.initialize();

          // Setup the weather API service to get upcoming 3-hour forecasts
          final weatherApi = WeatherApiService();
          final forecasts = await weatherApi.fetchUpcoming3HourForecasts(
            limit: 8, // Fetch data for the next 24 hours (8 periods of 3 hours)
          );

          DateTime? warningStart;
          DateTime? warningEnd;
          double maxWind = 0;

          // Check each forecasted period
          for (var forecast in forecasts) {
            // Ask ML service to predict weather changes based on current conditions
            final prediction = mlService.predictWeatherChanges(
              forecast.temperature,
              forecast.humidity,
              forecast.windSpeed,
              forecast.pressure,
            );

            if (prediction != null) {
              final wind = prediction['wind'] ?? 0.0;
              // If the predicted wind is dangerously fast (>= 10.0 m/s)
              if (wind >= 10.0) {
                // High wind threshold
                if (warningStart == null) {
                  // Mark the start of the warning period
                  warningStart = forecast.time;
                  warningEnd = forecast.time.add(const Duration(hours: 3));
                } else {
                  // Extend the warning period if high wind continues
                  warningEnd = forecast.time.add(const Duration(hours: 3));
                }
                // Keep track of the highest wind speed detected
                if (wind > maxWind) maxWind = wind;
              } else if (warningStart != null) {
                // Break out to only notify about the first continuous high wind period
                break;
              }
            }
          }

          // If we found a period with dangerously high wind
          if (warningStart != null && warningEnd != null) {
            final format = DateFormat('HH:mm');
            final timeRange =
                "${format.format(warningStart)} - ${format.format(warningEnd)}";

            // Show a notification alerting the user about the dangerous wind
            await notificationService.showPredictionNotification(
              "⚠️ High Wind Warning",
              "Expected winds up to ${maxWind.toStringAsFixed(1)} m/s between $timeRange.",
            );
          } else {
             // Debug / Informational notification so the user knows the check happened
            await notificationService.showPredictionNotification(
              "✅ Weather Check Complete",
              "No high winds expected in the next 24 hours.",
            );
          }
        } catch (e) {
          // If something goes wrong in the background task, print the error
          print('Background task error: $e');
        }
        break;
    }
    // Tell the system that the background task finished successfully
    return Future.value(true);
  });
}

// This is the starting point of the Flutter application
void main() async {
  // Ensure that Flutter bindings are initialized before calling async methods
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase to enable authentication and database services
  await Firebase.initializeApp();

  // Changed isInDebugMode to true so the user gets OS heads-up notifications when background jobs fire
  // Initialize Workmanager for background tasks (like checking the weather)
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  
  // Schedule the weather check task to run periodically every 15 minutes, but only if there is a network connection
  Workmanager().registerPeriodicTask(
    "weather_task_1",
    weatherUpdateTask,
    frequency: const Duration(minutes: 15),
    constraints: Constraints(networkType: NetworkType.connected),
  );

  // Load saved user preferences (like dark mode and language choice)
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;
  final languageCode = prefs.getString('languageCode') ?? 'en';

  // Run the app, wrapped in providers that manage the state for language and theme
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

// The root widget of the application
class DheewarayoApp extends StatelessWidget {
  const DheewarayoApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the current locale (language) and theme settings from our providers
    final localeProvider = Provider.of<LocaleProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    // MaterialApp is the main wrapper that provides material design styling and navigation
    return MaterialApp(
      title: 'Dheewarayo', // App name
      themeMode: themeProvider.themeMode, // Switch between dark and light mode automatically
      theme: dheewarayoTheme, // Our custom light theme defined in theme.dart
      darkTheme: dheewarayoDarkTheme, // Our custom dark theme defined in theme.dart
      // The AuthWrapper widget decides whether to show the Login screen or the Main screen based on if the user is signed in
      home: const AuthWrapper(),
      debugShowCheckedModeBanner: false, // Removes the small 'debug' banner from the top corner

      // Localization config: tells the app what language to use currently
      locale: localeProvider.locale,
      // Sets up support for translations (English and Sinhala in this case)
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
    );
  }
}

// A wrapper widget that listens to changes in user authentication state
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  // Create a stream that emits updates whenever the user signs in or out
  late final Stream<User?> _authStream;

  @override
  void initState() {
    super.initState();
    // Connect to our authentication service to get connection updates
    _authStream = AuthService().authStateChanges;
  }

  @override
  Widget build(BuildContext context) {
    // StreamBuilder rebuilds itself every time new data comes out of the auth stream
    return StreamBuilder<User?>(
      stream: _authStream,
      builder: (context, snapshot) {
        // Show a loading spinner while we wait to see if the user is already signed in
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // If the stream emitted a connected user, show the main dashboard
        if (snapshot.hasData) {
          return const MainScreen();
        }
        // If no user is found, show the login screen
        return const LoginScreen();
      },
    );
  }
}

// MainScreen holds the bottom navigation bar and switches between the main app features
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Keep track of which tab is currently selected at the bottom (0 is the first tab)
  int _selectedIndex = 0;

  // A list of the different screens that can be shown
  final List<Widget> _screens = [
    const HomeScreen(),        // Index 0
    const WeatherScreen(),     // Index 1
    const AIFishingScreen(),   // Index 2
    const CommunityScreen(),   // Index 3
    const SettingsScreen(),    // Index 4
  ];

  // This function is called whenever the user taps a different tab on the bottom bar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index to switch screens
    });
  }

  @override
  Widget build(BuildContext context) {
    // Load localized variables for translating bottom navigation labels
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      // Display the screen that matches the currently selected tab
      body: _screens[_selectedIndex],
      // Setup the bottom navigation bar with icons and text
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: l10n.navBarHome, // Translated "Home" text
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.cloud),
            label: l10n.navBarWeather, // Translated "Weather" text
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.radar),
            label: l10n.navBarAiFishing, // Translated "AI Fishing" text
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.people),
            label: l10n.navBarCommunity, // Translated "Community" text
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: l10n.navBarSettings, // Translated "Settings" text
          ),
        ],
        currentIndex: _selectedIndex, // Highlights the current tab
        onTap: _onItemTapped, // Handles taps on the tabs
      ),
    );
  }
}
