import 'package:flutter/material.dart';

// mapping weather_code (WMO) dari Open-Meteo ke teks dan ikon
class WeatherCode {
  static String description(int code) {
    if (code == 0) return 'Cerah';
    if (code == 1) return 'Cerah berawan';
    if (code == 2) return 'Berawan sebagian';
    if (code == 3) return 'Berawan';
    if (code == 45 || code == 48) return 'Berkabut';
    if (code >= 51 && code <= 57) return 'Gerimis';
    if (code >= 61 && code <= 67) return 'Hujan';
    if (code >= 71 && code <= 77) return 'Salju';
    if (code >= 80 && code <= 82) return 'Hujan lebat';
    if (code == 85 || code == 86) return 'Hujan salju';
    if (code == 95) return 'Badai petir';
    if (code == 96 || code == 99) return 'Badai petir dan es';
    return 'Tidak diketahui';
  }

  static IconData icon(int code) {
    if (code == 0) return Icons.wb_sunny;
    if (code == 1 || code == 2) return Icons.wb_cloudy_outlined;
    if (code == 3) return Icons.cloud;
    if (code == 45 || code == 48) return Icons.foggy;
    if (code >= 51 && code <= 67) return Icons.grain;
    if (code >= 71 && code <= 77) return Icons.ac_unit;
    if (code >= 80 && code <= 86) return Icons.water_drop;
    if (code >= 95) return Icons.thunderstorm;
    return Icons.help_outline;
  }
}
