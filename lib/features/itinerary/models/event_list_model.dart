// To parse this JSON data, do
//
//     final eventList = eventListFromJson(jsonString);

import 'dart:convert';

import 'package:visaamigo/utils/utils.dart';

EventList eventListFromJson(String str) => EventList.fromJson(json.decode(str));

String eventListToJson(EventList data) => json.encode(data.toJson());

class EventList {
  double? lat;
  double? lan;
  String? matchCity;
  String? matchStadium;
  String? maxNoOfCompanions;
  String? matchCountry;
  String startTime;
  String timezone;
  String? matchState;
  String title;
  List<String>? ticketIds;
  String? eventName;
  String? matchTeams;
  List<dynamic>? companionsAssigned;
  String id;
  bool? ticketExpired;
  String type;
  String address;
  String? createdAt;
  String? description;
  String? eventRawOffset;
  String? eventCategory;
  String? updatedAt;
  String? eventType;
  String? userId;
  dynamic eventDstOffset;
  String? endTime;
  String? eventTimeZoneId;
  String? eventDate;

  EventList({
    this.lat,
    this.lan,
    this.matchCity,
    this.matchStadium,
    this.maxNoOfCompanions,
    this.matchCountry,
    required this.startTime,
    required this.timezone,
    this.matchState,
    required this.title,
    this.ticketIds,
    this.eventName,
    this.matchTeams,
    this.companionsAssigned,
    required this.id,
    this.ticketExpired,
    required this.type,
    required this.address,
    this.createdAt,
    this.description,
    this.eventRawOffset,
    this.eventCategory,
    this.updatedAt,
    this.eventType,
    this.userId,
    this.eventDstOffset,
    this.endTime,
    this.eventTimeZoneId,
    this.eventDate,
  });

  factory EventList.fromJson(Map<String, dynamic> json) {
    String decodeIfHex(String? value) {
      if (value == null) return '';
      // Check if the string matches hex pattern: only \xNN sequences
      final hexPattern = RegExp(r'^(\\x[0-9a-fA-F]{2})+?$');
      if (hexPattern.hasMatch(value)) {
        return Utils.convrtStringUtf(value);
      } else {
        return value;
      }
    }

    return EventList(
      lat: json['lat'] != null ? (json['lat'] as num).toDouble() : null,
      lan: json['lan'] != null ? (json['lan'] as num).toDouble() : null,
      matchCity: json['match_city'],
      matchStadium: json['match_stadium'],
      maxNoOfCompanions: json['max_no_of_companions'],
      matchCountry: json['match_country'],
      startTime: json['start_time'] ?? '',
      timezone: json['timezone'] ?? '',
      matchState: json['match_state'],
      title: decodeIfHex(json['title'] ?? ''),
      ticketIds:
          (json['ticket_ids'] as List?)?.map((e) => e.toString()).toList(),
      eventName: json['event_name'],
      matchTeams: json['match_teams'],
      companionsAssigned: json['companions_assigned'],
      id: json['id'] ?? '',
      ticketExpired: json['ticket_expired'],
      type: json['type'] ?? '',
      address: decodeIfHex(json['address'] ?? ''),
      createdAt: json['created_at'],
      description: decodeIfHex(json['description'] ?? ''),
      eventRawOffset: json['event_raw_offset'],
      eventCategory: json['event_category'],
      updatedAt: json['updated_at'],
      eventType: json['event_type'],
      userId: json['user_id'],
      eventDstOffset: json['event_dst_offset'],
      endTime: json['end_time'],
      eventTimeZoneId: json['event_time_zone_id'],
      eventDate: json['event_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lan': lan,
      'match_city': matchCity,
      'match_stadium': matchStadium,
      'max_no_of_companions': maxNoOfCompanions,
      'match_country': matchCountry,
      'start_time': startTime,
      'timezone': timezone,
      'match_state': matchState,
      'title': title,
      'ticket_ids': ticketIds,
      'event_name': eventName,
      'match_teams': matchTeams,
      'companions_assigned': companionsAssigned,
      'id': id,
      'ticket_expired': ticketExpired,
      'type': type,
      'address': address,
      'created_at': createdAt,
      'description': description,
      'event_raw_offset': eventRawOffset,
      'event_category': eventCategory,
      'updated_at': updatedAt,
      'event_type': eventType,
      'user_id': userId,
      'event_dst_offset': eventDstOffset,
      'end_time': endTime,
      'event_time_zone_id': eventTimeZoneId,
      'event_date': eventDate,
    };
  }

  static List<EventList> fromDataJson(Map<String, dynamic> json) {
    if (json['data'] == null) return [];
    return (json['data'] as List).map((e) => EventList.fromJson(e)).toList();
  }
}
