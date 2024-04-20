import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:meteoapp/domain/api/api_constant.dart';

import '../domain/models/forecast_model.dart';

class ForecastApiProvider {
  final String apiUrl;

  // Singleton instance
  static final ForecastApiProvider _instance =
      ForecastApiProvider._internal(apiUrl: ApiConstants.apiUrl);

  factory ForecastApiProvider() {
    return _instance;
  }

  ForecastApiProvider._internal({required this.apiUrl});

  Future<List<Forecast>> getDailyForecast(double lat, double lon) async {
    final response =
        await http.get(Uri.parse('$apiUrl/data/forecast/daily/$lat/$lon'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Forecast.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load daily forecast');
    }
  }

  Future<List<Forecast>> getHourlyForecast(double lat, double lon) async {
    final response =
        await http.get(Uri.parse('$apiUrl/data/forecast/hourly/$lat/$lon'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Forecast.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load hourly forecast');
    }
  }

  Future<Forecast> getHourSpecificForecast(
      double lat, double lon, int timestamp) async {
    final response = await http
        .get(Uri.parse('$apiUrl/data/forecast/hourly/$lat/$lon/$timestamp'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return Forecast.fromJson(jsonData);
    } else {
      throw Exception('Failed to load hour specific forecast');
    }
  }

  Future<Forecast> getDaySpecificForecast(
      double lat, double lon, int timestamp) async {
    final response = await http
        .get(Uri.parse('$apiUrl/data/forecast/dayly/$lat/$lon/$timestamp'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return Forecast.fromJson(jsonData);
    } else {
      throw Exception('Failed to load day specific forecast');
    }
  }

  Future<String> getPlaceFromCoordinates(double lat, double lon) async {
    // Implement reverse geocoding logic to get the place name from coordinates
    // You might need to use a reverse geocoding service or API for this
    // Example: https://nominatim.org/release-docs/develop/api/Reverse/
    // This is just a placeholder; replace it with a proper implementation
    return 'City, Country';
  }
}
