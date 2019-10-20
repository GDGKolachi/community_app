import 'package:flutter/material.dart';
import 'package:flutter_pk/events/event_detail_container.dart';
import 'package:flutter_pk/events/model.dart';
import 'package:flutter_pk/global.dart';
import 'package:flutter_pk/helpers/formatters.dart';
import 'package:flutter_pk/profile/profile_dialog.dart';
import 'package:flutter_pk/registration/model.dart';
import 'package:flutter_pk/registration/registration_action.dart';
import 'package:flutter_pk/theme.dart';
import 'package:flutter_pk/util.dart';
import 'package:flutter_pk/widgets/animated_progress_indicator.dart';
import 'package:flutter_pk/widgets/navigation_drawer.dart';

class EventListingPage extends StatelessWidget {
  final EventBloc bloc = new EventBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
        actions: <Widget>[
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  userCache.user.photoUrl,
                ),
              ),
            ),
            onTap: () => Navigator.push(context, FullScreenProfileDialog.route),
          ),
        ],
      ),
      drawer: Drawer(
        child: NavigationDrawerItems(),
      ),
      body: StreamBuilder<List<EventDetails>>(
        stream: bloc.events,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return AnimatedProgressIndicator();
          }

          var events = snapshot.data;
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
    var imageHeight = calculateImageHeight(
      MediaQuery.of(context).size.width - 88,
    );

    var eventDateStyle =
        Theme.of(context).textTheme.title.copyWith(color: Colors.black45);

    var date = Text(
      formatDate(event.date, 'MMM\ndd').toUpperCase(),
      textAlign: TextAlign.center,
      style: eventDateStyle,
    );

    var userRegistrationStatus = event.registrationStatus.toUpperCase();
    userRegistrationStatus =
        userRegistrationStatus == RegistrationStates.undefined
            ? 'UNREGISTERED'
            : userRegistrationStatus;

    var registrationStatusBadge = Align(
      alignment: Alignment.topRight,
      child: Card(
        margin: EdgeInsets.only(top: 16),
        color: Colors.green,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(kCardBorderRadius * 2),
            bottomLeft: Radius.circular(kCardBorderRadius * 2),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          child: Text(
            userRegistrationStatus,
            style: Theme.of(context).accentTextTheme.button,
          ),
        ),
      ),
    );

    var card = Expanded(
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: 'banner_${event.id}',
              child: Container(
                height: imageHeight,
                decoration: BoxDecoration(
                  color: Theme.of(context).hintColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(kCardBorderRadius),
                      topRight: Radius.circular(kCardBorderRadius)),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(event.bannerUrl),
                  ),
                ),
                child: FeatureFlags.eventRegistration ? registrationStatusBadge :  null,
              ),
            ),
            ListTile(
              title: Text(event.eventTitle),
              subtitle: Text('${event.venue.title}, ${event.venue.city}'),
              trailing:
                  FeatureFlags.eventRegistration && event.isRegistrationOpen ? RegistrationAction(event) : null,
            ),
          ],
        ),
      ),
    );

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EventDetailContainer(event),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            date,
            SizedBox(width: 16),
            card,
          ],
        ),
      ),
    );
  }
}
