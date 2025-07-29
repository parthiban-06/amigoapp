class PlaceResponse {
  List<String>? htmlAttributions;
  List<PlaceResult>? results;
  String? status;

  PlaceResponse({
    this.htmlAttributions,
    this.results,
    this.status,
  });

  factory PlaceResponse.fromJson(Map<String, dynamic> json) {
    return PlaceResponse(
      htmlAttributions:
          (json['html_attributions'] as List<dynamic>?)?.cast<String>() ?? [],
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => PlaceResult.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'html_attributions': htmlAttributions ?? [],
      'results': results?.map((e) => e.toJson()).toList() ?? [],
      'status': status,
    };
  }
}

class PlaceResult {
  String? formattedAddress;
  Geometry? geometry;
  String? icon;
  String? iconBackgroundColor;
  String? iconMaskBaseUri;
  String? name;
  List<PlacePhoto>? photos;
  String? placeId;
  String? reference;
  List<String>? types;

  PlaceResult({
    this.formattedAddress,
    this.geometry,
    this.icon,
    this.iconBackgroundColor,
    this.iconMaskBaseUri,
    this.name,
    this.photos,
    this.placeId,
    this.reference,
    this.types,
  });

  factory PlaceResult.fromJson(Map<String, dynamic> json) {
    return PlaceResult(
      formattedAddress: json['formatted_address'] as String?,
      geometry:
          json['geometry'] != null ? Geometry.fromJson(json['geometry']) : null,
      icon: json['icon'] as String?,
      iconBackgroundColor: json['icon_background_color'] as String?,
      iconMaskBaseUri: json['icon_mask_base_uri'] as String?,
      name: json['name'] as String?,
      photos: (json['photos'] as List<dynamic>?)
          ?.map((e) => PlacePhoto.fromJson(e as Map<String, dynamic>))
          .toList(),
      placeId: json['place_id'] as String?,
      reference: json['reference'] as String?,
      types: (json['types'] as List<dynamic>?)?.cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'formatted_address': formattedAddress,
      'geometry': geometry?.toJson(),
      'icon': icon,
      'icon_background_color': iconBackgroundColor,
      'icon_mask_base_uri': iconMaskBaseUri,
      'name': name,
      'photos': photos?.map((e) => e.toJson()).toList(),
      'place_id': placeId,
      'reference': reference,
      'types': types,
    };
  }
}

class Geometry {
  Location? location;
  Viewport? viewport;

  Geometry({
    this.location,
    this.viewport,
  });

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry(
      location:
          json['location'] != null ? Location.fromJson(json['location']) : null,
      viewport:
          json['viewport'] != null ? Viewport.fromJson(json['viewport']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': location?.toJson(),
      'viewport': viewport?.toJson(),
    };
  }
}

class Location {
  double? lat;
  double? lng;

  Location({this.lat, this.lng});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
    };
  }
}

class Viewport {
  Location? northeast;
  Location? southwest;

  Viewport({this.northeast, this.southwest});

  factory Viewport.fromJson(Map<String, dynamic> json) {
    return Viewport(
      northeast: json['northeast'] != null
          ? Location.fromJson(json['northeast'])
          : null,
      southwest: json['southwest'] != null
          ? Location.fromJson(json['southwest'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'northeast': northeast?.toJson(),
      'southwest': southwest?.toJson(),
    };
  }
}

class PlacePhoto {
  int? height;
  List<String>? htmlAttributions;
  String? photoReference;
  int? width;

  PlacePhoto({
    this.height,
    this.htmlAttributions,
    this.photoReference,
    this.width,
  });

  factory PlacePhoto.fromJson(Map<String, dynamic> json) {
    return PlacePhoto(
      height: json['height'] as int?,
      htmlAttributions:
          (json['html_attributions'] as List<dynamic>?)?.cast<String>(),
      photoReference: json['photo_reference'] as String?,
      width: json['width'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'height': height,
      'html_attributions': htmlAttributions,
      'photo_reference': photoReference,
      'width': width,
    };
  }
}
