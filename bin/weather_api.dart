import 'dart:convert';

import 'package:http/http.dart' as http;

class WeatherApi {
  Future<({double lat, double long})> fetchLatLong(String city) async {
    const baseLocationUrl = "https://geocoding-api.open-meteo.com/v1";
    final locationUrl = Uri.parse("$baseLocationUrl//search?name=$city&count=1");
    final locationResponse = await http.get(locationUrl);
    if (locationResponse.statusCode != 200) {
      throw Exception("Could not find location for city $city");
    }
    final locationJson = jsonDecode(locationResponse.body);
    final locations = locationJson["results"] as List;
    final lat = locations.first["latitude"] as double;
    final long = locations.first["longitude"] as double;
    return (lat: lat, long: long);
  }
}
