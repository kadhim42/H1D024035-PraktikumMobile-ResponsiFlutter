import 'package:flutter/foundation.dart';
import 'package:cuaca/models/location_model.dart';
import 'package:cuaca/services/geocoding_service.dart';
import 'package:cuaca/services/local_storage_service.dart';

// state hasil pencarian: awal / loading / error / kosong / ada hasil
enum SearchStatus { initial, loading, error, empty, success }

class SearchViewModel extends ChangeNotifier {
  final GeocodingService _geocoding = GeocodingService();
  final LocalStorageService _storage = LocalStorageService();

  SearchStatus status = SearchStatus.initial;
  List<LocationModel> results = [];
  List<LocationModel> favorites = [];
  String errorMessage = '';

  // dipanggil saat app dibuka biar favorit tampil lagi
  Future<void> loadFavorites() async {
    favorites = await _storage.getFavorites();
    notifyListeners();
  }

  Future<void> search(String query) async {
    final q = query.trim();
    if (q.isEmpty) return;

    status = SearchStatus.loading;
    notifyListeners();

    try {
      results = await _geocoding.searchCity(q);
      status = results.isEmpty ? SearchStatus.empty : SearchStatus.success;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      status = SearchStatus.error;
    }
    notifyListeners();
  }

  // id dari geocoding unik per lokasi, jadi cukup dibandingkan pakai id
  bool isFavorite(LocationModel loc) {
    return favorites.any((e) => e.id == loc.id);
  }

  // klik bintang: kalau sudah favorit dihapus, kalau belum ditambah
  Future<void> toggleFavorite(LocationModel loc) async {
    if (isFavorite(loc)) {
      favorites.removeWhere((e) => e.id == loc.id);
    } else {
      favorites.add(loc);
    }
    await _storage.saveFavorites(favorites);
    notifyListeners();
  }
}
