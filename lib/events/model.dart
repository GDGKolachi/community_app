import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_pk/global.dart';
import 'package:flutter_pk/helpers/formatters.dart';

class EventApi {
  Stream<List<EventDetails>> get events => Firestore.instance
      .collection(FireStoreKeys.eventCollection)
      .where('date',
          isGreaterThanOrEqualTo: DateTime.now().add(Duration(days: -1)))
      .orderBy('date')
      .snapshots()
      .asyncMap<List<EventDetails>>((snapshot) => snapshot.documents
          .map((doc) => EventDetails.fromSnapshot(doc))
          .toList());
}

abstract class RegistrationStates {
  static const String defaultState = undefined;
  static const String undefined = 'UNDEFINED';
  static const String registered = 'REGISTERED';
  static const String shortlisted = 'SHORTLISTED';
  static const String cancelled = 'CANCELLED';
  static const String confirmed = 'CONFIRMED';
}

class EventDetails {
  final DateTime date;
  final String eventTitle;
  final Venue venue;
  final String id;
  final String bannerUrl;
  final String registrationStatus;
  final Map registrations;
  final String description;

  EventDetails({
    this.eventTitle,
    this.venue,
    this.id,
    this.date,
    this.bannerUrl,
    this.description,
    this.registrationStatus = RegistrationStates.undefined,
    this.registrations
  });

  String get formattedDate => formatDate(
        this.date,
        DateFormats.shortUiDateFormat,
      );

  EventDetails.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, id: snapshot.reference.documentID);

  EventDetails.fromMap(Map<String, dynamic> map, {this.id})
      : eventTitle = map['eventTitle'],
        date = (map['date'] as Timestamp).toDate(),
        bannerUrl = map['bannerUrl'],
        registrations = map['registrations'],
        registrationStatus = _findRegistrationStatus(map['registrations']),
        venue = Venue.fromMap(map['venue']),
        description = "Event description";

  static String _findRegistrationStatus(Map registrations) =>
      registrations != null && registrations[userCache.user.id] != null
          ? registrations[userCache.user.id]
          : RegistrationStates.defaultState;
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
