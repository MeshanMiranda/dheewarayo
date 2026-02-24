import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_si.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('si'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Safe Fishing App'**
  String get appTitle;

  /// No description provided for @weatherAlert.
  ///
  /// In en, this message translates to:
  /// **'Weather Alert'**
  String get weatherAlert;

  /// No description provided for @community.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get community;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @securityPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Security & Privacy'**
  String get securityPrivacy;

  /// No description provided for @appPreferences.
  ///
  /// In en, this message translates to:
  /// **'App Preferences'**
  String get appPreferences;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @helpFAQ.
  ///
  /// In en, this message translates to:
  /// **'Help & FAQ'**
  String get helpFAQ;

  /// No description provided for @aboutDheewarayo.
  ///
  /// In en, this message translates to:
  /// **'About Dheewarayo'**
  String get aboutDheewarayo;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @weather.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get weather;

  /// No description provided for @aiFishing.
  ///
  /// In en, this message translates to:
  /// **'AI Fishing'**
  String get aiFishing;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @aiFishingInsights.
  ///
  /// In en, this message translates to:
  /// **'AI Fishing Insights'**
  String get aiFishingInsights;

  /// No description provided for @hotspotPredictionMap.
  ///
  /// In en, this message translates to:
  /// **'Hotspot Prediction Map'**
  String get hotspotPredictionMap;

  /// No description provided for @interactiveMapPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Interactive Map Placeholder (Google Maps)'**
  String get interactiveMapPlaceholder;

  /// No description provided for @predictedHotspot.
  ///
  /// In en, this message translates to:
  /// **'Predicted Hotspot: 5km North-East (High Confidence)'**
  String get predictedHotspot;

  /// No description provided for @speciesIdentification.
  ///
  /// In en, this message translates to:
  /// **'Species Identification'**
  String get speciesIdentification;

  /// No description provided for @uploadCatchPhotoText.
  ///
  /// In en, this message translates to:
  /// **'Upload a photo of your catch to instantly identify the species and check local regulations.'**
  String get uploadCatchPhotoText;

  /// No description provided for @identifying.
  ///
  /// In en, this message translates to:
  /// **'Identifying...'**
  String get identifying;

  /// No description provided for @uploadCatchPhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload Catch Photo'**
  String get uploadCatchPhoto;

  /// No description provided for @aiResult.
  ///
  /// In en, this message translates to:
  /// **'AI Result:'**
  String get aiResult;

  /// No description provided for @localName.
  ///
  /// In en, this message translates to:
  /// **'Local Name: {name}'**
  String localName(String name);

  /// No description provided for @confidence.
  ///
  /// In en, this message translates to:
  /// **'Confidence: {percentage}%'**
  String confidence(String percentage);

  /// No description provided for @regulations.
  ///
  /// In en, this message translates to:
  /// **'Regulations'**
  String get regulations;

  /// No description provided for @sustainableFishingTips.
  ///
  /// In en, this message translates to:
  /// **'Sustainable Fishing Tips'**
  String get sustainableFishingTips;

  /// No description provided for @checkMinimumSize.
  ///
  /// In en, this message translates to:
  /// **'Check Minimum Size'**
  String get checkMinimumSize;

  /// No description provided for @checkMinimumSizeDesc.
  ///
  /// In en, this message translates to:
  /// **'Always verify the minimum legal size before keeping a fish.'**
  String get checkMinimumSizeDesc;

  /// No description provided for @catchAndRelease.
  ///
  /// In en, this message translates to:
  /// **'Catch and Release'**
  String get catchAndRelease;

  /// No description provided for @catchAndReleaseDesc.
  ///
  /// In en, this message translates to:
  /// **'Use proper techniques to ensure high survival rates for released fish.'**
  String get catchAndReleaseDesc;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'si'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'si':
      return AppLocalizationsSi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
