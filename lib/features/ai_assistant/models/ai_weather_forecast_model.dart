import '../../../utils/utils.dart';

class WeatherForecast {
  final String date;
  final String icon;
  final String weatherType;
  final double tempF;
  final double precipChance;
  final double windMph;
  final double maxTempF;
  final double minTempF;
  final double maxTempC;
  final double minTempC;

  WeatherForecast({
    required this.date,
    required this.icon,
    required this.weatherType,
    required this.tempF,
    required this.precipChance,
    required this.windMph,
    required this.maxTempF,
    required this.minTempF,
    required this.maxTempC,
    required this.minTempC,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    return WeatherForecast(
      date: Utils.convrtStringUtf(json["date"] ?? ""),
      icon: Utils.convrtStringUtf(json["icon"] ?? ""),
      weatherType: Utils.convrtStringUtf(json["weather_type"] ?? ""),
      tempF: (json["temp_f"] ?? 0).toDouble(),
      precipChance: (json["precip_chance"] ?? 0).toDouble(),
      windMph: (json["wind_mph"] ?? 0).toDouble(),
      maxTempF: (json["maxtemp_f"] ?? 0).toDouble(),
      minTempF: (json["mintemp_f"] ?? 0).toDouble(),
      maxTempC: (json["maxtemp_c"] ?? 0).toDouble(),
      minTempC: (json["mintemp_c"] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "date": date,
      "icon": icon,
      "weather_type": weatherType,
      "temp_f": tempF,
      "precip_chance": precipChance,
      "wind_mph": windMph,
      "maxtemp_f": maxTempF,
      "mintemp_f": minTempF,
      "maxtemp_c": maxTempC,
      "mintemp_c": minTempC,
    };
  }

  @override
  String toString() {
    return "$date, $icon,$weatherType,$tempF,$precipChance,$windMph,$maxTempF,$minTempF,$maxTempC,$minTempC,";
  }
}
