import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pulse_rate_monitor/src/common/theme/app_spacing.dart';
import 'package:pulse_rate_monitor/src/common/theme/app_theme_mode_provider.dart';
import 'package:pulse_rate_monitor/src/common/theme/theme_extensions.dart';

/// [ThemeBottomSheet] will handle theme switching in the app
class ThemeBottomSheet extends ConsumerStatefulWidget {
  /// initializes [key]
  const ThemeBottomSheet({
    super.key,
  });

  @override
  ConsumerState<ThemeBottomSheet> createState() => _ThemeBottomSheetState();
}

class _ThemeBottomSheetState extends ConsumerState<ThemeBottomSheet> {
  late ThemeMode themeMode;
  @override
  void initState() {
    super.initState();
    themeMode = ref.read(appThemeModeProvider);
  }

  @override
  Widget build(BuildContext context) {
    /// [themeDropdownItemList] contains [Map] of [Text] and [ThemeMode]
    final themeDropdownItemList = <String, ThemeMode>{
      'System': ThemeMode.system,
      'Light': ThemeMode.light,
      'Dark': ThemeMode.dark,
    };
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.remove,
          size: 45,
        ),
        SizedBox(
          height: 150,
          child: CupertinoPicker(
            scrollController:
                FixedExtentScrollController(initialItem: themeMode.index),
            magnification: 1.22,
            useMagnifier: true,
            itemExtent: 40,
            squeeze: 1.2,
            onSelectedItemChanged: (int selectedItem) {
              themeMode =
                  themeDropdownItemList.entries.elementAt(selectedItem).value;
            },
            children: themeDropdownItemList.keys
                .map(
                  (e) => Center(
                    child: Text(
                      e,
                      style: context.bodyLarge,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(
            AppSpacing.sm,
          ),
          child: SizedBox(
            height: 52,
            width: double.maxFinite,
            child: ElevatedButton(
              onPressed: () async {
                await ref
                    .read(appThemeModeProvider.notifier)
                    .changeTheme(themeMode);
                if (mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Apply'),
            ),
          ),
        ),
      ],
    );
  }
}
