import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'presentation/app_home.dart';
import 'presentation/dashboard/dashboard_style.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: TradingJournalApp()));
}

class TradingJournalApp extends StatelessWidget {
  const TradingJournalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trading Journal',
      theme: AppTheme.darkTheme,
      home: const AppHome(),
    );
  }
}
