import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_si.dart';

abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('si'),
  ];

  String get appTitle;

  String get weatherAlert;

  String get community;

  String get settings;

  String get account;

  String get profile;

  String get securityPrivacy;

  String get appPreferences;

  String get notifications;

  String get language;

  String get darkMode;

  String get support;

  String get helpFAQ;

  String get aboutDheewarayo;

  String get logOut;

  String get home;

  String get weather;

  String get aiFishing;

  String get email;

  String get username;

  String get fullName;

  String get phoneNumber;

  String get saveChanges;

  String get profileUpdatedSuccessfully;

  String get aiFishingInsights;

  String get hotspotPredictionMap;

  String get interactiveMapPlaceholder;

  String get predictedHotspot;

  String get speciesIdentification;

  String get uploadCatchPhotoText;

  String get identifying;

  String get uploadCatchPhoto;

  String get aiResult;

  String localName(String name);

  String confidence(String percentage);

  String get regulations;

  String get sustainableFishingTips;

  String get checkMinimumSize;

  String get checkMinimumSizeDesc;

  String get catchAndRelease;

  String get catchAndReleaseDesc;

  String get dheewarayoTitle;

  String get weatherSummary;

  String get safeToSail;

  String get currentWeatherShort;

  String get nextHighTideShort;

  String get bestFishingWindow;

  String get fishingWindowTime;

  String get viewHotspotMap;

  String get latestCommunityPost;

  String get weatherAndSafety;

  String get criticalAlertHighWind;

  String get highWindWarningDesc;

  String get sevenDayMarineForecast;

  String get tenHourMarineForecast;

  String get today;

  String get sunnyLowSwell;

  String get nw10kts;

  String get tomorrow;

  String get cloudyHighWind;

  String get e25kts;

  String get day3;

  String get rainModerateSwell;

  String get s15kts;

  String windPrefix(String wind);

  String get tideChartPlaceholder;

  String get communityFeed;

  String get like;

  String get comment;

  String get share;

  String hoursAgo(String hours);

  String daysAgo(String days);

  String get navBarHome;

  String get navBarWeather;

  String get navBarAiFishing;

  String get navBarCommunity;

  String get navBarSettings;

  String get appVersion;

  String get projectDetails;

  String get projectDetailsContent;

  String get developerDetails;

  String get developerDetailsContent;

  String get universityDetails;

  String get universityDetailsContent;

  String get researchDetails;

  String get researchDetailsContent;

  String get faq1Question;

  String get faq1Answer;

  String get faq2Question;

  String get faq2Answer;

  String get faq3Question;

  String get faq3Answer;

  String get faq4Question;

  String get faq4Answer;

  String get faq5Question;

  String get faq5Answer;

  String get faq6Question;

  String get faq6Answer;

  String get faq7Question;

  String get faq7Answer;

  String get faq8Question;

  String get faq8Answer;

  String get faq9Question;

  String get faq9Answer;

  String get faq10Question;

  String get faq10Answer;

  String get noNotificationsMessage;

  String get notifHighWindTitle;

  String get notifHighWindContent;

  String get notifGoodFishingTitle;

  String get notifGoodFishingContent;

  String get notifAppUpdateTitle;

  String get notifAppUpdateContent;

  String get dataProtectionPolicy;

  String get dataProtectionPolicyContent;

  String get locationServices;

  String get locationServicesContent;

  String get accountSecurityPolicy;

  String get accountSecurityPolicyContent;

  String get dataSharingPolicy;

  String get dataSharingPolicyContent;

  String get territorialSea;

  String get contiguousZone;

  String get eez;

  String get indoSriLankaBoundary;

  String get internationalSea;

  String get mapLegend;

  String get addPost;

  String get writeCaption;

  String get selectImage;

  String get post;

  String get posting;

  String get loginFailed;

  String get resetPasswordEmailPrompt;

  String get resetPasswordEmailSent;

  String get failedToSendResetEmail;

  String googleSignInFailed(String error);

  String get anonymousSignInFailed;

  String get welcomeBack;

  String get signInToContinue;

  String get passwordLabel;

  String get pleaseEnterEmail;

  String get pleaseEnterPassword;

  String get forgotPassword;

  String get signInButton;

  String get orText;

  String get signInWithGoogle;

  String get continueAsGuest;

  String get dontHaveAccount;

  String get registerLink;

  String get logInLink;

  String get passwordsDoNotMatch;

  String get registrationSuccessful;

  String get registrationFailed;

  String anErrorOccurred(String error);

  String get createAccount;

  String get joinCommunity;

  String get mobileNumberLabel;

  String get confirmPasswordLabel;

  String get alreadyHaveAccount;

  String get requiredField;

  String get dummyCommunityPost;

  String get currentWeatherTitle;

  String get conditionsGoodTitle;

  String get conditionsGoodDesc;

  String get headsUpRoughWeather;

  String get roughWeatherDesc;

  String get windLabel;

  String get wavesLabel;

  String get rainLabel;

  String get humidityLabel;

  String get pressureLabel;

  String get noTideData;

  String get seaTideChartTitle;

  String get confirmLogoutPrompt;

  String get cancel;

  String get editPost;

  String get update;

  String get uploadPostBtn;

  String get updatePostBtn;

  String get clearBtn;

  String get pleaseLogInFirst;

  String get imageOrCaptionRequired;

  String failedToPost(String error);

  String get analyzingPfzData;

  String get excellent;

  String get good;

  String get moderate;

  String get beyondBoundary;

  String get somethingWentWrong;

  String get noPostsYet;

  String get unknownUser;

  String minutesAgo(String minutes);

  String get justNow;

  String get edit;

  String get delete;

  String get deletePostTitle;

  String get deletePostPrompt;

  String get postDeletedSuccessfully;

  String failedToDeletePost(String error);

  String get commentsTitle;

  String get postNotFound;

  String get noCommentsYet;

  String get addCommentHint;

  String get userLabel;

  String get postType;

  String get weatherAndSeaConditions;

  String get fishInformationAndTips;

  String get communityAndFishermanStories;

  String get others;

  String get date;

  String get time;

  String get place;

  String get weatherType;

  String get rain;

  String get storm;

  String get thunder;

  String get highWind;

  String get tsunami;

  String get pleaseFillAllRequiredFields;

  String get selectDate;

  String get selectTime;

  String get fishermanSettings;

  String get selectFishingDays;

  String get selectFishingTime;

  String get tapToSelectTime;

  String get selectBoatType;

  String get chooseYourBoatType;

  String get boatTypeTraditional;

  String get boatTypeFrp;

  String get boatTypeOneDay;

  String get boatTypeMultiDay;

  String get boatTypeTrawler;

  String get boatTypeOther;

  String get dayMo;

  String get dayTu;

  String get dayWe;

  String get dayTh;

  String get dayFr;

  String get daySa;

  String get daySu;

  String get pleaseSelectAtLeastOneDay;

  String get pleaseSelectATime;

  String get pleaseSelectABoatType;

  String get fishermanSettingsSavedSuccessfully;

  String failedToSaveData(String error);

  String get saveBtn;

  String get selectFishingArea;

  String get chooseYourFishingArea;

  String get pleaseSelectAFishingArea;

  String get cityNegombo;

  String get cityJaEla;

  String get cityWattala;

  String get cityColombo;

  String get cityDehiwala;

  String get cityMountLavinia;

  String get cityMoratuwa;

  String get cityAngulana;

  String get cityPanadura;

  String get cityKalutara;

  String get cityBeruwala;

  String get cityAluthgama;

  String get cityBentota;

  String get cityAmbalangoda;

  String get cityHikkaduwa;

  String get cityGalle;

  String get cityKoggala;

  String get cityWeligama;

  String get cityMirissa;

  String get cityMatara;

  String get cityDondra;

  String get cityDickwella;

  String get cityTangalle;

  String get cityHambantota;

  String get cityAmbalantota;

  String get cityPuttalam;

  String get cityKalpitiya;

  String get cityChilaw;

  String get cityWennappuwa;

  String get cityMarawila;

  String get cityMannar;

  String get cityPesalai;

  String get cityJaffna;

  String get cityPointPedro;

  String get cityKankesanthurai;

  String get cityTrincomalee;

  String get cityKinniya;

  String get cityMutur;

  String get cityVakarai;

  String get cityKalkudah;

  String get cityBatticaloa;

  String get cityKattankudy;

  String get cityKalmunai;

  String get cityAkkaraipattu;

  String get cityPottuvil;

  String get cityArugamBay;

  String get cityGampaha;

  String get cityAmpara;
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
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'si':
      return AppLocalizationsSi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool.',
  );
}
