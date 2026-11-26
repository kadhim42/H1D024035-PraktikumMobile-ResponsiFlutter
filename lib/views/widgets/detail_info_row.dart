import 'package:flutter/material.dart';
import 'package:cuaca/models/weather_model.dart';

// info tambahan: kelembapan, angin, peluang hujan, curah hujan
class DetailInfoRow extends StatelessWidget {
  final CurrentWeather current;
  final int rainProbability; // diambil dari forecast hari ini

  const DetailInfoRow({
    super.key,
    required this.current,
    required this.rainProbability,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Row(
          children: [
            _item(context, Icons.water_drop_outlined, '${current.humidity}%',
                'Kelembapan'),
            _item(context, Icons.air, '${current.windSpeed.round()} km/j',
                'Angin'),
            _item(context, Icons.umbrella_outlined, '$rainProbability%',
                'Peluang hujan'),
            _item(context, Icons.grain, '${current.precipitation} mm',
                'Curah hujan'),
          ],
        ),
      ),
    );
  }

  Widget _item(
      BuildContext context, IconData icon, String value, String label) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(height: 6),
          Text(value, style: theme.textTheme.titleMedium),
          const SizedBox(height: 2),
          Text(label,
              textAlign: TextAlign.center, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
