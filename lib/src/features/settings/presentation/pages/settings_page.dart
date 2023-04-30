import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pulse_rate_monitor/src/common/theme/theme_bottom_sheet.dart';
import 'package:pulse_rate_monitor/src/features/settings/presentation/pages/software_licenses.dart';

/// This widget shows a settings page with option to
/// change the current theme, license and app version
class SettingsPage extends ConsumerWidget {
  /// Creates [SettingsPage]
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Settings'),
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(
              Icons.brush,
            ),
            title: const Text(
              'Theme',
            ),
            onTap: () => showModalBottomSheet<Widget>(
              builder: (
                BuildContext context,
              ) =>
                  const ThemeBottomSheet(),
              context: context,
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.phone_android,
            ),
            title: const Text(
              'Software Licenses',
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<SoftwareLicenses>(
                  builder: (context) {
                    return const SoftwareLicenses();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
