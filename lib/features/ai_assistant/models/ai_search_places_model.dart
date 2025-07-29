import '../../../utils/utils.dart';

class Place {
  final String id;
  final String internationalPhoneNumber;
  final String formattedAddress;
  final double rating;
  final String googleMapsUri;
  final String displayName;
  final Location? location;
  final String? shortFormattedAddress;
  final List<String>? photos;
  final EditorialSummary? editorialSummary;
  final bool isExpand;
  final String primaryType;
  final bool openNow;
  final String timings;

  Place({
    required this.id,
    required this.internationalPhoneNumber,
    required this.formattedAddress,
    required this.rating,
    required this.googleMapsUri,
    required this.displayName,
    required this.location,
    required this.shortFormattedAddress,
    required this.photos,
    required this.editorialSummary,
    required this.isExpand,
    required this.primaryType,
    required this.openNow,
    required this.timings,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: Utils.convrtStringUtf(json["id"] ?? ""),
      internationalPhoneNumber:
          Utils.convrtStringUtf(json["internationalPhoneNumber"] ?? ""),
      formattedAddress: Utils.convrtStringUtf(json["formattedAddress"] ?? ""),
      rating: (json["rating"] ?? 0).toDouble(),
      googleMapsUri: Utils.convrtStringUtf(json["googleMapsUri"] ?? ""),
      displayName: Utils.convrtStringUtf(json["displayName"] ?? ""),
      location: (json['location'] as Map<String, dynamic>?) != null
          ? Location.fromJson(json['location'] as Map<String, dynamic>)
          : null,
      shortFormattedAddress:
          Utils.convrtStringUtf(json['shortFormattedAddress'] ?? ""),
      photos:
          (json['photos'] as List?)?.map((dynamic e) => e as String).toList(),
      editorialSummary:
          (json['editorialSummary'] as Map<String, dynamic>?) != null
              ? EditorialSummary.fromJson(
                  json['editorialSummary'] as Map<String, dynamic>)
              : null,
      primaryType: json["primaryType"] != null
          ? Utils.convrtStringUtf(json["primaryType"] ?? "")
          : "",
      openNow: json["openNow"] != null ? json["openNow"] as bool : false,
      timings: json["timings"] != null
          ? Utils.convrtStringUtf(json["timings"] ?? "")
          : "",
      isExpand: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "internationalPhoneNumber": internationalPhoneNumber,
      "formattedAddress": formattedAddress,
      "rating": rating,
      "googleMapsUri": googleMapsUri,
      "displayName": displayName,
      "shortFormattedAddress": shortFormattedAddress,
      "photos": photos,
      "editorialSummary": editorialSummary,
      "location": location,
      "isExpand": isExpand,
      "primaryType": primaryType,
      "openNow": openNow,
      "timings": timings,
    };
  }

  Place copyWith({
    String? id,
    String? internationalPhoneNumber,
    String? formattedAddress,
    double? rating,
    String? googleMapsUri,
    String? displayName,
    Location? location,
    String? shortFormattedAddress,
    List<String>? photos,
    EditorialSummary? editorialSummary,
    bool? isExpand,
    String? primaryType,
    bool? openNow,
    String? timings,
  }) {
    return Place(
      id: id ?? this.id,
      internationalPhoneNumber:
          internationalPhoneNumber ?? this.internationalPhoneNumber,
      formattedAddress: formattedAddress ?? this.formattedAddress,
      rating: rating ?? this.rating,
      googleMapsUri: googleMapsUri ?? this.googleMapsUri,
      displayName: displayName ?? this.displayName,
      location: location ?? this.location,
      shortFormattedAddress:
          shortFormattedAddress ?? this.shortFormattedAddress,
      photos: photos ?? this.photos,
      editorialSummary: editorialSummary ?? this.editorialSummary,
      isExpand: isExpand ?? this.isExpand,
      primaryType: primaryType ?? this.primaryType,
      openNow: openNow ?? this.openNow,
      timings: timings ?? this.timings,
    );
  }

  @override
  String toString() {
    return "ID: $id, Phone: $internationalPhoneNumber, Address: $formattedAddress, Rating: $rating, Google Maps: $googleMapsUri, Display Name: $displayName";
  }
}

class Location {
  final double? latitude;
  final double? longitude;

  Location({
    this.latitude,
    this.longitude,
  });

  Location.fromJson(Map<String, dynamic> json)
      : latitude = json['latitude'] as double?,
        longitude = json['longitude'] as double?;

  Map<String, dynamic> toJson() =>
      {'latitude': latitude, 'longitude': longitude};
}

class EditorialSummary {
  final String? text;
  final String? languageCode;

  EditorialSummary({
    this.text,
    this.languageCode,
  });

  EditorialSummary.fromJson(Map<String, dynamic> json)
      : text = Utils.convrtStringUtf(json['text'] ?? ""),
        languageCode = Utils.convrtStringUtf(json['languageCode'] ?? "");

  Map<String, dynamic> toJson() => {'text': text, 'languageCode': languageCode};
}
