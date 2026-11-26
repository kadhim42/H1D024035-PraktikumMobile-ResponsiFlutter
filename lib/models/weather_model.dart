// data cuaca saat ini (bagian "current" dari response)
class CurrentWeather {
  final double temperature;
  final double apparentTemperature;
  final int humidity;
  final double precipitation;
  final double windSpeed;
  final int weatherCode;

  CurrentWeather({
    required this.temperature,
    required this.apparentTemperature,
    required this.humidity,
    required this.precipitation,
    required this.windSpeed,
    required this.weatherCode,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temperature: (json['temperature_2m'] as num).toDouble(),
      apparentTemperature: (json['apparent_temperature'] as num).toDouble(),
      humidity: (json['relative_humidity_2m'] as num).toInt(),
      precipitation: (json['precipitation'] as num).toDouble(),
      windSpeed: (json['wind_speed_10m'] as num).toDouble(),
      weatherCode: (json['weather_code'] as num).toInt(),
    );
  }
}

// satu hari di perkiraan cuaca (bagian "daily")
class DailyForecast {
  final DateTime date;
  final double tempMax;
  final double tempMin;
  final int rainProbability;
  final int weatherCode;

  DailyForecast({
    required this.date,
    required this.tempMax,
    required this.tempMin,
    required this.rainProbability,
    required this.weatherCode,
  });
}

class WeatherModel {
  final CurrentWeather current;
  final List<DailyForecast> daily;

  WeatherModel({required this.current, required this.daily});

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final current = CurrentWeather.fromJson(json['current']);

    // data daily dari API bentuknya list per field, bukan list per hari
    // jadi harus digabung manual per index
    final d = json['daily'];
    final List dates = d['time'];
    final List maxList = d['temperature_2m_max'];
    final List minList = d['temperature_2m_min'];
    final List rainList = d['precipitation_probability_max'];
    final List codeList = d['weather_code'];

    final daily = <DailyForecast>[];
    for (int i = 0; i < dates.length; i++) {
      daily.add(DailyForecast(
        date: DateTime.parse(dates[i]),
        tempMax: (maxList[i] as num).toDouble(),
        tempMin: (minList[i] as num).toDouble(),
        // probabilitas bisa null kalau data belum tersedia
        rainProbability: ((rainList[i] ?? 0) as num).toInt(),
        weatherCode: (codeList[i] as num).toInt(),
      ));
    }

    return WeatherModel(current: current, daily: daily);
  }
}
