import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pk/events/event_listing_page.dart';
import 'package:flutter_pk/events/onboarding.dart';
import 'package:flutter_pk/global.dart';
import 'package:flutter_pk/theme.dart';

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
        Routes.home: (context) => new EventListingPage(),
        Routes.main: (context) => OnboardingPage()
      },
    );
  }
}
