import 'dart:convert';

import 'package:visaamigo/utils/date_util.dart';

import '../../../utils/utils.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class DeviceRegistrationToken {
  DeviceRegistrationToken({
    required this.platform,
    required this.token,
  });

  DeviceRegistrationToken.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      platform = json['platform']?.toString() ?? '';
      token = json['token']?.toString() ?? '';
    } else {
      // Handle case where json might be a different type
      platform = '';
      token = '';
    }
  }

  late String platform;
  late String token;

  DeviceRegistrationToken copyWith({
    String? platform,
    String? token,
  }) =>
      DeviceRegistrationToken(
        platform: platform ?? this.platform,
        token: token ?? this.token,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['platform'] = platform;
    map['token'] = token;
    return map;
  }
}

class UserModel {
  UserModel({
    String? firstName,
    String? lastName,
    String? email,
    String? passowrd,
    bool? companion,
    String? id,
    String? userId,
    String? preferredLanguage,
    List<DeviceRegistrationToken>? registrationTokens,
    Settings? settings,
    UserPreferences? userPreferences,
    bool? termsAccepted,
    String? evaIntroNode,
    String? userAnalyticsId,
  }) {
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    _passowrd = passowrd;
    _companion = companion;
    _id = id;
    _userId = userId;
    _preferredLanguage = preferredLanguage;
    _settings = settings;
    _userPreferences = userPreferences;
    _termsAccepted = termsAccepted;
    _registrationTokens = registrationTokens;
    _userAnalyticsId = userAnalyticsId;
  }

  // coverage:ignore-start
  UserModel.fromJson(dynamic json) {
    try {
      _firstName = json['first_name'];
      _lastName = json['last_name'];
      _email = json['email'];
      _passowrd = json['passowrd'];
      _companion = json['companion'];
      _id = json['id'];
      _userId = json['user_id'];
      _preferredLanguage = json['preferred_language'];
      _settings =
          json['settings'] != null ? Settings.fromJson(json['settings']) : null;
      _userPreferences = json['user_preferences'] != null
          ? UserPreferences.fromJson(json['user_preferences'])
          : null;
      _termsAccepted = json['terms_accepted'];
      _userAnalyticsId = json['user_analytics_id'] ?? "";

      _registrationTokens =
          _parseRegistrationTokens(json['device_registration_tokens']);
    } catch (e) {
      // Log the error and provide fallback values
      Utils.logPrint('Error parsing UserModel from JSON: $e');
      Utils.logPrint('JSON data: $json');

      // Set default values to prevent null pointer exceptions
      _firstName = '';
      _lastName = '';
      _email = '';
      _passowrd = '';
      _companion = false;
      _id = '';
      _userId = '';
      _preferredLanguage = '';
      _settings = null;
      _userPreferences = null;
      _termsAccepted = false;
      _userAnalyticsId = '';
      _registrationTokens = [];
    }
  }

  String? _firstName;
  String? _lastName;
  String? _email;
  String? _passowrd;
  bool? _companion;
  String? _id;
  String? _userId;
  String? _preferredLanguage;
  List<DeviceRegistrationToken>? _registrationTokens;
  Settings? _settings;
  UserPreferences? _userPreferences;
  bool? _termsAccepted;
  String? _userAnalyticsId;

  UserModel copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? passowrd,
    bool? companion,
    String? id,
    String? userId,
    String? preferredLanguage,
    Settings? settings,
    UserPreferences? userPreferences,
    List<DeviceRegistrationToken>? registrationTokens,
    bool? termsAccepted,
    String? userAnalyticsId,
  }) =>
      UserModel(
        firstName: firstName ?? _firstName,
        lastName: lastName ?? _lastName,
        email: email ?? _email,
        passowrd: passowrd ?? _passowrd,
        companion: companion ?? _companion,
        id: id ?? _id,
        userId: userId ?? _userId,
        preferredLanguage: preferredLanguage ?? _preferredLanguage,
        settings: settings ?? _settings,
        userPreferences: userPreferences ?? _userPreferences,
        termsAccepted: termsAccepted ?? _termsAccepted,
        registrationTokens: registrationTokens ?? _registrationTokens,
        userAnalyticsId: userAnalyticsId ?? _userAnalyticsId,
      );

  String get firstName => _firstName != null && _firstName!.isNotEmpty
      ? _firstName![0].toUpperCase() + _firstName!.substring(1)
      : "";

  String get lastName => _lastName != null && _lastName!.isNotEmpty
      ? _lastName![0].toUpperCase() + _lastName!.substring(1)
      : "";

  String get email => _email ?? "";

  String get passowrd => _passowrd ?? "";

  bool get companion => _companion ?? false;

  String get id => _id ?? "";

  String get userId => _userId ?? "";

  List<DeviceRegistrationToken> get registrationTokens =>
      _registrationTokens ?? [];

  String get userAnalyticsId => _userAnalyticsId ?? "";

  set firstName(String value) {
    _firstName = value;
  }

  set lastName(String value) {
    _lastName = value;
  }

  String get preferredLanguage => _preferredLanguage ?? "";

  Settings? get settings => _settings;

  // UserPreferences? get userPreferences => _userPreferences;

  bool get termsAccepted => _termsAccepted ?? false;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['first_name'] = _firstName;
    map['last_name'] = _lastName;
    map['email'] = _email;
    map['passowrd'] = _passowrd;
    map['companion'] = _companion;
    map['id'] = _id;
    map['user_id'] = _userId;
    map['preferred_language'] = _preferredLanguage;
    map['user_analytics_id'] = _userAnalyticsId;
    if (_settings != null) {
      map['settings'] = _settings?.toJson();
    }
    if (_userPreferences != null) {
      map['user_preferences'] = _userPreferences?.toJson();
    }
    map['terms_accepted'] = _termsAccepted;
    map['device_registration_tokens'] =
        _registrationTokens?.map((x) => x.toJson()).toList() ?? [];

    return map;
  }

  Map<String, dynamic> toAwsJson() {
    final map = <String, dynamic>{};
    // map['first_name'] = _firstName;
    // map['last_name'] = _lastName;
    // map['passowrd'] = _passowrd;
    // map['id'] = _id;
    // map['user_id'] = _userId;
    if (_preferredLanguage != null) {
      map['preferred_language'] = _preferredLanguage;
    }

    // if (_userAnalyticsId != null) {
    //   map['user_analytics_id'] = _userAnalyticsId;
    // }

    if (_settings != null) {
      map['settings'] = _settings?.toJson();
    }

    if (_termsAccepted != null) {
      map['terms_accepted'] = _termsAccepted;
    }

    map['device_registration_tokens'] =
        _registrationTokens?.map((x) => x.toJson()).toList() ?? [];
    return map;
  }

  set email(String value) {
    _email = value;
  }

  set passowrd(String value) {
    _passowrd = value;
  }

  set companion(bool value) {
    _companion = value;
  }

  set id(String value) {
    _id = value;
  }

  set userId(String value) {
    _userId = value;
  }

  set preferredLanguage(String value) {
    _preferredLanguage = value;
  }

  set settings(Settings? value) {
    _settings = value;
  }

  set userPreferences(UserPreferences value) {
    _userPreferences = value;
  }

  set termsAccepted(bool value) {
    _termsAccepted = value;
  }

  set userAnalyticsId(String value) {
    _userAnalyticsId = value;
  }

  /// Safely parse registration tokens from JSON
  List<DeviceRegistrationToken> _parseRegistrationTokens(dynamic tokensData) {
    if (tokensData == null) return [];

    try {
      // Debug: Log the type and structure of tokensData
      Utils.logPrint('Debug: tokensData content: $tokensData');

      // Handle case where tokensData is a List<dynamic> from JSON
      if (tokensData is List) {
        return tokensData
            .where((item) => item != null)
            .map((item) => DeviceRegistrationToken.fromJson(item))
            .toList();
      }

      // Handle case where tokensData might already be List<DeviceRegistrationToken>
      if (tokensData is List<DeviceRegistrationToken>) {
        return tokensData;
      }
    } catch (e) {
      // Log error but don't crash the app
      Utils.logPrint('Error parsing registration tokens: $e');
      Utils.logPrint('Error details: tokensData = $tokensData');
    }

    return [];
  }
}

/// cuisine_preferences : ["1","2","3"]
/// activity_preferences : ["1","2","3"]

UserPreferences userPreferencesFromJson(String str) =>
    UserPreferences.fromJson(json.decode(str));

String userPreferencesToJson(UserPreferences data) =>
    json.encode(data.toJson());

class UserPreferences {
  UserPreferences({
    List<String>? cuisinePreferences,
    List<String>? activityPreferences,
  }) {
    _cuisinePreferences = cuisinePreferences;
    _activityPreferences = activityPreferences;
  }

  UserPreferences.fromJson(dynamic json) {
    _cuisinePreferences = json['cuisine_preferences'] != null
        ? json['cuisine_preferences'].cast<String>()
        : [];
    _activityPreferences = json['activity_preferences'] != null
        ? json['activity_preferences'].cast<String>()
        : [];
  }

  List<String>? _cuisinePreferences;
  List<String>? _activityPreferences;

  UserPreferences copyWith({
    List<String>? cuisinePreferences,
    List<String>? activityPreferences,
  }) =>
      UserPreferences(
        cuisinePreferences: cuisinePreferences ?? _cuisinePreferences,
        activityPreferences: activityPreferences ?? _activityPreferences,
      );

  List<String>? get cuisinePreferences => _cuisinePreferences;

  List<String>? get activityPreferences => _activityPreferences;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['cuisine_preferences'] = _cuisinePreferences ?? [];
    map['activity_preferences'] = _activityPreferences ?? [];
    return map;
  }
}

/// notifications_enabled : true
/// mfa_enabled : true
/// user_analytics_permission_granted_at : true
/// tutorial_completed : false
/// prepaid_card_issued : true

Settings settingsFromJson(String str) => Settings.fromJson(json.decode(str));

String settingsToJson(Settings data) => json.encode(data.toJson());

class Settings {
  Settings({
    bool? notificationsEnabled,
    bool? mfaEnabled,
    String? userAnalyticsPermissionGrantedAt,
    bool? tutorialCompleted,
    bool? prepaidCardIssued,
  }) {
    _notificationsEnabled = notificationsEnabled;
    _mfaEnabled = mfaEnabled;
    _userAnalyticsPermissionGrantedAt = userAnalyticsPermissionGrantedAt;
    _tutorialCompleted = tutorialCompleted;
    _prepaidCardIssued = prepaidCardIssued;
  }

  Settings.fromJson(dynamic json) {
    _notificationsEnabled = json['notifications_enabled'];
    _mfaEnabled = json['mfa_enabled'];
    _userAnalyticsPermissionGrantedAt =
        json['user_analytics_permission_granted_at'];
    _tutorialCompleted = json['tutorial_completed'];
    _prepaidCardIssued = json['prepaid_card_issued'];
  }

  bool? _notificationsEnabled;
  bool? _mfaEnabled;
  String? _userAnalyticsPermissionGrantedAt;
  bool? _tutorialCompleted;
  bool? _prepaidCardIssued;

  Settings copyWith({
    bool? notificationsEnabled,
    bool? mfaEnabled,
    String? userAnalyticsPermissionGrantedAt,
    bool? tutorialCompleted,
    bool? prepaidCardIssued,
  }) =>
      Settings(
        notificationsEnabled: notificationsEnabled ?? _notificationsEnabled,
        mfaEnabled: mfaEnabled ?? _mfaEnabled,
        userAnalyticsPermissionGrantedAt: userAnalyticsPermissionGrantedAt ??
            _userAnalyticsPermissionGrantedAt,
        tutorialCompleted: tutorialCompleted ?? _tutorialCompleted,
        prepaidCardIssued: prepaidCardIssued ?? _prepaidCardIssued,
      );

  bool? get notificationsEnabled => _notificationsEnabled;

  bool? get mfaEnabled => _mfaEnabled;

  String? get userAnalyticsPermissionGrantedAt =>
      _userAnalyticsPermissionGrantedAt;

  bool? get tutorialCompleted => _tutorialCompleted;

  bool? get prepaidCardIssued => _prepaidCardIssued;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['notifications_enabled'] = _notificationsEnabled ?? false;
    map['mfa_enabled'] = _mfaEnabled ?? false;
    map['user_analytics_permission_granted_at'] =
        _userAnalyticsPermissionGrantedAt ?? DateUtil.getUtcTime();
    map['tutorial_completed'] = _tutorialCompleted ?? false;
    map['prepaid_card_issued'] = _prepaidCardIssued ?? false;
    return map;
  }
// coverage:ignore-end
}
