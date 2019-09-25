import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pk/caches/user.dart';
import 'package:flutter_pk/events/model.dart';
import 'package:flutter_pk/global.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter_pk/helpers/formatters.dart';
import 'package:flutter_pk/registration/registration.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_pk/schedule/schedule_page.dart';

class EventDetailContainer extends StatefulWidget {
  final EventDetails event;

  EventDetailContainer(this.event);

  @override
  EventDetailContainerState createState() {
    return new EventDetailContainerState();
  }
}

class EventDetailContainerState extends State<EventDetailContainer>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  String floatingButtonLabel = 'Register';
  IconData floatingButtonIcon = Icons.group_work;
  bool _isLoading = false;
  bool _isUserPresent = false;
  User _user = new User();
  List<Widget> tabPages;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    tabPages = <Widget>[
      EventDetailPage(widget.event),
      SchedulePage(widget.event.id),
      MessageBoard(),
    ];
    _tabController = TabController(
      length: tabPages.length,
      initialIndex: 0,
      vsync: this,
    )..addListener(
        () => setState(() => _selectedIndex = _tabController.index),
      );

    _setUser(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(widget.event.eventTitle),
            Text(
              formatDate(widget.event.date, DateFormats.shortUiDateFormat),
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      ),
      body: TabBarView(
        children: tabPages,
        controller: _tabController,
      ),
      // body: Stack(
      //   children: <Widget>[
      //     widgets[_selectedIndex],
      //     _isLoading ? FullScreenLoader() : Container()
      //   ],
      // ),
      bottomNavigationBar: _isLoading
          ? null
          : BottomNavigationBar(
              onTap: (value) {
                setState(() {
                  _selectedIndex = value;
                  _tabController.index = _selectedIndex;
                });
              },
              currentIndex: _selectedIndex,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.event),
                  title: Text('Summary'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.schedule),
                  title: Text('Schedule'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.forum),
                  title: Text('Messages'),
                ),
              ],
            ),
    );
  }

  void _floatingButtonTapModerator() {
    if (_selectedIndex == 2) {
      _navigateToGoogleMaps();
    } else if (_user.isRegistered) {
      if (!_isUserPresent) {
        if (DateTime.now().isBefore(eventDateTimeCache.eventDateTime)) {
          Alert(
            context: context,
            type: AlertType.info,
            title: "Information!",
            desc: "You will be able to scan a QR on the event day!\nCheers!",
            buttons: [
              DialogButton(
                child: Text("Cool!",
                    style: Theme.of(context).textTheme.title.copyWith(
                          color: Colors.white,
                        )),
                color: Colors.green,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ).show();
        } else {
          _scanQr();
        }
      } else {
        Alert(
          context: context,
          type: AlertType.info,
          title: "Information!",
          desc: "You are already marked present! \nEnjoy the event!",
          buttons: [
            DialogButton(
              child: Text("Cool!",
                  style: Theme.of(context).textTheme.title.copyWith(
                        color: Colors.white,
                      )),
              color: Colors.green,
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ).show();
      }
    } else {
      _navigateToRegistration(context);
    }
  }

  void _navigateToGoogleMaps() async {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    String googleUrl = '';
    if (isIOS) {
      googleUrl =
          'comgooglemapsurl://maps.google.com/maps?f=d&daddr=${locationCache.latitude},${locationCache.longitude}&sspn=0.2,0.1';
      String appleMapsUrl =
          'https://maps.apple.com/?sll=${locationCache.latitude},${locationCache.longitude}';
      if (await canLaunch("comgooglemaps://")) {
        print('launching com googleUrl');
        await launch(googleUrl);
      } else if (await canLaunch(appleMapsUrl)) {
        print('launching apple url');
        await launch(appleMapsUrl);
      } else {
        await launch(
            'https://www.google.com/maps/search/?api=1&query=${locationCache.latitude},${locationCache.longitude}');
      }
    } else {
      googleUrl =
          'google.navigation:q=${locationCache.latitude},${locationCache.longitude}&mode=d';
      if (await canLaunch(googleUrl)) {
        await launch(googleUrl);
      } else {
        await launch(
            'https://www.google.com/maps/search/?api=1&query=${locationCache.latitude},${locationCache.longitude}');
      }
    }
  }

  Future<String> _scanQr() async {
    try {
      String qrDataString = await BarcodeScanner.scan();
      print(qrDataString);
      if (qrDataString == GlobalConstants.qrKey) {
        setState(() {
          _isLoading = true;
        });
        DocumentReference attendanceReference = Firestore.instance
            .collection(FireStoreKeys.attendanceCollection)
            .document(FireStoreKeys.dateReferenceString);

        CollectionReference attendeeCollectionReference =
            attendanceReference.collection(FireStoreKeys.attendeesCollection);

        int attendanceCount;
        await Firestore.instance
            .collection(FireStoreKeys.attendanceCollection)
            .document(FireStoreKeys.dateReferenceString)
            .get()
            .then((onValue) {
          attendanceCount = onValue['attendanceCount'];
        });

        await attendanceReference
            .setData({'attendanceCount': attendanceCount + 1}, merge: true);

        await attendeeCollectionReference.document(userCache.user.id).setData(
          {'userName': userCache.user.name},
          merge: true,
        );
        CollectionReference reference =
            Firestore.instance.collection(FireStoreKeys.userCollection);

        await reference
            .document(userCache.user.id)
            .setData({"isPresent": true}, merge: true);
        _setUser(true);
        Alert(
          context: context,
          type: AlertType.success,
          title: "Yayy!",
          desc: "You have been marked present! Enjoy the event!",
          buttons: [
            DialogButton(
              child: Text("Cool!",
                  style: Theme.of(context).textTheme.title.copyWith(
                        color: Colors.white,
                      )),
              color: Colors.green,
              onPressed: () {
                setState(() {
                  _isUserPresent = true;
                });
                Navigator.of(context).pop();
              },
            )
          ],
        ).show();
      } else {
        Alert(
          context: context,
          type: AlertType.warning,
          title: "Oops!",
          desc: "Looks like you scanned an invalid QR",
          buttons: [
            DialogButton(
              child: Text("Dismiss",
                  style: Theme.of(context).textTheme.title.copyWith(
                        color: Colors.white,
                      )),
              color: Colors.blueGrey,
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ).show();
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
        _isLoading = false;
      });
    }
  }

  Future _navigateToRegistration(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RegistrationPage(),
        fullscreenDialog: true,
      ),
    );
    var user = await userCache.getUser(userCache.user.id, useCached: false);
    setState(() {
      _user = user;
    });
    _setUser(false);
  }

  Future _setUser(bool useCached) async {
    var user = await userCache.getUser(
      userCache.user.id,
      useCached: useCached,
    );
    setState(() {
      _user = user;
      _isUserPresent = user.isPresent;
      floatingButtonLabel = _user.isRegistered ? 'Scan QR' : 'Register';
      floatingButtonIcon =
          _user.isRegistered ? Icons.center_focus_weak : Icons.group_work;
    });
  }
}

class MessageBoard extends StatelessWidget {
  const MessageBoard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) => ListTile(
          title: Text('Announcement text'),
          subtitle: Text('Posted by ∙ 12 Jan'),
        ),
        itemCount: 5,
        separatorBuilder: (_, __) => Divider(),
    );
  }
}

class EventDetailPage extends StatelessWidget {
  final EventDetails event;

  const EventDetailPage(
    this.event, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Placeholder(
          fallbackHeight: 240,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            event.description,
            style: Theme.of(context).textTheme.subhead,
          ),
        ),
      ],
    );
  }
}
