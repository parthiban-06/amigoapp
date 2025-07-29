import '../../../utils/utils.dart';

class Hotels {
  final num? id;
  final String? name;
  final Rating? rating;
  final Price? price;
  final String? currency;
  final String? bookingUrl;
  final String? url;
  final Location? location;
  final List<Photos>? photos;

  Hotels({
    this.id,
    this.name,
    this.rating,
    this.price,
    this.currency,
    this.bookingUrl,
    this.url,
    this.location,
    this.photos,
  });

  Hotels copyWith({
    num? id,
    String? name,
    Rating? rating,
    Price? price,
    String? currency,
    String? bookingUrl,
    String? url,
    Location? location,
    List<Photos>? photos,
  }) {
    return Hotels(
      id: id ?? this.id,
      name: name ?? this.name,
      rating: rating ?? this.rating,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      bookingUrl: bookingUrl ?? this.bookingUrl,
      url: url ?? this.url,
      location: location ?? this.location,
      photos: photos ?? this.photos,
    );
  }

  Hotels.fromJson(Map<String, dynamic> json)
      : id = json['id'] as num?,
        name = Utils.convrtStringUtf(json['name']) as String?,
        rating = (json['rating'] as Map<String, dynamic>?) != null
            ? Rating.fromJson(json['rating'] as Map<String, dynamic>)
            : null,
        price = (json['price'] as Map<String, dynamic>?) != null
            ? Price.fromJson(json['price'] as Map<String, dynamic>)
            : null,
        currency = Utils.convrtStringUtf(json['currency']) as String?,
        bookingUrl = Utils.convrtStringUtf(json['booking_url']) as String?,
        url = Utils.convrtStringUtf(json['url']) as String?,
        location = (json['location'] as Map<String, dynamic>?) != null
            ? Location.fromJson(json['location'] as Map<String, dynamic>)
            : null,
        photos = (json['photos'] as List?)
            ?.map((dynamic e) => Photos.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'rating': rating?.toJson(),
        'price': price?.toJson(),
        'currency': currency,
        'booking_url': bookingUrl,
        'url': url,
        'location': location?.toJson(),
        'photos': photos?.map((e) => e.toJson()).toList()
      };
}

class Rating {
  final num? numberOfReviews;
  final bool? preferred;
  final num? reviewScore;
  final num? stars;
  final String? starsType;
  final String? reviewText;

  Rating({
    this.numberOfReviews,
    this.preferred,
    this.reviewScore,
    this.stars,
    this.starsType,
    this.reviewText,
  });

  Rating copyWith({
    num? numberOfReviews,
    bool? preferred,
    double? reviewScore,
    num? stars,
    String? starsType,
    String? reviewText,
  }) {
    return Rating(
      numberOfReviews: numberOfReviews ?? this.numberOfReviews,
      preferred: preferred ?? this.preferred,
      reviewScore: reviewScore ?? this.reviewScore,
      stars: stars ?? this.stars,
      starsType: starsType ?? this.starsType,
      reviewText: reviewText ?? this.reviewText,
    );
  }

  Rating.fromJson(Map<String, dynamic> json)
      : numberOfReviews = json['number_of_reviews'] as num?,
        preferred = json['preferred'] as bool?,
        reviewScore = json['review_score'] as num?,
        stars = json['stars'] as num?,
        starsType = Utils.convrtStringUtf(json['stars_type']) as String?,
        reviewText = Utils.convrtStringUtf(json['review_text']) as String?;

  Map<String, dynamic> toJson() => {
        'number_of_reviews': numberOfReviews,
        'preferred': preferred,
        'review_score': reviewScore,
        'stars': stars,
        'stars_type': starsType,
        'review_text': reviewText
      };
}

class Price {
  final double? book;
  final double? total;

  Price({
    this.book,
    this.total,
  });

  Price copyWith({
    double? book,
    double? total,
  }) {
    return Price(
      book: book ?? this.book,
      total: total ?? this.total,
    );
  }

  Price.fromJson(Map<String, dynamic> json)
      : book = json['book'] as double?,
        total = json['total'] as double?;

  Map<String, dynamic> toJson() => {'book': book, 'total': total};
}

class Location {
  final String? address;
  final City? city;
  final Coordinates? coordinates;
  final String? postalCode;

  Location({
    this.address,
    this.city,
    this.coordinates,
    this.postalCode,
  });

  Location copyWith({
    String? address,
    City? city,
    Coordinates? coordinates,
    String? postalCode,
  }) {
    return Location(
      address: address ?? this.address,
      city: city ?? this.city,
      coordinates: coordinates ?? this.coordinates,
      postalCode: postalCode ?? this.postalCode,
    );
  }

  Location.fromJson(Map<String, dynamic> json)
      : address = Utils.convrtStringUtf(json['address']) as String?,
        city = (json['city'] as Map<String, dynamic>?) != null
            ? City.fromJson(json['city'] as Map<String, dynamic>)
            : null,
        coordinates = (json['coordinates'] as Map<String, dynamic>?) != null
            ? Coordinates.fromJson(json['coordinates'] as Map<String, dynamic>)
            : null,
        postalCode = Utils.convrtStringUtf(json['postal_code']) as String?;

  Map<String, dynamic> toJson() => {
        'address': address,
        'city': city?.toJson(),
        'coordinates': coordinates?.toJson(),
        'postal_code': postalCode
      };
}

class City {
  final int? cityId;
  final String? cityName;
  final String? source;

  City({
    this.cityId,
    this.cityName,
    this.source,
  });

  City copyWith({
    int? cityId,
    String? cityName,
    String? source,
  }) {
    return City(
      cityId: cityId ?? this.cityId,
      cityName: cityName ?? this.cityName,
      source: source ?? this.source,
    );
  }

  City.fromJson(Map<String, dynamic> json)
      : cityId = json['city_id'] as int?,
        cityName = Utils.convrtStringUtf(json['city_name']) as String?,
        source = Utils.convrtStringUtf(json['source']) as String?;

  Map<String, dynamic> toJson() =>
      {'city_id': cityId, 'city_name': cityName, 'source': source};
}

class Coordinates {
  final double? latitude;
  final double? longitude;

  Coordinates({
    this.latitude,
    this.longitude,
  });

  Coordinates copyWith({
    double? latitude,
    double? longitude,
  }) {
    return Coordinates(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  Coordinates.fromJson(Map<String, dynamic> json)
      : latitude = json['latitude'] as double?,
        longitude = json['longitude'] as double?;

  Map<String, dynamic> toJson() =>
      {'latitude': latitude, 'longitude': longitude};
}

class Photos {
  final bool? mainPhoto;
  final Url? url;

  Photos({
    this.mainPhoto,
    this.url,
  });

  Photos copyWith({
    bool? mainPhoto,
    Url? url,
  }) {
    return Photos(
      mainPhoto: mainPhoto ?? this.mainPhoto,
      url: url ?? this.url,
    );
  }

  Photos.fromJson(Map<String, dynamic> json)
      : mainPhoto = json['main_photo'] as bool?,
        url = (json['url'] as Map<String, dynamic>?) != null
            ? Url.fromJson(json['url'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() =>
      {'main_photo': mainPhoto, 'url': url?.toJson()};
}

class Url {
  final String? standard;
  final String? thumbnail;

  Url({
    this.standard,
    this.thumbnail,
  });

  Url copyWith({
    String? standard,
    String? thumbnail,
  }) {
    return Url(
      standard: standard ?? this.standard,
      thumbnail: thumbnail ?? this.thumbnail,
    );
  }

  Url.fromJson(Map<String, dynamic> json)
      : standard = Utils.convrtStringUtf(json['standard']) as String?,
        thumbnail = Utils.convrtStringUtf(json['thumbnail']) as String?;

  Map<String, dynamic> toJson() =>
      {'standard': standard, 'thumbnail': thumbnail};
}
