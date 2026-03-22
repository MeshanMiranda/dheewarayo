// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Safe Fishing App';

  @override
  String get weatherAlert => 'Weather Alert';

  @override
  String get community => 'Community';

  @override
  String get settings => 'Settings';

  @override
  String get account => 'Account';

  @override
  String get profile => 'Profile';

  @override
  String get securityPrivacy => 'Security & Privacy';

  @override
  String get appPreferences => 'App Preferences';

  @override
  String get notifications => 'Notifications';

  @override
  String get language => 'Language';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get support => 'Support';

  @override
  String get helpFAQ => 'Help & FAQ';

  @override
  String get aboutDheewarayo => 'About Dheewarayo';

  @override
  String get logOut => 'Log Out';

  @override
  String get home => 'Home';

  @override
  String get weather => 'Weather';

  @override
  String get aiFishing => 'AI Fishing';

  @override
  String get email => 'Email';

  @override
  String get username => 'Username';

  @override
  String get fullName => 'Full Name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get profileUpdatedSuccessfully => 'Profile updated successfully!';

  @override
  String get aiFishingInsights => 'AI Fishing Insights';

  @override
  String get hotspotPredictionMap => 'Hotspot Prediction Map';

  @override
  String get interactiveMapPlaceholder =>
      'Interactive Map Placeholder (Google Maps)';

  @override
  String get predictedHotspot =>
      'Predicted Hotspot: 5km North-East (High Confidence)';

  @override
  String get speciesIdentification => 'Species Identification';

  @override
  String get uploadCatchPhotoText =>
      'Upload a photo of your catch to instantly identify the species and check local regulations.';

  @override
  String get identifying => 'Identifying...';

  @override
  String get uploadCatchPhoto => 'Upload Catch Photo';

  @override
  String get aiResult => 'AI Result:';

  @override
  String localName(String name) {
    return 'Local Name: $name';
  }

  @override
  String confidence(String percentage) {
    return 'Confidence: $percentage%';
  }

  @override
  String get regulations => 'Regulations';

  @override
  String get sustainableFishingTips => 'Sustainable Fishing Tips';

  @override
  String get checkMinimumSize => 'Check Minimum Size';

  @override
  String get checkMinimumSizeDesc =>
      'Always verify the minimum legal size before keeping a fish.';

  @override
  String get catchAndRelease => 'Catch and Release';

  @override
  String get catchAndReleaseDesc =>
      'Use proper techniques to ensure high survival rates for released fish.';

  @override
  String get dheewarayoTitle => 'Dheewarayo';

  @override
  String get weatherSummary => 'Weather Summary';

  @override
  String get safeToSail => 'Safe to Sail';

  @override
  String get currentWeatherShort => 'Current: 28°C, Wind: 10 kts NW';

  @override
  String get nextHighTideShort => 'Next High Tide: 14:30';

  @override
  String get bestFishingWindow => 'Best Fishing Window';

  @override
  String get fishingWindowTime => '06:00 - 09:00 (High Probability)';

  @override
  String get viewHotspotMap => 'View Hotspot Map ->';

  @override
  String get latestCommunityPost => 'Latest Community Post';

  @override
  String get weatherAndSafety => 'Weather & Safety';

  @override
  String get criticalAlertHighWind => 'CRITICAL ALERT: High Wind Warning';

  @override
  String get highWindWarningDesc =>
      'Winds up to 30 knots expected from 18:00 to 06:00. Exercise extreme caution.';

  @override
  String get sevenDayMarineForecast => '5-Day Marine Forecast';

  @override
  String get today => 'Today';

  @override
  String get sunnyLowSwell => 'Sunny, Low Swell';

  @override
  String get nw10kts => 'NW 10 kts';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get cloudyHighWind => 'Cloudy, High Wind';

  @override
  String get e25kts => 'E 25 kts';

  @override
  String get day3 => 'Day 3';

  @override
  String get rainModerateSwell => 'Rain, Moderate Swell';

  @override
  String get s15kts => 'S 15 kts';

  @override
  String windPrefix(String wind) {
    return 'Wind: $wind';
  }

  @override
  String get tideChartPlaceholder => 'Tide Chart Placeholder (Interactive Map)';

  @override
  String get communityFeed => 'Community Feed';

  @override
  String get like => 'Like';

  @override
  String get comment => 'Comment';

  @override
  String get share => 'Share';

  @override
  String hoursAgo(String hours) {
    return '$hours hours ago';
  }

  @override
  String daysAgo(String days) {
    return '$days day ago';
  }

  @override
  String get navBarHome => 'Home';

  @override
  String get navBarWeather => 'Weather';

  @override
  String get navBarAiFishing => 'AI Fishing';

  @override
  String get navBarCommunity => 'Community';

  @override
  String get navBarSettings => 'Settings';

  @override
  String get appVersion => 'Version 1.0.0';

  @override
  String get projectDetails => 'Project Details';

  @override
  String get projectDetailsContent =>
      'Dheewarayo is a smart mobile application designed to empower local fishing communities by providing weather alerts, AI-driven fishing hotspot predictions, and species identification capabilities. It aims to make fishing safer and more sustainable.';

  @override
  String get developerDetails => 'Developer Details';

  @override
  String get developerDetailsContent =>
      'Developed by Meshan Miranda\nUndergraduate - Computer Science\nPassionate about AI and community-driven tech solutions.';

  @override
  String get universityDetails => 'University Details';

  @override
  String get universityDetailsContent =>
      'BSc (Hons) in Computer Science\nUniversity of Bedfordshire\nSLIIT City Uni';

  @override
  String get researchDetails => 'Research Details';

  @override
  String get researchDetailsContent =>
      'This application is a part of a final year research project focusing on applying Artificial Intelligence and Machine Learning techniques to optimize traditional fishing practices while strictly adhering to marine sustainability policies.';

  @override
  String get faq1Question => 'How does the AI Fishing Prediction work?';

  @override
  String get faq1Answer =>
      'Our AI uses real-time weather, tide, and historical catch data to predict the best times and locations for fishing.';

  @override
  String get faq2Question => 'How do I identify a species from a photo?';

  @override
  String get faq2Answer =>
      'Go to the AI Fishing tab, tap \"Upload Catch Photo\", and choose an image from your gallery or take a new one. The AI will identify it and provide regulations.';

  @override
  String get faq3Question => 'What does \"Safe to Sail\" mean?';

  @override
  String get faq3Answer =>
      'It indicates that current and predicted weather conditions are within safe parameters for small vessels. Always exercise your own judgment as well.';

  @override
  String get faq4Question => 'How do I change the app language?';

  @override
  String get faq4Answer =>
      'Go to Settings -> Language, and choose between English and Sinhala.';

  @override
  String get noNotificationsMessage => 'No notifications right now.';

  @override
  String get notifHighWindTitle => 'High Wind Warning';

  @override
  String get notifHighWindContent =>
      'Winds up to 30 knots expected from 18:00 to 06:00. Exercise extreme caution.';

  @override
  String get notifGoodFishingTitle => 'Good Fishing Window';

  @override
  String get notifGoodFishingContent =>
      'Predicted hotspot activity is high in your area for the next 3 hours.';

  @override
  String get notifAppUpdateTitle => 'App Update';

  @override
  String get notifAppUpdateContent =>
      'Version 2.0 is out! Check out the new species identification features.';

  @override
  String get dataProtectionPolicy => 'Data Protection Policy';

  @override
  String get dataProtectionPolicyContent =>
      'Your data is encrypted and securely stored. We strictly comply with international data privacy regulations such as GDPR and CCPA to ensure your personal information is protected.';

  @override
  String get locationServices => 'Location Services';

  @override
  String get locationServicesContent =>
      'We only access your location while using the app to provide weather and fishing insights. Your location history is not shared with third-party advertisers.';

  @override
  String get accountSecurityPolicy => 'Account Security';

  @override
  String get accountSecurityPolicyContent =>
      'We use industry-standard encryption protocols. We recommend using a strong password and enabling two-factor authentication if available.';

  @override
  String get dataSharingPolicy => 'Data Sharing';

  @override
  String get dataSharingPolicyContent =>
      'We never sell your personal information. Data shared with partners is anonymized and strictly used to improve fishing predictions and marine safety.';

  @override
  String get territorialSea => 'Territorial Sea';

  @override
  String get contiguousZone => 'Contiguous Zone';

  @override
  String get eez => 'Exclusive Economic Zone (EEZ)';

  @override
  String get indoSriLankaBoundary => 'Indo–Sri Lanka Maritime Boundary';

  @override
  String get internationalSea => 'International Sea';

  @override
  String get mapLegend => 'Map Legend';

  @override
  String get addPost => 'Add Post';

  @override
  String get writeCaption => 'Write a caption...';

  @override
  String get selectImage => 'Select Image';

  @override
  String get post => 'Post';

  @override
  String get posting => 'Posting...';
}
