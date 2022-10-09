import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pulse_rate_monitor/provider/view_provider.dart';
import 'package:pulse_rate_monitor/theme_data.dart';
import 'package:pulse_rate_monitor/view/home_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    ProviderScope(child: MyApp()),
  );
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ref.watch(isDarkModeProvider) ? lightTheme : darkTheme,
      home: HomePage(),
    );
  }
}
