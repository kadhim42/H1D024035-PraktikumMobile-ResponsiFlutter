class LocationModel {
  final int id;
  final String name;
  final String? admin1; // provinsi / wilayah
  final String country;
  final double latitude;
  final double longitude;

  LocationModel({
    required this.id,
    required this.name,
    this.admin1,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  // dipakai buat hasil geocoding API dan data dari local storage
  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      admin1: json['admin1'],
      country: json['country'] ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  // buat disimpan ke SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'admin1': admin1,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  // teks kecil di bawah nama kota, contoh: "Jawa Tengah, Indonesia"
  String get subtitle {
    final parts = [admin1, country].where((e) => e != null && e.isNotEmpty);
    return parts.join(', ');
  }
}
