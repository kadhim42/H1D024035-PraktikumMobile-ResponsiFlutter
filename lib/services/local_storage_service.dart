import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cuaca/models/location_model.dart';

class LocalStorageService {
  static const _favKey = 'favorites';
  static const _lastKey = 'last_location';

  // favorit disimpan sebagai list string JSON
  Future<List<LocationModel>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_favKey) ?? [];
    return list.map((e) => LocationModel.fromJson(jsonDecode(e))).toList();
  }

  Future<void> saveFavorites(List<LocationModel> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    final list = favorites.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_favKey, list);
  }

  // lokasi terakhir dipilih, biar pas app dibuka langsung muncul
  Future<LocationModel?> getLastLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(_lastKey);
    if (str == null) return null;
    return LocationModel.fromJson(jsonDecode(str));
  }

  Future<void> saveLastLocation(LocationModel location) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastKey, jsonEncode(location.toJson()));
  }
}
