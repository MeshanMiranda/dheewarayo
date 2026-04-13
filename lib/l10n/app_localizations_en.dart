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
  String get tenHourMarineForecast => '10-Hour Marine Forecast';

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

  @override
  String get loginFailed => 'Login failed';

  @override
  String get resetPasswordEmailPrompt =>
      'Please enter your email to reset password.';

  @override
  String get resetPasswordEmailSent =>
      'Password reset email sent. Please check your inbox.';

  @override
  String get failedToSendResetEmail => 'Failed to send reset email';

  @override
  String googleSignInFailed(String error) {
    return 'Google Sign-In failed: $error';
  }

  @override
  String get anonymousSignInFailed => 'Anonymous Sign-In failed';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get signInToContinue => 'Sign in to continue to Dheewarayo';

  @override
  String get passwordLabel => 'Password';

  @override
  String get pleaseEnterEmail => 'Please enter your email';

  @override
  String get pleaseEnterPassword => 'Please enter your password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get signInButton => 'Sign In';

  @override
  String get orText => 'OR';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get continueAsGuest => 'Continue as Guest';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get registerLink => 'Register';

  @override
  String get logInLink => 'Log In';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get registrationSuccessful => 'Registration successful!';

  @override
  String get registrationFailed => 'Registration failed';

  @override
  String anErrorOccurred(String error) {
    return 'An error occurred: $error';
  }

  @override
  String get createAccount => 'Create an Account';

  @override
  String get joinCommunity => 'Join the Dheewarayo community';

  @override
  String get mobileNumberLabel => 'Mobile Number';

  @override
  String get confirmPasswordLabel => 'Confirm Password';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get requiredField => 'Required';

  @override
  String get dummyCommunityPost =>
      'Negombo North Side Eke Sahenna Malu Ahuwenawa.';

  @override
  String get currentWeatherTitle => 'Current Weather';

  @override
  String get conditionsGoodTitle => 'Conditions look good!';

  @override
  String get conditionsGoodDesc =>
      'The weather is expected to remain safe for the next hour.';

  @override
  String get headsUpRoughWeather => 'Heads Up! Rough Weather';

  @override
  String get roughWeatherDesc =>
      'Please be careful. Here\'s what to expect in the next hour:';

  @override
  String get windLabel => 'Wind';

  @override
  String get wavesLabel => 'Waves';

  @override
  String get rainLabel => 'Rain';

  @override
  String get humidityLabel => 'Humidity';

  @override
  String get pressureLabel => 'Pressure';

  @override
  String get noTideData => 'No Tide Data Available';

  @override
  String get seaTideChartTitle => 'Sea Tide Chart';

  @override
  String get confirmLogoutPrompt => 'Are you sure you want to log out?';

  @override
  String get cancel => 'Cancel';

  @override
  String get editPost => 'Edit Post';

  @override
  String get update => 'Update';

  @override
  String get uploadPostBtn => 'Upload post';

  @override
  String get updatePostBtn => 'Update post';

  @override
  String get clearBtn => 'Clear';

  @override
  String get pleaseLogInFirst => 'Please log in first';

  @override
  String get imageOrCaptionRequired => 'Please add an image or caption';

  @override
  String failedToPost(String error) {
    return 'Failed to post: $error';
  }

  @override
  String get analyzingPfzData => 'Analyzing oceanographic data for PFZ...';

  @override
  String get excellent => 'Excellent';

  @override
  String get good => 'Good';

  @override
  String get moderate => 'Moderate';

  @override
  String get beyondBoundary => 'Beyond Boundary';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get noPostsYet => 'No posts yet. Be the first to post!';

  @override
  String get unknownUser => 'Unknown User';

  @override
  String minutesAgo(String minutes) {
    return '$minutes minutes ago';
  }

  @override
  String get justNow => 'Just now';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get deletePostTitle => 'Delete Post';

  @override
  String get deletePostPrompt => 'Are you sure you want to delete this post?';

  @override
  String get postDeletedSuccessfully => 'Post deleted successfully';

  @override
  String failedToDeletePost(String error) {
    return 'Failed to delete post: $error';
  }

  @override
  String get commentsTitle => 'Comments';

  @override
  String get postNotFound => 'Post not found.';

  @override
  String get noCommentsYet => 'No comments yet.';

  @override
  String get addCommentHint => 'Add a comment...';

  @override
  String get userLabel => 'User';

  @override
  String get postType => 'Post Type';

  @override
  String get weatherAndSeaConditions => 'Weather & Sea Conditions';

  @override
  String get fishInformationAndTips => 'Fish Information & Tips';

  @override
  String get communityAndFishermanStories => 'Community & Fisherman Stories';

  @override
  String get others => 'Others';

  @override
  String get date => 'Date';

  @override
  String get time => 'Time';

  @override
  String get place => 'Place';

  @override
  String get weatherType => 'Weather Type';

  @override
  String get rain => 'Rain';

  @override
  String get storm => 'Storm';

  @override
  String get thunder => 'Thunder';

  @override
  String get highWind => 'High Wind';

  @override
  String get tsunami => 'Tsunami';

  @override
  String get pleaseFillAllRequiredFields => 'Please fill all required fields';

  @override
  String get selectDate => 'Select Date';

  @override
  String get selectTime => 'Select Time';

  @override
  String get fishermanSettings => 'Fisherman Settings';

  @override
  String get selectFishingDays => 'Select Fishing Days';

  @override
  String get selectFishingTime => 'Select Fishing Time';

  @override
  String get tapToSelectTime => 'Tap to select time';

  @override
  String get selectBoatType => 'Select Boat Type';

  @override
  String get chooseYourBoatType => 'Choose your boat type';

  @override
  String get boatTypeTraditional => 'Traditional Canoe (Oruwa)';

  @override
  String get boatTypeFrp => 'FRP Boat (Fiber Reinforced Plastic)';

  @override
  String get boatTypeOneDay => 'One-day Boat';

  @override
  String get boatTypeMultiDay => 'Multi-day Boat';

  @override
  String get boatTypeTrawler => 'Trawler';

  @override
  String get boatTypeOther => 'Other';

  @override
  String get dayMo => 'M';

  @override
  String get dayTu => 'T';

  @override
  String get dayWe => 'W';

  @override
  String get dayTh => 'T';

  @override
  String get dayFr => 'F';

  @override
  String get daySa => 'S';

  @override
  String get daySu => 'S';

  @override
  String get pleaseSelectAtLeastOneDay => 'Please select at least one day.';

  @override
  String get pleaseSelectATime => 'Please select a time.';

  @override
  String get pleaseSelectABoatType => 'Please select a boat type.';

  @override
  String get fishermanSettingsSavedSuccessfully =>
      'Fisherman settings saved successfully!';

  @override
  String failedToSaveData(String error) {
    return 'Failed to save data: $error';
  }

  @override
  String get saveBtn => 'Save';
}
