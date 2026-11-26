import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:cuaca/core/theme/app_theme.dart';
import 'package:cuaca/viewmodels/search_viewmodel.dart';
import 'package:cuaca/viewmodels/weather_viewmodel.dart';
import 'package:cuaca/views/weather_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // format tanggal bahasa Indonesia (hari, bulan)
  await initializeDateFormatting('id_ID');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // dua ViewModel didaftarkan di sini biar bisa diakses dari semua screen
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeatherViewModel()..init()),
        ChangeNotifierProvider(create: (_) => SearchViewModel()..loadFavorites()),
      ],
      child: MaterialApp(
        title: 'Cuaca',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const WeatherScreen(),
      ),
    );
  }
}
