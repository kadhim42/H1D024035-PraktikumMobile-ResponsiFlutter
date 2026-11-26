import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cuaca/viewmodels/weather_viewmodel.dart';
import 'package:cuaca/views/search_screen.dart';
import 'package:cuaca/views/widgets/current_weather_card.dart';
import 'package:cuaca/views/widgets/detail_info_row.dart';
import 'package:cuaca/views/widgets/forecast_list.dart';
import 'package:cuaca/views/widgets/state_views.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // watch: tampilan dibangun ulang tiap ViewModel notifyListeners()
    final vm = context.watch<WeatherViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuaca'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
          ),
        ],
      ),
      body: _buildBody(vm),
    );
  }

  Widget _buildBody(WeatherViewModel vm) {
    switch (vm.status) {
      case WeatherStatus.loading:
        return const LoadingView();
      case WeatherStatus.error:
        return ErrorView(message: vm.errorMessage, onRetry: vm.refresh);
      case WeatherStatus.success:
        final weather = vm.weather!;
        final today = weather.daily.isNotEmpty ? weather.daily.first : null;

        return RefreshIndicator(
          onRefresh: vm.refresh,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              CurrentWeatherCard(
                location: vm.location!,
                current: weather.current,
              ),
              const SizedBox(height: 16),
              DetailInfoRow(
                current: weather.current,
                rainProbability: today?.rainProbability ?? 0,
              ),
              const SizedBox(height: 16),
              ForecastList(daily: weather.daily),
            ],
          ),
        );
    }
  }
}
