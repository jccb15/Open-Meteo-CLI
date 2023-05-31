import 'dart:io';

import 'weather_api.dart';

void main(List<String> args) async {
  if (args.length != 1) {
    print("Usage: dart bin/main.dart <city>");
    return;
  }

  final city = args.first;
  final api = WeatherApi();

  try {
    final (lat: lat, long: long) = await api.fetchLatLong(city);
    final weather = await api.fetchWeather(lat, long);
    print(weather);
  } on WeatherApiException catch (e) {
    print(e.message);
  } on SocketException catch (_) {
    print('Could not fetch data. Check your connection.');
  } catch (e) {
    print(e);
  }
}
