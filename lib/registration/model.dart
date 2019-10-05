import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_pk/caches/user.dart';
import 'package:flutter_pk/global.dart';

class RegistrationService {
  Future updateStatus(String eventId, User user, String status) async {
    var reference = Firestore.instance
        .collection(FireStoreKeys.eventCollection)
        .document(eventId);

    Firestore.instance.runTransaction((tx) async {
      var eventSnapshot = await reference.get();

      if (eventSnapshot.data['registrations'] == null) {
        eventSnapshot.data['registrations'] = <String, dynamic>{};
      }

      var registration = user.toJson()..['status'] = status;
      eventSnapshot.data['registrations'][user.id] = registration;
      await tx.update(reference, <String, dynamic>{
        'registrations': eventSnapshot.data['registrations'],
      });
    });
  }
}

abstract class RegistrationStates {
  static const String defaultState = undefined;
  static const String undefined = 'UNDEFINED';
  static const String registered = 'REGISTERED';
  static const String shortlisted = 'SHORTLISTED';
  static const String cancelled = 'CANCELLED';
  static const String confirmed = 'CONFIRMED';
}
