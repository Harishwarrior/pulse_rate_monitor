import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pulse_rate_monitor/src/common/theme/app_theme_mode_provider.dart';
import 'package:pulse_rate_monitor/src/common/theme/theme.dart';

import 'package:pulse_rate_monitor/src/features/pulse_rate_monitor/presentation/pulse_rate_monitor.dart';

/// Main widget of the app
class MyApp extends ConsumerWidget {
  /// Creates [MyApp]
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appThemeMode = ref.watch(appThemeModeProvider);
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: appThemeMode,
      home: const PulseRateMonitorPage(),
    );
  }
}
