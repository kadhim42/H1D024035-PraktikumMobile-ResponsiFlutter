import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cuaca/models/location_model.dart';

class GeocodingService {
  // cari kota berdasarkan nama, GET ke Geocoding API Open-Meteo
  Future<List<LocationModel>> searchCity(String query) async {
    final uri = Uri.https('geocoding-api.open-meteo.com', '/v1/search', {
      'name': query,
      'count': '10',
      'language': 'id',
      'format': 'json',
    });

    final response = await http.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Gagal mencari kota (${response.statusCode})');
    }

    final data = jsonDecode(response.body);

    // kalau tidak ada hasil, key "results" tidak dikirim sama sekali
    if (data['results'] == null) return [];

    final List results = data['results'];
    return results.map((e) => LocationModel.fromJson(e)).toList();
  }
}
