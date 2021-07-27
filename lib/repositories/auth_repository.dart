import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User user;
  Future<User> get currentUser async => _firebaseAuth.currentUser;
  Future<IdTokenResult> get idToken async =>
      await _firebaseAuth.currentUser.getIdTokenResult();

  /// Returns true if user is signed in
  // ignore: missing_return
  Future<User> isUserSignedIn() async {
    // await Firebase.initializeApp();
    try {
      user = _firebaseAuth.currentUser;
      return user;
    } on FirebaseAuthException catch (e) {
      print('exception $e');
    }
  }

  // Check if User Doucment Exist in Stroe.....
  Future<bool> checkExist(String docID) async {
    var exists;
    try {
      var checkUser = await _firestore.doc("user_data/$docID").get();
      if (checkUser.exists) {
          exists = true;
      }else {
          exists = false;
      }
      return exists;
    } catch (e) {
      return false;
    }
  }

  Future<bool> validatePassword(String currentPassword) async {
    var firebaseUser = await currentUser;
    var authCredential = EmailAuthProvider.credential(email: firebaseUser.email, password: currentPassword);
    try{
       var authResult = await firebaseUser.reauthenticateWithCredential(authCredential);
    return authResult != null;

    }catch(e) {
      print('error change password.. $e');
      return false;
    }
  }
}
