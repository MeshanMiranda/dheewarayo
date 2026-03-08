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

  /// No description provided for @dheewarayoTitle.
  ///
  /// In en, this message translates to:
  /// **'Dheewarayo'**
  String get dheewarayoTitle;

  /// No description provided for @weatherSummary.
  ///
  /// In en, this message translates to:
  /// **'Weather Summary'**
  String get weatherSummary;

  /// No description provided for @safeToSail.
  ///
  /// In en, this message translates to:
  /// **'Safe to Sail'**
  String get safeToSail;

  /// No description provided for @currentWeatherShort.
  ///
  /// In en, this message translates to:
  /// **'Current: 28°C, Wind: 10 kts NW'**
  String get currentWeatherShort;

  /// No description provided for @nextHighTideShort.
  ///
  /// In en, this message translates to:
  /// **'Next High Tide: 14:30'**
  String get nextHighTideShort;

  /// No description provided for @bestFishingWindow.
  ///
  /// In en, this message translates to:
  /// **'Best Fishing Window'**
  String get bestFishingWindow;

  /// No description provided for @fishingWindowTime.
  ///
  /// In en, this message translates to:
  /// **'06:00 - 09:00 (High Probability)'**
  String get fishingWindowTime;

  /// No description provided for @viewHotspotMap.
  ///
  /// In en, this message translates to:
  /// **'View Hotspot Map ->'**
  String get viewHotspotMap;

  /// No description provided for @latestCommunityPost.
  ///
  /// In en, this message translates to:
  /// **'Latest Community Post'**
  String get latestCommunityPost;

  /// No description provided for @weatherAndSafety.
  ///
  /// In en, this message translates to:
  /// **'Weather & Safety'**
  String get weatherAndSafety;

  /// No description provided for @criticalAlertHighWind.
  ///
  /// In en, this message translates to:
  /// **'CRITICAL ALERT: High Wind Warning'**
  String get criticalAlertHighWind;

  /// No description provided for @highWindWarningDesc.
  ///
  /// In en, this message translates to:
  /// **'Winds up to 30 knots expected from 18:00 to 06:00. Exercise extreme caution.'**
  String get highWindWarningDesc;

  /// No description provided for @sevenDayMarineForecast.
  ///
  /// In en, this message translates to:
  /// **'7-Day Marine Forecast'**
  String get sevenDayMarineForecast;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @sunnyLowSwell.
  ///
  /// In en, this message translates to:
  /// **'Sunny, Low Swell'**
  String get sunnyLowSwell;

  /// No description provided for @nw10kts.
  ///
  /// In en, this message translates to:
  /// **'NW 10 kts'**
  String get nw10kts;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @cloudyHighWind.
  ///
  /// In en, this message translates to:
  /// **'Cloudy, High Wind'**
  String get cloudyHighWind;

  /// No description provided for @e25kts.
  ///
  /// In en, this message translates to:
  /// **'E 25 kts'**
  String get e25kts;

  /// No description provided for @day3.
  ///
  /// In en, this message translates to:
  /// **'Day 3'**
  String get day3;

  /// No description provided for @rainModerateSwell.
  ///
  /// In en, this message translates to:
  /// **'Rain, Moderate Swell'**
  String get rainModerateSwell;

  /// No description provided for @s15kts.
  ///
  /// In en, this message translates to:
  /// **'S 15 kts'**
  String get s15kts;

  /// No description provided for @windPrefix.
  ///
  /// In en, this message translates to:
  /// **'Wind: {wind}'**
  String windPrefix(String wind);

  /// No description provided for @tideChartPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Tide Chart Placeholder (Interactive Map)'**
  String get tideChartPlaceholder;

  /// No description provided for @communityFeed.
  ///
  /// In en, this message translates to:
  /// **'Community Feed'**
  String get communityFeed;

  /// No description provided for @like.
  ///
  /// In en, this message translates to:
  /// **'Like'**
  String get like;

  /// No description provided for @comment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get comment;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours} hours ago'**
  String hoursAgo(String hours);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days} day ago'**
  String daysAgo(String days);

  /// No description provided for @navBarHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navBarHome;

  /// No description provided for @navBarWeather.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get navBarWeather;

  /// No description provided for @navBarAiFishing.
  ///
  /// In en, this message translates to:
  /// **'AI Fishing'**
  String get navBarAiFishing;

  /// No description provided for @navBarCommunity.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get navBarCommunity;

  /// No description provided for @navBarSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navBarSettings;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get appVersion;

  /// No description provided for @projectDetails.
  ///
  /// In en, this message translates to:
  /// **'Project Details'**
  String get projectDetails;

  /// No description provided for @projectDetailsContent.
  ///
  /// In en, this message translates to:
  /// **'Dheewarayo is a smart mobile application designed to empower local fishing communities by providing weather alerts, AI-driven fishing hotspot predictions, and species identification capabilities. It aims to make fishing safer and more sustainable.'**
  String get projectDetailsContent;

  /// No description provided for @developerDetails.
  ///
  /// In en, this message translates to:
  /// **'Developer Details'**
  String get developerDetails;

  /// No description provided for @developerDetailsContent.
  ///
  /// In en, this message translates to:
  /// **'Developed by Meshan Miranda\nUndergraduate - Computer Science\nPassionate about AI and community-driven tech solutions.'**
  String get developerDetailsContent;

  /// No description provided for @universityDetails.
  ///
  /// In en, this message translates to:
  /// **'University Details'**
  String get universityDetails;

  /// No description provided for @universityDetailsContent.
  ///
  /// In en, this message translates to:
  /// **'BSc (Hons) in Computer Science\nUniversity of Bedfordshire\nSLIIT City Uni'**
  String get universityDetailsContent;

  /// No description provided for @researchDetails.
  ///
  /// In en, this message translates to:
  /// **'Research Details'**
  String get researchDetails;

  /// No description provided for @researchDetailsContent.
  ///
  /// In en, this message translates to:
  /// **'This application is a part of a final year research project focusing on applying Artificial Intelligence and Machine Learning techniques to optimize traditional fishing practices while strictly adhering to marine sustainability policies.'**
  String get researchDetailsContent;

  /// No description provided for @faq1Question.
  ///
  /// In en, this message translates to:
  /// **'How does the AI Fishing Prediction work?'**
  String get faq1Question;

  /// No description provided for @faq1Answer.
  ///
  /// In en, this message translates to:
  /// **'Our AI uses real-time weather, tide, and historical catch data to predict the best times and locations for fishing.'**
  String get faq1Answer;

  /// No description provided for @faq2Question.
  ///
  /// In en, this message translates to:
  /// **'How do I identify a species from a photo?'**
  String get faq2Question;

  /// No description provided for @faq2Answer.
  ///
  /// In en, this message translates to:
  /// **'Go to the AI Fishing tab, tap \"Upload Catch Photo\", and choose an image from your gallery or take a new one. The AI will identify it and provide regulations.'**
  String get faq2Answer;

  /// No description provided for @faq3Question.
  ///
  /// In en, this message translates to:
  /// **'What does \"Safe to Sail\" mean?'**
  String get faq3Question;

  /// No description provided for @faq3Answer.
  ///
  /// In en, this message translates to:
  /// **'It indicates that current and predicted weather conditions are within safe parameters for small vessels. Always exercise your own judgment as well.'**
  String get faq3Answer;

  /// No description provided for @faq4Question.
  ///
  /// In en, this message translates to:
  /// **'How do I change the app language?'**
  String get faq4Question;

  /// No description provided for @faq4Answer.
  ///
  /// In en, this message translates to:
  /// **'Go to Settings -> Language, and choose between English and Sinhala.'**
  String get faq4Answer;

  /// No description provided for @noNotificationsMessage.
  ///
  /// In en, this message translates to:
  /// **'No notifications right now.'**
  String get noNotificationsMessage;

  /// No description provided for @notifHighWindTitle.
  ///
  /// In en, this message translates to:
  /// **'High Wind Warning'**
  String get notifHighWindTitle;

  /// No description provided for @notifHighWindContent.
  ///
  /// In en, this message translates to:
  /// **'Winds up to 30 knots expected from 18:00 to 06:00. Exercise extreme caution.'**
  String get notifHighWindContent;

  /// No description provided for @notifGoodFishingTitle.
  ///
  /// In en, this message translates to:
  /// **'Good Fishing Window'**
  String get notifGoodFishingTitle;

  /// No description provided for @notifGoodFishingContent.
  ///
  /// In en, this message translates to:
  /// **'Predicted hotspot activity is high in your area for the next 3 hours.'**
  String get notifGoodFishingContent;

  /// No description provided for @notifAppUpdateTitle.
  ///
  /// In en, this message translates to:
  /// **'App Update'**
  String get notifAppUpdateTitle;

  /// No description provided for @notifAppUpdateContent.
  ///
  /// In en, this message translates to:
  /// **'Version 2.0 is out! Check out the new species identification features.'**
  String get notifAppUpdateContent;

  /// No description provided for @dataProtectionPolicy.
  ///
  /// In en, this message translates to:
  /// **'Data Protection Policy'**
  String get dataProtectionPolicy;

  /// No description provided for @dataProtectionPolicyContent.
  ///
  /// In en, this message translates to:
  /// **'Your data is encrypted and securely stored. We strictly comply with international data privacy regulations such as GDPR and CCPA to ensure your personal information is protected.'**
  String get dataProtectionPolicyContent;

  /// No description provided for @locationServices.
  ///
  /// In en, this message translates to:
  /// **'Location Services'**
  String get locationServices;

  /// No description provided for @locationServicesContent.
  ///
  /// In en, this message translates to:
  /// **'We only access your location while using the app to provide weather and fishing insights. Your location history is not shared with third-party advertisers.'**
  String get locationServicesContent;

  /// No description provided for @accountSecurityPolicy.
  ///
  /// In en, this message translates to:
  /// **'Account Security'**
  String get accountSecurityPolicy;

  /// No description provided for @accountSecurityPolicyContent.
  ///
  /// In en, this message translates to:
  /// **'We use industry-standard encryption protocols. We recommend using a strong password and enabling two-factor authentication if available.'**
  String get accountSecurityPolicyContent;

  /// No description provided for @dataSharingPolicy.
  ///
  /// In en, this message translates to:
  /// **'Data Sharing'**
  String get dataSharingPolicy;

  /// No description provided for @dataSharingPolicyContent.
  ///
  /// In en, this message translates to:
  /// **'We never sell your personal information. Data shared with partners is anonymized and strictly used to improve fishing predictions and marine safety.'**
  String get dataSharingPolicyContent;

  /// No description provided for @territorialSea.
  ///
  /// In en, this message translates to:
  /// **'Territorial Sea'**
  String get territorialSea;

  /// No description provided for @contiguousZone.
  ///
  /// In en, this message translates to:
  /// **'Contiguous Zone'**
  String get contiguousZone;

  /// No description provided for @eez.
  ///
  /// In en, this message translates to:
  /// **'Exclusive Economic Zone (EEZ)'**
  String get eez;

  /// No description provided for @indoSriLankaBoundary.
  ///
  /// In en, this message translates to:
  /// **'Indo–Sri Lanka Maritime Boundary'**
  String get indoSriLankaBoundary;

  /// No description provided for @internationalSea.
  ///
  /// In en, this message translates to:
  /// **'International Sea'**
  String get internationalSea;

  /// No description provided for @mapLegend.
  ///
  /// In en, this message translates to:
  /// **'Map Legend'**
  String get mapLegend;

  /// No description provided for @addPost.
  ///
  /// In en, this message translates to:
  /// **'Add Post'**
  String get addPost;

  /// No description provided for @writeCaption.
  ///
  /// In en, this message translates to:
  /// **'Write a caption...'**
  String get writeCaption;

  /// No description provided for @selectImage.
  ///
  /// In en, this message translates to:
  /// **'Select Image'**
  String get selectImage;

  /// No description provided for @post.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get post;

  /// No description provided for @posting.
  ///
  /// In en, this message translates to:
  /// **'Posting...'**
  String get posting;
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
