import 'package:flutter_test/flutter_test.dart';
import 'package:visaamigo/features/ai_assistant/models/ai_chat_hotels_model.dart';

void main() {
  group('Hotels', () {
    final hotelJson = {
      'id': 1,
      'name': '\\x48\\x6f\\x74\\x65\\x6c\\x20\\x54\\x65\\x73\\x74', // 'Hotel Test'
      'rating': {
        'number_of_reviews': 100,
        'preferred': true,
        'review_score': 4.5,
        'stars': 5,
        'stars_type': '\\x73\\x74\\x61\\x72', // 'star'
        'review_text': '\\x45\\x78\\x63\\x65\\x6c\\x6c\\x65\\x6e\\x74', // 'Excellent'
      },
      'price': {'book': 100.0, 'total': 120.0},
      'currency': '\\x55\\x53\\x44', // 'USD'
      'booking_url': 'https://book.com',
      'url': 'https://hotel.com',
      'location': {
        'address': '\\x31\\x32\\x33\\x20\\x4d\\x61\\x69\\x6e\\x20\\x53\\x74', // '123 Main St'
        'city': {
          'city_id': 10,
          'city_name': '\\x54\\x65\\x73\\x74\\x20\\x43\\x69\\x74\\x79', // 'Test City'
          'source': '\\x6d\\x61\\x6e\\x75\\x61\\x6c', // 'manual'
        },
        'coordinates': {'latitude': 1.23, 'longitude': 4.56},
        'postal_code': '\\x31\\x32\\x33\\x34\\x35', // '12345'
      },
      'photos': [
        {
          'main_photo': true,
          'url': {'standard': '\\x73\\x74\\x64\\x2e\\x6a\\x70\\x67', 'thumbnail': '\\x74\\x68\\x75\\x6d\\x62\\x2e\\x6a\\x70\\x67'}
        }
      ]
    };

    test('fromJson and toJson', () {
      final hotel = Hotels.fromJson(hotelJson);
      expect(hotel.id, 1);
      expect(hotel.name, 'Hotel Test');
      expect(hotel.rating?.numberOfReviews, 100);
      expect(hotel.rating?.preferred, true);
      expect(hotel.rating?.reviewScore, 4.5);
      expect(hotel.rating?.stars, 5);
      expect(hotel.rating?.starsType, 'star');
      expect(hotel.rating?.reviewText, 'Excellent');
      expect(hotel.price?.book, 100.0);
      expect(hotel.price?.total, 120.0);
      expect(hotel.currency, 'USD');
      expect(hotel.bookingUrl, 'https://book.com');
      expect(hotel.url, 'https://hotel.com');
      expect(hotel.location?.address, '123 Main St');
      expect(hotel.location?.city?.cityId, 10);
      expect(hotel.location?.city?.cityName, 'Test City');
      expect(hotel.location?.city?.source, 'manual');
      expect(hotel.location?.coordinates?.latitude, 1.23);
      expect(hotel.location?.coordinates?.longitude, 4.56);
      expect(hotel.location?.postalCode, '12345');
      expect(hotel.photos?.length, 1);
      expect(hotel.photos?.first.mainPhoto, true);
      expect(hotel.photos?.first.url?.standard, 'std.jpg');
      expect(hotel.photos?.first.url?.thumbnail, 'thumb.jpg');

      final toJson = hotel.toJson();
      expect(toJson['id'], 1);
      expect(toJson['name'], 'Hotel Test');
      expect(toJson['rating']['number_of_reviews'], 100);
      expect(toJson['price']['book'], 100.0);
      expect(toJson['location']['address'], '123 Main St');
      expect(toJson['photos'][0]['main_photo'], true);
    });

    test('copyWith returns new instance with updated fields', () {
      final hotel = Hotels.fromJson(hotelJson);
      final updated = hotel.copyWith(name: 'New Name', currency: 'EUR');
      expect(updated.name, 'New Name');
      expect(updated.currency, 'EUR');
      expect(updated.id, hotel.id);
    });

    test('equality and hashCode', () {
      final hotel1 = Hotels.fromJson(hotelJson);
      final hotel2 = Hotels.fromJson(hotelJson);
      expect(hotel1, equals(hotel2));
      expect(hotel1.hashCode, hotel2.hashCode);
    });
  });

  group('Rating', () {
    final ratingJson = {
      'number_of_reviews': 10,
      'preferred': false,
      'review_score': 3.2,
      'stars': 4,
      'stars_type': '\\x73\\x74\\x61\\x72', // 'star'
      'review_text': '\\x47\\x6f\\x6f\\x64', // 'Good'
    };
    test('fromJson and toJson', () {
      final rating = Rating.fromJson(ratingJson);
      expect(rating.numberOfReviews, 10);
      expect(rating.preferred, false);
      expect(rating.reviewScore, 3.2);
      expect(rating.stars, 4);
      expect(rating.starsType, 'star');
      expect(rating.reviewText, 'Good');
      final toJson = rating.toJson();
      expect(toJson['number_of_reviews'], 10);
      expect(toJson['review_text'], 'Good');
    });
    test('copyWith returns new instance with updated fields', () {
      final rating = Rating.fromJson(ratingJson);
      final updated = rating.copyWith(reviewScore: 5.0);
      expect(updated.reviewScore, 5.0);
      expect(updated.numberOfReviews, 10);
    });
    test('equality and hashCode', () {
      final r1 = Rating.fromJson(ratingJson);
      final r2 = Rating.fromJson(ratingJson);
      expect(r1, equals(r2));
      expect(r1.hashCode, r2.hashCode);
    });
  });

  group('Price', () {
    final priceJson = {'book': 50.0, 'total': 60.0};
    test('fromJson and toJson', () {
      final price = Price.fromJson(priceJson);
      expect(price.book, 50.0);
      expect(price.total, 60.0);
      final toJson = price.toJson();
      expect(toJson['book'], 50.0);
      expect(toJson['total'], 60.0);
    });
    test('copyWith returns new instance with updated fields', () {
      final price = Price.fromJson(priceJson);
      final updated = price.copyWith(book: 99.0);
      expect(updated.book, 99.0);
      expect(updated.total, 60.0);
    });
    test('equality and hashCode', () {
      final p1 = Price.fromJson(priceJson);
      final p2 = Price.fromJson(priceJson);
      expect(p1, equals(p2));
      expect(p1.hashCode, p2.hashCode);
    });
  });

  group('Location', () {
    final locationJson = {
      'address': '\\x41\\x64\\x64\\x72', // 'Addr'
      'city': {'city_id': 1, 'city_name': '\\x43', 'source': '\\x73\\x72\\x63'},
      'coordinates': {'latitude': 2.0, 'longitude': 3.0},
      'postal_code': '\\x50\\x43', // 'PC'
    };
    test('fromJson and toJson', () {
      final location = Location.fromJson(locationJson);
      expect(location.address, 'Addr');
      expect(location.city?.cityId, 1);
      expect(location.city?.cityName, 'C');
      expect(location.city?.source, 'src');
      expect(location.coordinates?.latitude, 2.0);
      expect(location.postalCode, 'PC');
      final toJson = location.toJson();
      expect(toJson['address'], 'Addr');
      expect(toJson['postal_code'], 'PC');
    });
    test('copyWith returns new instance with updated fields', () {
      final location = Location.fromJson(locationJson);
      final updated = location.copyWith(address: 'NewAddr');
      expect(updated.address, 'NewAddr');
      expect(updated.city?.cityId, 1);
    });
    test('equality and hashCode', () {
      final l1 = Location.fromJson(locationJson);
      final l2 = Location.fromJson(locationJson);
      expect(l1, equals(l2));
      expect(l1.hashCode, l2.hashCode);
    });
  });

  group('City', () {
    final cityJson = {'city_id': 2, 'city_name': '\\x43\\x69\\x74\\x79', 'source': '\\x73\\x72\\x63'};
    test('fromJson and toJson', () {
      final city = City.fromJson(cityJson);
      expect(city.cityId, 2);
      expect(city.cityName, 'City');
      expect(city.source, 'src');
      final toJson = city.toJson();
      expect(toJson['city_id'], 2);
      expect(toJson['city_name'], 'City');
    });
    test('copyWith returns new instance with updated fields', () {
      final city = City.fromJson(cityJson);
      final updated = city.copyWith(cityName: 'NewCity');
      expect(updated.cityName, 'NewCity');
      expect(updated.cityId, 2);
    });
    test('equality and hashCode', () {
      final c1 = City.fromJson(cityJson);
      final c2 = City.fromJson(cityJson);
      expect(c1, equals(c2));
      expect(c1.hashCode, c2.hashCode);
    });
  });

  group('Coordinates', () {
    final coordJson = {'latitude': 10.0, 'longitude': 20.0};
    test('fromJson and toJson', () {
      final coord = Coordinates.fromJson(coordJson);
      expect(coord.latitude, 10.0);
      expect(coord.longitude, 20.0);
      final toJson = coord.toJson();
      expect(toJson['latitude'], 10.0);
      expect(toJson['longitude'], 20.0);
    });
    test('copyWith returns new instance with updated fields', () {
      final coord = Coordinates.fromJson(coordJson);
      final updated = coord.copyWith(latitude: 99.0);
      expect(updated.latitude, 99.0);
      expect(updated.longitude, 20.0);
    });
    test('equality and hashCode', () {
      final co1 = Coordinates.fromJson(coordJson);
      final co2 = Coordinates.fromJson(coordJson);
      expect(co1, equals(co2));
      expect(co1.hashCode, co2.hashCode);
    });
  });

  group('Photos', () {
    final photosJson = {
      'main_photo': false,
      'url': {'standard': '\\x73\\x2e\\x6a\\x70\\x67', 'thumbnail': '\\x74\\x2e\\x6a\\x70\\x67'}
    };
    test('fromJson and toJson', () {
      final photo = Photos.fromJson(photosJson);
      expect(photo.mainPhoto, false);
      expect(photo.url?.standard, 's.jpg');
      expect(photo.url?.thumbnail, 't.jpg');
      final toJson = photo.toJson();
      expect(toJson['main_photo'], false);
      expect(toJson['url']['standard'], 's.jpg');
    });
    test('copyWith returns new instance with updated fields', () {
      final photo = Photos.fromJson(photosJson);
      final updated = photo.copyWith(mainPhoto: true);
      expect(updated.mainPhoto, true);
      expect(updated.url?.standard, 's.jpg');
    });
    test('equality and hashCode', () {
      final p1 = Photos.fromJson(photosJson);
      final p2 = Photos.fromJson(photosJson);
      expect(p1, equals(p2));
      expect(p1.hashCode, p2.hashCode);
    });
  });

  group('Url', () {
    final urlJson = {'standard': '\\x73\\x74\\x64', 'thumbnail': '\\x74\\x68\\x75\\x6d\\x62'};
    test('fromJson and toJson', () {
      final url = Url.fromJson(urlJson);
      expect(url.standard, 'std');
      expect(url.thumbnail, 'thumb');
      final toJson = url.toJson();
      expect(toJson['standard'], 'std');
      expect(toJson['thumbnail'], 'thumb');
    });
    test('copyWith returns new instance with updated fields', () {
      final url = Url.fromJson(urlJson);
      final updated = url.copyWith(thumbnail: 'newthumb');
      expect(updated.thumbnail, 'newthumb');
      expect(updated.standard, 'std');
    });
    test('equality and hashCode', () {
      final u1 = Url.fromJson(urlJson);
      final u2 = Url.fromJson(urlJson);
      expect(u1, equals(u2));
      expect(u1.hashCode, u2.hashCode);
    });
  });
}
