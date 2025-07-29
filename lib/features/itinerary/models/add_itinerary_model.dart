import 'package:visaamigo/utils/utils.dart';

import 'event_list_model.dart';

class EventModel {
  String? eventTitle;
  String? eventDescription;
  String? eventDate;
  String? eventLocation;
  String? eventStartTime;
  String? eventEndTime;
  String? eventType;
  String? eventCategory;
  String? eventId;
  String? eventTimeZoneId;
  String? eventTimeZone;
  int? eventDstOffset;
  int? eventRawOffset;
  double? eventLatitude;
  double? eventLongitude;

  EventModel({
    this.eventTitle = '',
    this.eventId,
    this.eventDescription = '',
    this.eventDate = '',
    this.eventLocation = '',
    this.eventStartTime = '',
    this.eventEndTime = '',
    this.eventType = '',
    this.eventCategory = '',
    this.eventTimeZoneId = '',
    this.eventTimeZone = '',
    this.eventDstOffset,
    this.eventRawOffset,
    this.eventLatitude,
    this.eventLongitude,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      eventTitle: Utils.convrtStringUtf(json['event_title'] ?? ''),
      eventId: json['id'] ?? '',
      eventDescription: Utils.convrtStringUtf(json['event_description'] ?? ''),
      eventDate: json['event_date'] ?? '',
      eventLocation: json['event_location'] ?? '',
      eventStartTime: json['event_start_time'] ?? '',
      eventEndTime: json['event_end_time'] ?? '',
      eventType: json['event_type'] ?? '',
      eventCategory: json['event_category'] ?? '',
      eventTimeZoneId: json['event_time_zone_id'] ?? '',
      eventTimeZone: json['event_time_zone'] ?? '',
      eventDstOffset: json['event_dst_offset'],
      eventRawOffset: json['event_raw_offset'],
      eventLatitude: json['event_latitude']?.toDouble(),
      eventLongitude: json['event_longitude']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> toJson = {
      'event_title': eventTitle ?? '',
      // 'id': eventId ?? '',
      'event_description': eventDescription ?? '',
      'event_date': eventDate ?? '',
      'event_location': eventLocation ?? '',
      'event_start_time': eventStartTime ?? '',
      'event_end_time': eventEndTime ?? '',
      'event_category': eventCategory ?? '',
      // 'event_time_zone_id': eventTimeZoneId,
      // 'event_time_zone': eventTimeZone,
      // 'event_dst_offset': eventDstOffset,
      // 'event_raw_offset': eventRawOffset,
      'event_latitude': eventLatitude,
      'event_longitude': eventLongitude,
    };

    if (eventId != null && eventId!.isNotEmpty) {
      toJson["id"] = eventId!;
    }

    if (eventType != null && eventType!.isNotEmpty) {
      toJson["event_type"] = eventType!;
    }

    if (eventTimeZoneId != null && eventTimeZoneId!.isNotEmpty) {
      toJson["event_time_zone_id"] = eventTimeZoneId!;
    }

    if (eventTimeZone != null && eventTimeZone!.isNotEmpty) {
      toJson["event_time_zone"] = eventTimeZone!;
    }

    if (eventDstOffset != null) {
      toJson["event_dst_offset"] = eventDstOffset!;
    }

    if (eventRawOffset != null) {
      toJson["event_raw_offset"] = eventRawOffset!;
    }

    return toJson;
  }

  static List<EventModel> fromDataJson(Map<String, dynamic> json) {
    if (json['data'] == null) return [];
    return (json['data'] as List).map((e) => EventModel.fromJson(e)).toList();
  }
}

extension EventListMapper on EventList {
  EventModel toEventModel() {
    return EventModel(
      eventId: id,
      eventTitle: title,
      eventDescription: description,
      eventStartTime: startTime,
      eventEndTime: endTime,
      eventDate: eventDate,
      eventLocation: address,
      eventLatitude: lat,
      eventLongitude: lan,
      eventType: eventType,
      // eventLocation: locationName,
    );
  }
}
