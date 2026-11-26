import 'package:flutter/material.dart';
import 'package:cuaca/core/utils/weather_code.dart';
import 'package:cuaca/models/location_model.dart';
import 'package:cuaca/models/weather_model.dart';

// kartu utama: nama kota, kondisi, suhu sekarang
class CurrentWeatherCard extends StatelessWidget {
  final LocationModel location;
  final CurrentWeather current;

  const CurrentWeatherCard({
    super.key,
    required this.location,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.primaryContainer,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(location.name, style: theme.textTheme.titleLarge),
              Text(location.subtitle, style: theme.textTheme.bodySmall),
              const SizedBox(height: 16),
              Icon(WeatherCode.icon(current.weatherCode), size: 64),
              Text('${current.temperature.round()}°',
                  style: theme.textTheme.displayLarge),
              Text(WeatherCode.description(current.weatherCode),
                  style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Text('Terasa seperti ${current.apparentTemperature.round()}°',
                  style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
