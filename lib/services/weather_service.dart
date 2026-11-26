import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cuaca/models/weather_model.dart';

class WeatherService {
  // ambil cuaca berdasarkan koordinat, GET ke Forecast API Open-Meteo
  Future<WeatherModel> getWeather(double lat, double lon) async {
    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': lat.toString(),
      'longitude': lon.toString(),
      'current':
          'temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m',
      'daily':
          'weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max',
      'timezone': 'auto',
      'forecast_days': '7',
    });

    final response = await http.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil data cuaca (${response.statusCode})');
    }

    return WeatherModel.fromJson(jsonDecode(response.body));
  }
}
