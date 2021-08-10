import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
String email;
// ignore: missing_return
Future<String> signInWithEmailAndPass(String email, String pass) async {
  // await Firebase.initializeApp();
  try {
    final UserCredential authResult =
        await _auth.signInWithEmailAndPassword(email: email, password: pass);
    final User user = authResult.user;

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);

      return '${user.uid}';
    }

    return null;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      return e.code;

    } else if (e.code == 'wrong-password') {
      return e.code;
    }
  }
}

// For Create Account...
// ignore: missing_return
Future<String> registerWithEmailAndPass(String email, String pass) async {
  // await Firebase.initializeApp();
  try {
    final UserCredential authResult = await _auth
        .createUserWithEmailAndPassword(email: email, password: pass);
    final User user = authResult.user;
    if (user != null) {
      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);


      return '${user.email}';
    }

    return null;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      return e.code;
    } else if (e.code == 'email-already-in-use') {
      return e.code;
    }
  }
}
