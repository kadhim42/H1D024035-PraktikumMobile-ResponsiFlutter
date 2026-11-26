import 'package:flutter/foundation.dart';
import 'package:cuaca/models/location_model.dart';
import 'package:cuaca/models/weather_model.dart';
import 'package:cuaca/services/local_storage_service.dart';
import 'package:cuaca/services/weather_service.dart';

// state layar cuaca: loading / error / data
enum WeatherStatus { loading, error, success }

class WeatherViewModel extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  final LocalStorageService _storage = LocalStorageService();

  WeatherStatus status = WeatherStatus.loading;
  LocationModel? location;
  WeatherModel? weather;
  String errorMessage = '';

  // lokasi default kalau belum pernah memilih kota (Purwokerto)
  static final LocationModel _defaultLocation = LocationModel(
    id: 1630789,
    name: 'Purwokerto',
    admin1: 'Jawa Tengah',
    country: 'Indonesia',
    latitude: -7.4214,
    longitude: 109.2342,
  );

  // dipanggil saat app dibuka: ambil lokasi terakhir dari local storage
  Future<void> init() async {
    final last = await _storage.getLastLocation();
    await loadWeather(last ?? _defaultLocation);
  }

  Future<void> loadWeather(LocationModel loc) async {
    location = loc;
    status = WeatherStatus.loading;
    notifyListeners();

    try {
      weather = await _weatherService.getWeather(loc.latitude, loc.longitude);
      status = WeatherStatus.success;
      await _storage.saveLastLocation(loc);
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      status = WeatherStatus.error;
    }
    notifyListeners();
  }

  // buat tombol coba lagi / pull to refresh
  Future<void> refresh() async {
    if (location != null) await loadWeather(location!);
  }
}
