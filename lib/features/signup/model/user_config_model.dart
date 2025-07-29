import 'dart:convert';

import '../../../utils/utils.dart';

UserConfigModel userConfigModelFromJson(String str) =>
    UserConfigModel.fromJson(json.decode(str));

String userConfigModelToJson(UserConfigModel data) =>
    json.encode(data.toJson());

class UserConfigModel {
  UserConfigModel({
    String? fifaStartDate,
    String? fifaEndDate,
    int? showTicket,
    String? fifaGroupStageDate,
    int? unreadNotification,
    List<String>? itineraryIds,
    bool? walletStatus,
    List<PrepaidCardDate>? prepaidCardDate,
    UserPreferencesConfig? userPreferences,
  }) {
    _fifaStartDate = fifaStartDate;
    _fifaEndDate = fifaEndDate;
    _showTicket = showTicket;
    _fifaGroupStageDate = fifaGroupStageDate;
    _unreadNotification = unreadNotification;
    _itineraryIds = itineraryIds;
    _walletStatus = walletStatus;
    _prepaidCardDate = prepaidCardDate;
    _userPreferences = userPreferences;
  }

  UserConfigModel.fromJson(dynamic json) {
    try {
      _fifaStartDate = json['fifa_start_date'];
      _fifaEndDate = json['fifa_end_date'];
      _showTicket = json['show_ticket'];
      _fifaGroupStageDate = json['fifa_group_stage_date'];
      _unreadNotification = json['unread_notification'];
      _itineraryIds = json['itinerary_ids'] != null
          ? json['itinerary_ids'].cast<String>()
          : [];
      _walletStatus = json['wallet_status'];
      _prepaidCardDate = json['prepaid_card_date'] != null
          ? List<PrepaidCardDate>.from(
              json['prepaid_card_date'].map((x) => PrepaidCardDate.fromJson(x)))
          : [];
      _userPreferences = json['user_preferences'] != null
          ? UserPreferencesConfig.fromJson(json['user_preferences'])
          : null;
    } catch (e) {
      Utils.logPrint('Error parsing UserConfigModel from JSON: $e');
      Utils.logPrint('JSON data: $json');

      // Set default values to prevent null pointer exceptions
      _fifaStartDate = '';
      _fifaEndDate = '';
      _showTicket = 0;
      _fifaGroupStageDate = '';
      _unreadNotification = 0;
      _itineraryIds = [];
      _walletStatus = false;
      _prepaidCardDate = [];
      _userPreferences = null;
    }
  }

  String? _fifaStartDate;
  String? _fifaEndDate;
  int? _showTicket;
  String? _fifaGroupStageDate;
  int? _unreadNotification;
  List<String>? _itineraryIds;
  bool? _walletStatus;
  List<PrepaidCardDate>? _prepaidCardDate;
  UserPreferencesConfig? _userPreferences;

  UserConfigModel copyWith({
    String? fifaStartDate,
    String? fifaEndDate,
    int? showTicket,
    String? fifaGroupStageDate,
    int? unreadNotification,
    List<String>? itineraryIds,
    bool? walletStatus,
    List<PrepaidCardDate>? prepaidCardDate,
    UserPreferencesConfig? userPreferences,
  }) =>
      UserConfigModel(
        fifaStartDate: fifaStartDate ?? _fifaStartDate,
        fifaEndDate: fifaEndDate ?? _fifaEndDate,
        showTicket: showTicket ?? _showTicket,
        fifaGroupStageDate: fifaGroupStageDate ?? _fifaGroupStageDate,
        unreadNotification: unreadNotification ?? _unreadNotification,
        itineraryIds: itineraryIds ?? _itineraryIds,
        walletStatus: walletStatus ?? _walletStatus,
        prepaidCardDate: prepaidCardDate ?? _prepaidCardDate,
        userPreferences: userPreferences ?? _userPreferences,
      );

  String get fifaStartDate => _fifaStartDate ?? '';

  String get fifaEndDate => _fifaEndDate ?? '';

  int get showTicket => _showTicket ?? 0;

  String get fifaGroupStageDate => _fifaGroupStageDate ?? '';

  int get unreadNotification => _unreadNotification ?? 0;

  List<String> get itineraryIds => _itineraryIds ?? [];

  bool get walletStatus => _walletStatus ?? false;

  List<PrepaidCardDate> get prepaidCardDate => _prepaidCardDate ?? [];

  UserPreferencesConfig? get userPreferences => _userPreferences;

  set fifaStartDate(String value) {
    _fifaStartDate = value;
  }

  set fifaEndDate(String value) {
    _fifaEndDate = value;
  }

  set showTicket(int value) {
    _showTicket = value;
  }

  set fifaGroupStageDate(String value) {
    _fifaGroupStageDate = value;
  }

  set unreadNotification(int value) {
    _unreadNotification = value;
  }

  set itineraryIds(List<String> value) {
    _itineraryIds = value;
  }

  set walletStatus(bool value) {
    _walletStatus = value;
  }

  set prepaidCardDate(List<PrepaidCardDate> value) {
    _prepaidCardDate = value;
  }

  set userPreferences(UserPreferencesConfig? value) {
    _userPreferences = value;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['fifa_start_date'] = _fifaStartDate;
    map['fifa_end_date'] = _fifaEndDate;
    map['show_ticket'] = _showTicket;
    map['fifa_group_stage_date'] = _fifaGroupStageDate;
    map['unread_notification'] = _unreadNotification;
    map['itinerary_ids'] = _itineraryIds ?? [];
    map['wallet_status'] = _walletStatus;
    map['prepaid_card_date'] =
        _prepaidCardDate?.map((x) => x.toJson()).toList() ?? [];
    if (_userPreferences != null) {
      map['user_preferences'] = _userPreferences?.toJson();
    }
    return map;
  }
}

class PrepaidCardDate {
  PrepaidCardDate({
    String? packageId,
    String? prepaidCardValidFromDate,
    String? prepaidCardExpiryDate,
  }) {
    _packageId = packageId;
    _prepaidCardValidFromDate = prepaidCardValidFromDate;
    _prepaidCardExpiryDate = prepaidCardExpiryDate;
  }

  PrepaidCardDate.fromJson(dynamic json) {
    _packageId = json['package_id'];
    _prepaidCardValidFromDate = json['prepaid_card_valid_from_date'];
    _prepaidCardExpiryDate = json['prepaid_card_expiry_date'];
  }

  String? _packageId;
  String? _prepaidCardValidFromDate;
  String? _prepaidCardExpiryDate;

  PrepaidCardDate copyWith({
    String? packageId,
    String? prepaidCardValidFromDate,
    String? prepaidCardExpiryDate,
  }) =>
      PrepaidCardDate(
        packageId: packageId ?? _packageId,
        prepaidCardValidFromDate:
            prepaidCardValidFromDate ?? _prepaidCardValidFromDate,
        prepaidCardExpiryDate: prepaidCardExpiryDate ?? _prepaidCardExpiryDate,
      );

  String get packageId => _packageId ?? '';

  String get prepaidCardValidFromDate => _prepaidCardValidFromDate ?? '';

  String get prepaidCardExpiryDate => _prepaidCardExpiryDate ?? '';

  set packageId(String value) {
    _packageId = value;
  }

  set prepaidCardValidFromDate(String value) {
    _prepaidCardValidFromDate = value;
  }

  set prepaidCardExpiryDate(String value) {
    _prepaidCardExpiryDate = value;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['package_id'] = _packageId;
    map['prepaid_card_valid_from_date'] = _prepaidCardValidFromDate;
    map['prepaid_card_expiry_date'] = _prepaidCardExpiryDate;
    return map;
  }
}

class UserPreferencesConfig {
  UserPreferencesConfig({
    String? favoriteTeam,
    Map<String, dynamic>? preferences,
    Personalization? personalization,
  }) {
    _favoriteTeam = favoriteTeam;
    _preferences = preferences;
    _personalization = personalization;
  }

  UserPreferencesConfig.fromJson(dynamic json) {
    _favoriteTeam = json['favorite_team'];
    _preferences = json['preferences'] != null
        ? Map<String, dynamic>.from(json['preferences'])
        : {};
    _personalization = json['personalization'] != null
        ? Personalization.fromJson(json['personalization'])
        : null;
  }

  String? _favoriteTeam;
  Map<String, dynamic>? _preferences;
  Personalization? _personalization;

  UserPreferencesConfig copyWith({
    String? favoriteTeam,
    Map<String, dynamic>? preferences,
    Personalization? personalization,
  }) =>
      UserPreferencesConfig(
        favoriteTeam: favoriteTeam ?? _favoriteTeam,
        preferences: preferences ?? _preferences,
        personalization: personalization ?? _personalization,
      );

  String? get favoriteTeam => _favoriteTeam;

  Map<String, dynamic>? get preferences => _preferences;

  Personalization? get personalization => _personalization;

  set favoriteTeam(String? value) {
    _favoriteTeam = value;
  }

  set preferences(Map<String, dynamic>? value) {
    _preferences = value;
  }

  set personalization(Personalization? value) {
    _personalization = value;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['favorite_team'] = _favoriteTeam;
    map['preferences'] = _preferences ?? {};
    if (_personalization != null) {
      map['personalization'] = _personalization?.toJson();
    }
    return map;
  }
}

class Personalization {
  Personalization({
    List<String>? evaIntroNode,
  }) {
    _evaIntroNode = evaIntroNode;
  }

  Personalization.fromJson(dynamic json) {
    _evaIntroNode = json['eva_intro_node'] != null
        ? json['eva_intro_node'].cast<String>()
        : [];
  }

  List<String>? _evaIntroNode;

  Personalization copyWith({
    List<String>? evaIntroNode,
  }) =>
      Personalization(
        evaIntroNode: evaIntroNode ?? _evaIntroNode,
      );

  List<String>? get evaIntroNode => _evaIntroNode;

  set evaIntroNode(List<String>? value) {
    _evaIntroNode = value;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['eva_intro_node'] = _evaIntroNode ?? [];
    return map;
  }
}
