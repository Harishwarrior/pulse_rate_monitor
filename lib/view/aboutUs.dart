// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pulse_rate_monitor/view/utils/AboutPage/privacyPolicy.dart';
import 'package:pulse_rate_monitor/view/utils/AboutPage/softwareLicenses.dart';
import 'package:pulse_rate_monitor/view/utils/AboutPage/termsOfServices.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key key}) : super(key: key);

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
          'About',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 24,
                    height: 54,
                    child: TextButton(
                      style: ButtonStyle(
                          textStyle: MaterialStateProperty.all(const TextStyle(
                              fontSize: 20, color: Colors.grey))),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return SoftwareLicenses();
                            },
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.phone_android,
                            size: 24.0,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Software Licenses',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                          ), // <-- Text
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 24,
                    height: 54,
                    child: TextButton(
                      style: ButtonStyle(
                          textStyle: MaterialStateProperty.all(const TextStyle(
                              fontSize: 20, color: Colors.grey))),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 24.0,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Version 163.1.6 (arm64-\nv8a_release_flutter)',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                          ), // <-- Text
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
