import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pulse_rate_monitor/src/app.dart';
import 'package:pulse_rate_monitor/src/common/shared_preferences/shared_preference_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // required for using shared preferences .. etc
  WidgetsFlutterBinding.ensureInitialized();

  /// Storing instance of SharedPreference
  SharedPreferenceManager.instance = await SharedPreferences.getInstance();
  runApp(
    const ProviderScope(child: MyApp()),
  );
}
