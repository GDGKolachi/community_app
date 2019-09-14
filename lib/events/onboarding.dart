import 'package:flutter/material.dart';
import 'package:flutter_pk/events/login.dart';
import 'package:flutter_pk/global.dart';
import 'package:flutter_pk/helpers/shared_preferences.dart';
import 'package:flutter_pk/registration/registration.dart';
import 'package:flutter_pk/widgets/full_screen_loader.dart';
import 'package:flutter_pk/widgets/sprung_box.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sprung/sprung.dart';

class OnboardingPage extends StatefulWidget {
  OnboardingPage({
    Key key,
    this.title,
  }) : super(key: key);

  final String title;

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  bool _isLoading = false;
  bool _showSwipeText = false;
  bool _isFetchingSharedPreferences = false;
  SharedPreferencesHandler preferences;

  LoginApi api = LoginApi();

  @override
  void initState() {
    super.initState();
    api.initialize();
    preferences = SharedPreferencesHandler();
    _getSharedPreferences();
  }

  void _getSharedPreferences() async {
    setState(() => _isFetchingSharedPreferences = true);
    try {
      var userId =
          await preferences.getValue(SharedPreferencesKeys.firebaseUserId);
      if (userId != null) {
        await userCache.getUser(userId);
        await Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.home,
          ModalRoute.withName(Routes.main),
        );
      }
    } catch (ex) {
      print(ex);
      Alert(
        context: context,
        type: AlertType.error,
        title: "Oops!",
        desc: "An error has occurred",
        buttons: [
          DialogButton(
            child: Text("Dismiss",
                style: Theme.of(context).textTheme.title.copyWith(
                      color: Colors.white,
                    )),
            color: Colors.red,
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ).show();
    } finally {
      setState(() {
        _isFetchingSharedPreferences = false;
        _showSwipeText = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          backgroundColor: SplashScreenConfig.backgroundColor,
          body: _buildBody(context),
        ),
        _isLoading ? FullScreenLoader() : Container()
      ],
    );
  }

  SafeArea _buildBody(BuildContext context) {
    return SafeArea(
      child: new Swiper.children(
        autoplay: false,
        loop: false,
        physics: _isFetchingSharedPreferences
            ? NeverScrollableScrollPhysics()
            : ScrollPhysics(),
        children: <Widget>[
          _buildFirstSwiperControlPage(context),
          _buildSecondSwiperControlPage(context),
        ],
      ),
    );
  }

  Center _buildFirstSwiperControlPage(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SprungBox(
            damped: Damped.critically,
            assetImageName: SplashScreenConfig.logoAssetName,
            callback: (bool value) {},
          ),
          AnimatedCrossFade(
            crossFadeState: _showSwipeText
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: Duration(milliseconds: 800),
            firstChild: Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: Text('Swipe left to proceed'),
            ),
            secondChild: Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: Text(
                'Please wait ...',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Center _buildSecondSwiperControlPage(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          if (!_isLoading)
            Padding(
              padding: const EdgeInsets.only(left: 64.0, right: 64.0),
              child: Image(image: AssetImage(SplashScreenConfig.logoAssetName)),
            ),
          Column(
            children: <Widget>[
              Text(
                'Register | Attend | Build',
                style: Theme.of(context).textTheme.title,
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 32.0, left: 32.0, right: 32.0),
                child: Text(
                  'Get information about events, their agendas and register yourself as an attendee',
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32.0, bottom: 32.0),
                child: RaisedButton(
                  onPressed: _handleSignIn,
                  textColor: Colors.white,
                  child: Text('Get started'),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Future _handleSignIn() async {
    userCache.clear();
    await preferences.clearPreferences();

    setState(() => _isLoading = true);

    try {
      String userId = await api.initiateLogin();
      await userCache.getUser(userId);

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => RegistrationPage(),
          fullscreenDialog: true,
        ),
      );

      // Navigator.of(context).pushNamedAndRemoveUntil(
      //   Routes.home_master,
      //   ModalRoute.withName(Routes.main),
      // );
    } catch (ex) {
      print(ex);
      Alert(
        context: context,
        type: AlertType.error,
        title: "Oops!",
        desc: "An error has occurred",
        buttons: [
          DialogButton(
            child: Text("Dismiss",
                style: Theme.of(context).textTheme.title.copyWith(
                      color: Colors.white,
                    )),
            color: Colors.red,
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ).show();
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
