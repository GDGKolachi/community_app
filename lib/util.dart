import 'package:cloud_firestore/cloud_firestore.dart';

DateTime toDateTime(Timestamp timestamp) => timestamp.toDate();

double calculateImageHeight(double width) => width / 1.77;