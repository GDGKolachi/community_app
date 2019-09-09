import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_pk/caches/user.dart';
import 'package:flutter_pk/global.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginApi {
  Future<String> initiateLogin() async {
    GoogleSignInAuthentication googleAuth = await _handleGoogleSignIn();

    var credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    var user = (await auth.signInWithCredential(credential)).user;

    await _setUserToFireStore(user);

    return user.uid;
  }

  Future _setUserToFireStore(FirebaseUser user) async {
    CollectionReference reference =
        Firestore.instance.collection(FireStoreKeys.userCollection);

    var snapshot = await reference.document(user.uid).get();
    if (!snapshot.exists) {
      var appUser = User(
          name: user.displayName,
          mobileNumber: user.phoneNumber,
          id: user.uid,
          photoUrl: user.photoUrl,
          email: user.email);
      await reference.document(user.uid).setData(appUser.toJson(), merge: true);
    }
  }

  Future<GoogleSignInAuthentication> _handleGoogleSignIn() async {
    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    return googleAuth;
  }

  initialize() {
    Firestore.instance.settings(
      timestampsInSnapshotsEnabled: true,
    );
  }
}
