// create a toggle menu

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/view_provider.dart';

class Settings extends ConsumerWidget {
  const Settings({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(isDarkModeProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Settings'),
      ),
      body: Center(
        child: CupertinoSwitch(
          value: !isDarkMode,
          activeColor: Colors.blue,
          onChanged: (value) {
            ref.read(isDarkModeProvider.notifier).state = !isDarkMode;
          },
        ),
      ),
    );
  }
}
