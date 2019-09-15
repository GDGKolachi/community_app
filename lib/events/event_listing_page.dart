import 'package:flutter/material.dart';
import 'package:flutter_pk/events/event_detail_container.dart';
import 'package:flutter_pk/events/model.dart';
import 'package:flutter_pk/global.dart';
import 'package:flutter_pk/helpers/formatters.dart';
import 'package:flutter_pk/widgets/navigation_drawer.dart';

class EventListingPage extends StatelessWidget {
  final EventApi api = new EventApi();

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
      body: StreamBuilder<List<EventDetails>>(
        stream: api.events,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
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
    var eventTitleStyle = Theme.of(context).accentTextTheme.title;
    var eventLocationStyle = Theme.of(context).accentTextTheme.subtitle;
    var eventDateStyle =
        Theme.of(context).textTheme.title.copyWith(color: Colors.black45);
    var space = SizedBox(height: 8);

    return ListTile(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EventDetailContainer(),
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
              const EdgeInsets.only(left: 16, right: 16, top: 56, bottom: 8),
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
              RaisedButton(
                child: Text('REGISTER'),
                shape: StadiumBorder(),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}