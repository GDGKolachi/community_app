import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pk/events/event_listing_page.dart';
import 'package:flutter_pk/events/onboarding.dart';
import 'package:flutter_pk/global.dart';
import 'package:flutter_pk/profile/model.dart';
import 'package:flutter_pk/registration/model.dart';
import 'package:flutter_pk/registration/registration.dart';
import 'package:flutter_pk/theme.dart';

void main() => runApp(CommunityApp());

class TestUserRegistrationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Insert users'),
        ),
        body: Center(
          child: Builder(
            builder: (context) => RaisedButton(
              child: Text('ADD RANDOM USER'),
              onPressed: () async {
                var service = RegistrationService();
                var name = 'user_${Random().nextInt(100)}';
                var email = '$name@gmail.com';
                var user = User(
                  email: email,
                  id: email,
                  name: name,
                  photoUrl:
                      'https://pbs.twimg.com/profile_images/1109696835562676224/aBCxM5b4_400x400.jpg',
                  occupation: Occupation(
                      designation: 'Designation',
                      type: 'Professional',
                      workOrInstitute: 'Workplace'),
                );

                await service.updateStatus('WJqsWCMmpTga6K4sbNz0', user,
                    RegistrationStates.registered);

                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('User created'),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class CommunityApp extends StatelessWidget {
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
