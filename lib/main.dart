import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_flutter/repositories/auth_repository.dart';
import 'package:sign_in_flutter/widgets/auth.dart';

import 'login_page.dart';

// void main() => runApp(MyApp());
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
 class MyApp extends StatefulWidget {
 
   @override
   _MyAppState createState() => _MyAppState();
 }
 
 class _MyAppState extends State<MyApp> {
   final AuthRepository _authRepository = AuthRepository();
   User user;
   var uid;
   void initState() {
    super.initState();
    checkUserSignIn();
  }
    @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _buildSession() 
    );
  }
  // Check User already Logged in ....
  checkUserSignIn() async {
    User user = await _authRepository.isUserSignedIn();
    setState(() {
      uid = user.uid;
      user = user;
    });
  }

  _buildSession() {
    if(uid == null) return  LoginPage();
    return AuthWidget();
  }

 }

