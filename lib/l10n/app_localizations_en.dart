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
}
