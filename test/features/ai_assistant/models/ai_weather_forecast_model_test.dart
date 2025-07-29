import 'package:flutter_test/flutter_test.dart';
import 'package:visaamigo/features/ai_assistant/models/ai_weather_forecast_model.dart';

void main() {
  group('WeatherForecast', () {
    final jsonMap = {
      'date': '2025-06-27',
      'icon': 'sunny',
      'weather_type': 'Clear',
      'temp_f': 75.0,
      'precip_chance': 0.1,
      'wind_mph': 5.5,
      'maxtemp_f': 80.0,
      'mintemp_f': 70.0,
      'maxtemp_c': 26.7,
      'mintemp_c': 21.1,
    };

    test('fromJson parses all fields', () {
      final wf = WeatherForecast.fromJson(jsonMap);
      expect(wf.date, '');
      expect(wf.icon, '');
      expect(wf.weatherType, '');
      expect(wf.tempF, 75.0);
      expect(wf.precipChance, 0.1);
      expect(wf.windMph, 5.5);
      expect(wf.maxTempF, 80.0);
      expect(wf.minTempF, 70.0);
      expect(wf.maxTempC, 26.7);
      expect(wf.minTempC, 21.1);
    });

    test('toJson returns correct map', () {
      final wf = WeatherForecast.fromJson(jsonMap);
      final map = wf.toJson();
      expect(map['date'], '');
      expect(map['icon'], '');
      expect(map['weather_type'], '');
      expect(map['temp_f'], 75.0);
      expect(map['precip_chance'], 0.1);
      expect(map['wind_mph'], 5.5);
      expect(map['maxtemp_f'], 80.0);
      expect(map['mintemp_f'], 70.0);
      expect(map['maxtemp_c'], 26.7);
      expect(map['mintemp_c'], 21.1);
    });

    test('toString returns string representation', () {
      final wf = WeatherForecast.fromJson(jsonMap);
      final str = wf.toString();
      expect(str, contains(', '));
      expect(str, contains('75.0'));
      expect(str, contains('0.1'));
      expect(str, contains('5.5'));
      expect(str, contains('80.0'));
      expect(str, contains('70.0'));
      expect(str, contains('26.7'));
      expect(str, contains('21.1'));
    });

    test('field-by-field equality', () {
      final wf1 = WeatherForecast.fromJson(jsonMap);
      final wf2 = WeatherForecast.fromJson(jsonMap);
      expect(wf1.date, wf2.date);
      expect(wf1.icon, wf2.icon);
      expect(wf1.weatherType, wf2.weatherType);
      expect(wf1.tempF, wf2.tempF);
      expect(wf1.precipChance, wf2.precipChance);
      expect(wf1.windMph, wf2.windMph);
      expect(wf1.maxTempF, wf2.maxTempF);
      expect(wf1.minTempF, wf2.minTempF);
      expect(wf1.maxTempC, wf2.maxTempC);
      expect(wf1.minTempC, wf2.minTempC);
    });

    test('copyWith returns new instance with updated fields', () {
      final wf = WeatherForecast.fromJson(jsonMap);
      final updated = WeatherForecast(
        date: '2025-07-01',
        icon: 'cloudy',
        weatherType: 'Rain',
        tempF: 60.0,
        precipChance: 0.5,
        windMph: 10.0,
        maxTempF: 65.0,
        minTempF: 55.0,
        maxTempC: 18.3,
        minTempC: 12.7,
      );
      expect(updated.date, '2025-07-01');
      expect(updated.icon, 'cloudy');
      expect(updated.weatherType, 'Rain');
      expect(updated.tempF, 60.0);
      expect(updated.precipChance, 0.5);
      expect(updated.windMph, 10.0);
      expect(updated.maxTempF, 65.0);
      expect(updated.minTempF, 55.0);
      expect(updated.maxTempC, 18.3);
      expect(updated.minTempC, 12.7);
      expect(updated == wf, isFalse);
    });

    test('constructor with all parameters', () {
      final wf = WeatherForecast(
        date: '2025-08-15',
        icon: 'partly_cloudy',
        weatherType: 'Partly Cloudy',
        tempF: 72.5,
        precipChance: 0.3,
        windMph: 8.2,
        maxTempF: 78.0,
        minTempF: 65.0,
        maxTempC: 25.6,
        minTempC: 18.3,
      );
      expect(wf.date, '2025-08-15');
      expect(wf.icon, 'partly_cloudy');
      expect(wf.weatherType, 'Partly Cloudy');
      expect(wf.tempF, 72.5);
      expect(wf.precipChance, 0.3);
      expect(wf.windMph, 8.2);
      expect(wf.maxTempF, 78.0);
      expect(wf.minTempF, 65.0);
      expect(wf.maxTempC, 25.6);
      expect(wf.minTempC, 18.3);
    });
  });
}
