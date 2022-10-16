// ignore_for_file: implementation_imports, unnecessary_import

import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.grey,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        title: Text(
          'Privacy Policy',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 18,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(47, 47, 47, 16),
              child: Text(
                'Pulse Rate Monitor is  app based heart rate monitor that measures pulse from the fingertip using camera of the phone and its flash.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  color: Colors.grey,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}