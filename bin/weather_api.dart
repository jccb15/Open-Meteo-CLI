import 'dart:convert';

import 'package:http/http.dart' as http;

import 'weather.dart';

class WeatherApi {
  Future<({double lat, double long})> fetchLatLong(String city) async {
    const baseLocationUrl = "https://geocoding-api.open-meteo.com/v1";
    final locationUrl = Uri.parse("$baseLocationUrl//search?name=$city&count=1");
    final locationResponse = await http.get(locationUrl);
    if (locationResponse.statusCode != 200) {
      throw WeatherApiException("Could not find location for city $city");
    }
    final locationJson = jsonDecode(locationResponse.body);
    final locations = locationJson["results"] as List;
    final lat = locations.first["latitude"] as double;
    final long = locations.first["longitude"] as double;
    return (lat: lat, long: long);
  }

  Future<Weather> fetchWeather(double lat, double long) async {
    const baseWeatherUrl = "https://api.open-meteo.com/v1";
    final weatherUrl = Uri.parse(
        "$baseWeatherUrl/forecast?latitude=${lat.toStringAsFixed(2)}&longitude=${long.toStringAsFixed(2)}&hourly=temperature_2m&daily=weathercode,temperature_2m_max,temperature_2m_min&forecast_days=1&timezone=auto");
    final weatherResponse = await http.get(weatherUrl);
    if (weatherResponse.statusCode != 200) {
      throw WeatherApiException("Error getting weather for lat: $lat and long: $long");
    }
    final weatherJson = jsonDecode(weatherResponse.body);

    final description = getWeatherDescription(weatherJson["daily"]["weathercode"][0]);
    final maxTemp = weatherJson["daily"]["temperature_2m_max"][0] as double;
    final minTemp = weatherJson["daily"]["temperature_2m_min"][0] as double;
    final currentTemp = weatherJson["hourly"]["temperature_2m"][DateTime.now().hour];

    return Weather(currentTemp: currentTemp, description: description, maxTemp: maxTemp, minTemp: minTemp);
  }

  static String getWeatherDescription(int code) {
    String description = switch (code) {
      0 => "Clear sku",
      1 => "Mainly clear",
      2 => "Partly Cloudy",
      3 => "Overcast",
      45 => "Fog",
      48 => "Depositing rime fog",
      51 => "Drizzle: ligth",
      53 => "Drizzle: moderate",
      55 => "Drizzle: dense",
      56 => "Freezing drizzle: light",
      57 => "Freezing drizzle: dense",
      61 => "Slight rain",
      63 => "Moderate rain",
      65 => "Heavy rain",
      66 => "Light freezing rain",
      67 => "Heavy freezin rain",
      71 => "Slight snow fall",
      73 => "Moderate snow fall",
      75 => "Heavy snow fall",
      77 => "Snow grains",
      80 => "Slight rain showers",
      81 => "Moderate rain showers",
      82 => "Heavy rain showers",
      85 => "Slight snow showers",
      86 => "Heavy snow showers",
      95 => "Thunderstorm",
      96 => "Thunderstorm with slight hail",
      99 => "Thunderstorm with heavy hail",
      _ => "Unknown weather"
    };
    return description;
  }
}

class WeatherApiException implements Exception {
  WeatherApiException(this.message);

  String message;
}
