import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pk/global.dart';
import 'package:flutter_pk/home/onboarding.dart';
import 'package:flutter_pk/theme.dart';

import 'home/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Pakistan',
      theme: theme,
      home: OnboardingPage(
        title: 'Flutter Pakistan',
      ),
      routes: {
        Routes.home_master: (context) => new HomePage(),
        Routes.main: (context) => OnboardingPage()
      },
    );
  }
}
