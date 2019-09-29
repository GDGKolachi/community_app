import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_pk/caches/user.dart';
import 'package:flutter_pk/global.dart';
import 'package:flutter_pk/helpers/formatters.dart';

class MessageBloc {
  Stream<List<Message>> getMessages(String eventId) => Firestore.instance
      .collection(
          '${FireStoreKeys.eventCollection}/$eventId/${FireStoreKeys.messageCollection}')
      .orderBy('date', descending: true)
      .snapshots()
      .asyncMap<List<Message>>((snapshot) =>
          snapshot.documents.map((doc) => Message.fromSnapshot(doc)).toList());
}

class Message {
  final String id;
  final DateTime date;
  final String text;
  final User user;

  Message({this.id, this.date, this.text, this.user});

  String get formattedDate => formatDate(
        this.date,
        DateFormats.shortUiDateTimeFormat,
      );

  Message.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, id: snapshot.reference.documentID);

  Message.fromMap(Map<String, dynamic> map, {this.id})
      : date = (map['date'] as Timestamp).toDate(),
        text = map['text'],
        user = User.fromMap(map['user']);
}
