class UserVisitModel {
  final int? statusCode;
  final String? messageKey;
  final Data? data;

  UserVisitModel({
    this.statusCode,
    this.messageKey,
    this.data,
  });

  factory UserVisitModel.fromJson(Map<String, dynamic> json) {
    return UserVisitModel(
      statusCode: json['status_code'] as int?,
      messageKey: json['message_key'] as String?,
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'status_code': statusCode,
        'message_key': messageKey,
        'data': data?.toJson(),
      };
}

class Data {
  final List<String>? userVisit;
  final List<String>? rateUs;
  final List<String>? location;
  final List<String>? tripGoal;
  final List<String>? teamName;
  final List<String>? gettingToKnow;
  final List<String>? tutorialMobile;
  final List<String>? tutorialWeb;

  Data({
    this.userVisit,
    this.rateUs,
    this.location,
    this.tripGoal,
    this.teamName,
    this.gettingToKnow,
    this.tutorialMobile,
    this.tutorialWeb,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      userVisit: (json['user_visit'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      rateUs:
          (json['rate_us'] as List<dynamic>?)?.map((e) => e as String).toList(),
      location: (json['location'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      tripGoal: (json['trip_goal'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      teamName: (json['team_name'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      gettingToKnow: (json['getting_to_know'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      tutorialMobile: (json['tutorial_mobile'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      tutorialWeb: (json['tutorial_web'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'user_visit': userVisit,
        'rate_us': rateUs,
        'location': location,
        'trip_goal': tripGoal,
        'team_name': teamName,
        'getting_to_know': gettingToKnow,
        'tutorial_mobile': tutorialMobile,
        'tutorial_web': tutorialWeb,
      };
}
