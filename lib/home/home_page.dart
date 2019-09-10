import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pk/global.dart';
import 'package:flutter_pk/helpers/formatters.dart';
import 'package:flutter_pk/home/home_master.dart';
import 'package:flutter_pk/profile/profile_dialog.dart';
import 'package:flutter_pk/venue_model.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                userCache.user.photoUrl,
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: NavigationDrawerItems(),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection(FireStoreKeys.eventCollection)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          var events = snapshot.data.documents
              .map((doc) {
                return EventDetails.fromSnapshot(doc);
              })
              .toList();
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (_, index) => EventListItem(events[index]),
          );
        },
      ),
    );
  }
}

class EventListItem extends StatelessWidget {
  final EventDetails event;

  EventListItem(this.event);

  @override
  Widget build(BuildContext context) {
    var eventTitleStyle = Theme.of(context).accentTextTheme.title;
    var eventLocationStyle = Theme.of(context).accentTextTheme.subtitle;
    var eventDateStyle =
        Theme.of(context).textTheme.title.copyWith(color: Colors.black45);
    var capsuleTextStyle = Theme.of(context).accentTextTheme.overline;
    var space = SizedBox(height: 8);

    return ListTile(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => HomePageMaster(),
        ),
      ),
      leading: Text(
        formatDate(event.date, 'MMM\ndd').toUpperCase(),
        textAlign: TextAlign.center,
        style: eventDateStyle,
      ),
      title: Card(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            image: DecorationImage(
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
              image: NetworkImage(event.bannerUrl),
            ),
          ),
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 40, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                event.eventTitle,
                style: eventTitleStyle,
              ),
              space,
              Text(
                '${event.venue.title}, ${event.venue.city}',
                style: eventLocationStyle,
              ),
              space,
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                child: Text('REGISTERED', style: capsuleTextStyle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavigationDrawerItems extends StatelessWidget {
  const NavigationDrawerItems({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        DrawerHeader(
          child: Image.asset('assets/gdg_kolachi.png'),
        ),
        _buildNavItem(
          context,
          Icons.home,
          'Home',
        ),
        _buildNavItem(
          context,
          Icons.event,
          'Events',
        ),
        _buildNavItem(
          context,
          Icons.info,
          'About',
        ),
        _buildNavItem(
          context,
          Icons.notifications,
          'Notifications',
        ),
        _buildNavItem(
          context,
          Icons.person,
          'My profile',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FullScreenProfileDialog(),
              fullscreenDialog: true,
            ),
          ),
        ),
        _buildNavItem(
          context,
          Icons.exit_to_app,
          'Log out',
        ),
      ],
    );
  }

  ListTile _buildNavItem(BuildContext context, IconData icon, String title,
      {VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        if (onTap != null) onTap();
      },
    );
  }
}
