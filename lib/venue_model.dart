import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_pk/helpers/formatters.dart';

class EventDetails {
  final DateTime date;
  final String eventTitle;
  final Venue venue;
  final DocumentReference reference;
  final String bannerUrl;

  EventDetails({
    this.eventTitle,
    this.venue,
    this.reference,
    this.date,
    this.bannerUrl,
  });

  String get formattedDate => formatDate(
          this.date,
          DateFormats.shortUiDateFormat,
        );

  EventDetails.fromMap(Map<String, dynamic> map, {this.reference})
      : eventTitle = map['eventTitle'],
        date = (map['date'] as Timestamp).toDate(),
        bannerUrl = 'https://images.pexels.com/photos/2342400/pexels-photo-2342400.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
        venue = Venue.fromMap(map['venue']);

  EventDetails.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}

class Venue {
  final String title;
  final String address;
  final String city;
  final String imageUrl;
  final Location location;
  final DocumentReference reference;

  Venue({
    this.address,
    this.title,
    this.imageUrl,
    this.location,
    this.city,
    this.reference,
  });

  Venue.fromMap(Map map, {this.reference})
      : title = map['title'],
        address = map['address'],
        city = map['city'],
        imageUrl = map['imageUrl'],
        location = Location.fromMap(map['location']);

  Venue.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}

class Location {
  final double latitude;
  final double longitude;
  final DocumentReference reference;

  Location({
    this.latitude,
    this.longitude,
    this.reference,
  });

  Location.fromMap(Map map, {this.reference})
      : latitude = map['latitude'],
        longitude = map['longitude'];

  Location.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}
