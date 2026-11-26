import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cuaca/models/location_model.dart';
import 'package:cuaca/viewmodels/search_viewmodel.dart';
import 'package:cuaca/viewmodels/weather_viewmodel.dart';
import 'package:cuaca/views/widgets/state_views.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _search(String query) {
    context.read<SearchViewModel>().search(query);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SearchViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Cari Lokasi')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              textInputAction: TextInputAction.search,
              onSubmitted: _search,
              decoration: InputDecoration(
                hintText: 'Cari nama kota',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () => _search(_controller.text),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(child: _buildBody(vm)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(SearchViewModel vm) {
    switch (vm.status) {
      case SearchStatus.loading:
        return const LoadingView();
      case SearchStatus.error:
        return ErrorView(
          message: vm.errorMessage,
          onRetry: () => _search(_controller.text),
        );
      case SearchStatus.empty:
        return const EmptyView(message: 'Kota tidak ditemukan');
      case SearchStatus.success:
        return _locationList(vm.results, vm);
      case SearchStatus.initial:
        // sebelum mencari, tampilkan daftar favorit (kalau ada)
        if (vm.favorites.isEmpty) {
          return const EmptyView(
            message: 'Cari kota untuk melihat cuacanya',
            icon: Icons.location_city,
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Favorit', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Expanded(child: _locationList(vm.favorites, vm)),
          ],
        );
    }
  }

  Widget _locationList(List<LocationModel> items, SearchViewModel vm) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, i) {
        final loc = items[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(loc.name),
            subtitle: Text(loc.subtitle),
            trailing: IconButton(
              icon: Icon(vm.isFavorite(loc) ? Icons.star : Icons.star_border),
              onPressed: () => vm.toggleFavorite(loc),
            ),
            // pilih lokasi: muat cuaca lalu kembali ke Weather Screen
            onTap: () {
              context.read<WeatherViewModel>().loadWeather(loc);
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}
