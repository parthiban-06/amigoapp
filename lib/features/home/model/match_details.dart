class MatchResponse {
  final int statusCode;
  final String messageKey;
  final List<MatchData> data;

  MatchResponse({
    required this.statusCode,
    required this.messageKey,
    required this.data,
  });

  factory MatchResponse.fromJson(Map<String, dynamic> json) {
    return MatchResponse(
      statusCode: json['status_code'],
      messageKey: json['message_key'],
      data: (json['data'] as List)
          .map((item) => MatchData.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status_code': statusCode,
      'message_key': messageKey,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class MatchData {
  final String id;
  final String matchCity;
  final String matchState;
  final String matchCountry;
  final String matchStadium;
  final String eventName;
  final DateTime matchTime;
  final DateTime? matchEndTime;
  final String matchTimezone;
  final String matchTeams;
  final String matchName;
  final double matchLatitude;
  final double matchLongitude;
  final bool isTicketExpired;
  final int maxNoOfCompanions;
  final List<String> tickets; // ✅ New field added
  final List<String> companionsAssigned; // ✅ New field added

  MatchData({
    required this.id,
    required this.matchCity,
    required this.matchState,
    required this.matchCountry,
    required this.matchStadium,
    required this.eventName,
    required this.matchTime,
    required this.matchTimezone,
    required this.matchEndTime,
    required this.matchTeams,
    required this.matchName,
    required this.matchLatitude,
    required this.matchLongitude,
    required this.isTicketExpired,
    required this.maxNoOfCompanions,
    required this.companionsAssigned,
    required this.tickets, // ✅ required constructor
  });

  factory MatchData.fromJson(Map<String, dynamic> json) {
    return MatchData(
      id: json['id'],
      matchCity: json['match_city'] ?? "",
      matchState: json['match_state'] ?? "",
      matchCountry: json['match_country'] ?? "",
      matchStadium: json['match_stadium'] ?? "",
      eventName: json['event_name'] ?? "",
      matchTime: DateTime.parse(json['match_time']),
      matchEndTime: json['match_end_time'] != null
          ? DateTime.parse(json['match_end_time'])
          : null,
      matchTimezone: json['match_timezone'],
      matchTeams: json['match_teams'] ?? "",
      matchName: json['match_name'] ?? "",
      matchLatitude: json['match_latitude'],
      matchLongitude: json['match_longitude'],
      isTicketExpired: json['ticket_expired'] ?? false,
      tickets: json['ticket_ids'] != null
          ? List<String>.from(json['ticket_ids'])
          : [],
      maxNoOfCompanions: json['max_no_of_companions'] ?? 0,
      companionsAssigned: json['companions_assigned'] != null
          ? List<String>.from(json['companions_assigned'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'match_city': matchCity,
      'match_stadium': matchStadium,
      'event_name': eventName,
      'match_time': matchTime.toIso8601String(),
      'match_end_time': matchEndTime?.toIso8601String() ?? "",
      'match_timezone': matchTimezone,
      'match_teams': matchTeams,
      'match_name': matchName,
      'match_latitude': matchLatitude,
      'match_longitude': matchLongitude,
      'ticket_ids': tickets,
      'match_state': matchState,
      'match_country': matchCountry,
      'companions_assigned': companionsAssigned,
      'max_no_of_companions': maxNoOfCompanions,
      'ticket_expired': isTicketExpired,
    };
  }
}
