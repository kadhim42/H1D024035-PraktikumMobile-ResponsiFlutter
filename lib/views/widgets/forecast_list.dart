import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cuaca/core/utils/weather_code.dart';
import 'package:cuaca/models/weather_model.dart';

// perkiraan cuaca beberapa hari ke depan
class ForecastList extends StatelessWidget {
  final List<DailyForecast> daily;

  const ForecastList({super.key, required this.daily});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Perkiraan 7 hari', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            if (daily.isEmpty)
              const Text('Data perkiraan tidak tersedia')
            else
              ...daily.map((d) => _row(context, d)),
          ],
        ),
      ),
    );
  }

  Widget _row(BuildContext context, DailyForecast d) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(DateFormat('EEEE, d MMM', 'id_ID').format(d.date)),
          ),
          Icon(WeatherCode.icon(d.weatherCode), size: 22),
          const SizedBox(width: 8),
          SizedBox(
            width: 44,
            child: Text('${d.rainProbability}%',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.primary)),
          ),
          SizedBox(
            width: 76,
            child: Text('${d.tempMax.round()}° / ${d.tempMin.round()}°',
                textAlign: TextAlign.end),
          ),
        ],
      ),
    );
  }
}
