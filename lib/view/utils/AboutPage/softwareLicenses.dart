// ignore_for_file: prefer_const_constructors, implementation_imports, unnecessary_import, prefer_const_literals_to_create_immutables

import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';

class SoftwareLicenses extends StatelessWidget {
  const SoftwareLicenses({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => LicensePage(
        applicationName: 'Pulse Rate Monitor',
      );
}
