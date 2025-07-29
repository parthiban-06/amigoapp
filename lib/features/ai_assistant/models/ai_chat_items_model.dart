import '../../../utils/utils.dart';
import 'ai_chat_hotels_model.dart';
import 'ai_search_places_model.dart';
import 'ai_weather_forecast_model.dart';

class AiChatItems {
  final String location;
  final List<WeatherForecast> forecast;
  final List<Place> places;
  final List<Hotels> hotels;
  final String checkin;
  final String checkout;
  final Guests guests;
  final String flightUrl;
  final String googleMapUrl;
  final String appUrls;
  final String response;

  AiChatItems({
    required this.location,
    required this.forecast,
    required this.places,
    required this.hotels,
    required this.checkin,
    required this.checkout,
    required this.guests,
    required this.flightUrl,
    required this.googleMapUrl,
    required this.appUrls,
    required this.response,
  });

  factory AiChatItems.fromJson(Map<String, dynamic> json) {
    return AiChatItems(
        location: Utils.convrtStringUtf(json["location"] ?? ""),
        forecast: (json["forecast"] as List<dynamic>?)
                ?.map((item) => WeatherForecast.fromJson(item))
                .toList() ??
            [],
        places: (json["places"] as List<dynamic>?)
                ?.map((item) => Place.fromJson(item))
                .toList() ??
            [],
        hotels: (json["hotels"] as List<dynamic>?)
                ?.map((item) => Hotels.fromJson(item))
                .toList() ??
            [],
        checkin: Utils.convrtStringUtf(json['checkin'] ?? ''),
        checkout: Utils.convrtStringUtf(json['checkout'] ?? ''),
        guests: Guests.fromJson(json['guests'] ?? {}),
        flightUrl: Utils.convrtStringUtf(json['url'] ?? ''),
        googleMapUrl: Utils.convrtStringUtf(json['google_map_url'] ?? ''),
        response: Utils.convrtStringUtf(json['response'] ?? ''),
        appUrls: Utils.convrtStringUtf(json['app_urls'] ?? ''));
  }

  Map<String, dynamic> toJson() {
    return {
      "location": location,
      "forecast": forecast.map((item) => item.toJson()).toList(),
      "places": places.map((item) => item.toJson()).toList(),
      "hotels": hotels.map((item) => item.toJson()).toList(),
      'checkin': checkin,
      'checkout': checkout,
      'guests': guests.toJson(),
      'url': flightUrl,
      'google_map_url': googleMapUrl,
      'response': response,
      'app_urls': appUrls,
    };
  }

  factory AiChatItems.empty() {
    return AiChatItems(
      location: "",
      forecast: [],
      places: [],
      hotels: [],
      checkin: '',
      checkout: '',
      flightUrl: '',
      googleMapUrl: '',
      guests: Guests.empty(),
      response: '',
      appUrls: '',
    );
  }

  AiChatItems copyWith({
    String? location,
    List<WeatherForecast>? forecast,
    List<Place>? places,
    List<Hotels>? hotels,
    String? checkin,
    String? checkout,
    Guests? guests,
    String? flightUrl,
    String? googleMapUrl,
    String? response,
    String? appUrls,
  }) {
    return AiChatItems(
      location: location ?? this.location,
      forecast: forecast ?? this.forecast,
      places: places ?? this.places,
      hotels: hotels ?? this.hotels,
      checkin: checkin ?? this.checkin,
      checkout: checkout ?? this.checkout,
      guests: guests ?? this.guests,
      flightUrl: flightUrl ?? this.flightUrl,
      googleMapUrl: googleMapUrl ?? this.googleMapUrl,
      response: response ?? this.response,
      appUrls: appUrls ?? this.appUrls,
    );
  }

  @override
  String toString() {
    return "$location, $forecast, $places, $hotels, $flightUrl, $googleMapUrl, $response, $appUrls";
  }
}

class Guests {
  final int numberOfAdults;
  final int numberOfRooms;

  Guests({required this.numberOfAdults, required this.numberOfRooms});

  factory Guests.fromJson(Map<String, dynamic> json) {
    return Guests(
      numberOfAdults: json['number_of_adults'] ?? 0,
      numberOfRooms: json['number_of_rooms'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number_of_adults': numberOfAdults,
      'number_of_rooms': numberOfRooms,
    };
  }

  Guests copyWith({int? numberOfAdults, int? numberOfRooms}) {
    return Guests(
      numberOfAdults: numberOfAdults ?? this.numberOfAdults,
      numberOfRooms: numberOfRooms ?? this.numberOfRooms,
    );
  }

  factory Guests.empty() => Guests(numberOfAdults: 0, numberOfRooms: 0);
}
