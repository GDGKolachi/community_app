import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pk/global.dart';
import 'package:flutter_pk/home_master.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Pakistan'),
      routes: {
        Routes.home_master: (context) => new HomePageMaster(),
        Routes.main: (context) => MyHomePage()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> widgets = <Widget>[
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(
            image: AssetImage('assets/flutterKarachi.png'),
          ),
          Text(
            'Welcome to Flutter Pakistan',
          )
        ],
      ),
    ),
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(
            image: AssetImage('assets/flutterKarachi.png'),
          ),
          Text(
            'Welcome to Flutter Pakistan',
          )
        ],
      ),
    )
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      body: SafeArea(
        child: new Stack(
          children: <Widget>[
            new Swiper.children(
              autoplay: false,
              pagination: new SwiperPagination(
                margin: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 30.0),
                builder: new DotSwiperPaginationBuilder(
                    color: Colors.black26,
                    activeColor: Colors.blue,
                    size: 10.0,
                    activeSize: 15.0),
              ),
              children: <Widget>[
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      SizedBox(
                        height: 250.0,
                        width: 250.0,
                        child: Image(
                          image: AssetImage('assets/flutterKarachi.png'),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            'Welcome to Flutter Pakistan',
                            style: Theme.of(context).textTheme.title,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 32.0),
                            child: Text('Swipe right to proceed'),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      SizedBox(
                        height: 250.0,
                        width: 250.0,
                        child: Image(
                          image: AssetImage('assets/flutterKarachi.png'),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            'Register | Attend | Build',
                            style: Theme.of(context).textTheme.title,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 32.0, left: 32.0, right: 32.0),
                            child: Text(
                              'Get information about events, their agendas and register yourself as an attendee',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 32.0),
                            child: RaisedButton(
                              onPressed: () =>
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                    Routes.home_master,
                                    ModalRoute.withName(Routes.main),
                                  ),
                              color: Colors.blue,
                              textColor: Colors.white,
                              child: Text('Get started'),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
