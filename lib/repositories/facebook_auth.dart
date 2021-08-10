// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:firebase_core/firebase_core.dart';
// // import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

// // final FirebaseAuth _auth = FirebaseAuth.instance;
// // final FacebookAuth facebookSignIn = FacebookAuth.instance;

// // // final GoogleSignIn googleSignIn = GoogleSignIn();

// // String name;
// // String email;
// // String imageUrl;

// // Future<UserCredential> signInWithFacebook() async {
// //   await Firebase.initializeApp();
// //   final AccessToken result = await facebookSignIn.login();

// //    // Create a credential from the access token
// //   final facebookAuthCredential = FacebookAuthProvider.credential(result.token);

// //   // final UserCredential authResult =
// //      return await _auth.signInWithCredential(facebookAuthCredential);
// //   // final User user = authResult.user;

// //   // if (user != null) {
// //   //   // Checking if email and name is null
// //   //   assert(user.email != null);
// //   //   assert(user.displayName != null);
// //   //   assert(user.photoURL != null);

// //   //   name = user.displayName;
// //   //   email = user.email;
// //   //   imageUrl = user.photoURL;

// //   //   // Only taking the first part of the name, i.e., First Name
// //   //   if (name.contains(" ")) {
// //   //     name = name.substring(0, name.indexOf(" "));
// //   //   }

// //   //   assert(!user.isAnonymous);
// //   //   assert(await user.getIdToken() != null);

// //   //   final User currentUser = _auth.currentUser;
// //   //   assert(user.uid == currentUser.uid);

// //   //   print('signInwithFacebook succeeded: $user');

// //   //   return '$user';
// //   // }

// //   // return null;
// // }

// // Future<void> signOutGoogle() async {
// //   await _auth.signOut();
// //   print("User Signed Out");
// // }

// import 'dart:async';
// import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter_login_facebook/flutter_login_facebook.dart';

// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
// final FirebaseAuth _auth = FirebaseAuth.instance;
// final FacebookLogin facebookSignIn = new FacebookLogin();
// Future<Null> signInWithFacebook() async {
//     final FacebookLoginResult result =
//         await facebookSignIn.logInWithReadPermissions(['email']);

//     switch (result.status) {
//       case FacebookLoginStatus.loggedIn:
//         final FacebookAccessToken accessToken = result.accessToken;
//         _showMessage('''
//          Logged in!
//          Token: ${accessToken.token}
//          User id: ${accessToken.userId}
//          Expires: ${accessToken.expires}
//          Permissions: ${accessToken.permissions}
//          Declined permissions: ${accessToken.declinedPermissions}
//          ''');
//         break;
//       case FacebookLoginStatus.cancelledByUser:
//         _showMessage('Login cancelled by the user.');
//         break;
//       case FacebookLoginStatus.error:
//         _showMessage('Something went wrong with the login process.\n'
//             'Here\'s the error Facebook gave us: ${result.errorMessage}');
//         break;
//     }
//   }
//   void _showMessage(String message) {
//     print('chekig ---- message $message');
//     // setState(() {
//     //   _message = message;
//     // });
//   }
