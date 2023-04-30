import 'package:flutter/material.dart';

/// This widget shows the license information for the packages
/// used in this app
class SoftwareLicenses extends StatelessWidget {
  /// Creates [SoftwareLicenses]
  const SoftwareLicenses({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) =>
      const LicensePage(
        applicationName: 'Pulse Rate Monitor',
      );
}
