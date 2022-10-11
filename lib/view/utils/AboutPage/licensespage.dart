import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../provider/view_provider.dart';

class LicensesPage extends ConsumerWidget {
  const LicensesPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(isDarkModeProvider);
    return Container(
      color: Colors.transparent,
      child: LicensePage(
        applicationName: 'Pulse Rate Monitor',
      ),
    );
  }
}
