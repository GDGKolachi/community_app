import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_pk/profile/model.dart';

class UserCache {
  User _user;

  User get user => _user;

  Future<User> getUser(String id, {bool useCached = true}) async {
    if (_user != null && useCached) {
      return _user;
    }
    _user = User.fromSnapshot(
        await Firestore.instance.collection('users').document(id).get());
    return _user;
  }

  void clear() => _user = null;
}