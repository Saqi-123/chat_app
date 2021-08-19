import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_flutter/chat/chat.dart';
import 'package:sign_in_flutter/constants/constants.dart';
import 'package:sign_in_flutter/onboarding/username_selection.dart';
import 'package:sign_in_flutter/register_page.dart';
import 'package:sign_in_flutter/repositories/auth_repository.dart';
import 'package:sign_in_flutter/repositories/google_auth.dart';
import 'package:sign_in_flutter/widgets/custom_progress_bar.dart';
import 'package:sign_in_flutter/widgets/custom_text_field.dart';
import 'package:sign_in_flutter/widgets/loading_text.dart';
import 'package:sign_in_flutter/widgets/page_size.dart';
import 'package:flutter/cupertino.dart';
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
 
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _emailKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();
  FocusNode _emailFocus = FocusNode();
  FocusNode _passwordFocus = FocusNode();
  bool _canMoveNextPage = false;
  bool isLoading = false;
  final AuthRepository _authRepository = AuthRepository();
  User  user;
   @override
  void initState(){ 
    super.initState();
    ContextKeeper().init(context);
    _getUserId();
  }
  _getUserId() async {
     user = (await _authRepository.currentUser);
  }
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return CustomPageProgressBar(
          loadingText: LoadingText(
        textStyle: TextStyle(fontSize: 20),
      ));
    }
    return Scaffold(
      appBar: appBar,
      backgroundColor: ColorPickers.whiteColor,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: displayWidth(context),
            color: Colors.white,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _loginTitle(),
                  _signInWithGoogle(),
                  // _signInWithFacebook(),
                  SizedBox(height: 15),
                  _divider(),
                  SizedBox(height: 15),
                  _loginWithEmailAndPass(),
                  SizedBox(height: 15),
                  _loginButton(),
                  _forgotPassword(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Login Header
  Widget _loginTitle() {
    return Container(
      margin: EdgeInsets.only(left: 35, right: 35),
      child: Row(
        children: [
          Text(
            'Log In',
            style: login_title,
          ),
          SizedBox(width: 8),
          Container(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Text(
                    'Not yet registered?',
                    style: login_subTitle,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterPage()));
                      },
                      child: Text(
                        'Register now!',
                        style: register_now,
                      ))
                ],
              )),
        ],
      ),
    );
  }

// Login with Google....
  Widget _signInWithGoogle() {
    return Container(
      width: displayWidth(context),
      margin: EdgeInsets.only(left: 35, right: 35),
      child: OutlineButton(
        splashColor: Colors.grey,
        onPressed: () {
          _googleSignInTab();
        },
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.7)),
        highlightElevation: 0,
        borderSide: BorderSide(color: Colors.grey),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Images.google_image,
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text('Log in with Google', style: login_subTitle),
              )
            ],
          ),
        ),
      ),
    );
  }
// Divider...
  Widget _divider() {
    return Container(
        margin: EdgeInsets.only(left: 35, right: 35),
        child: Row(children: <Widget>[
          Expanded(
              child: Divider(
            color: ColorPickers.divider,
            thickness: 1,
          )),
          SizedBox(width: 15),
          Text(
            "Or",
            style: divider_text,
          ),
          SizedBox(width: 15),
          Expanded(
              child: Divider(
            color: ColorPickers.divider,
            thickness: 1,
          )),
        ]));
  }

// login with email and password....
  Widget _loginWithEmailAndPass() {
    return Container(
      margin: EdgeInsets.only(left: 35, right: 35),
      child: Column(
        children: [
          Align(alignment: Alignment.centerLeft, child: Text('Email', style: loginCredTitle,)),
          Form(
            key: _emailKey,
            child: CustomTextField(
              hintText: "Email",
              onChanged: (value) {
                _emailKey.currentState.validate();
                _isAllFieldsValidated();
              },
              onSubmit: (value) {
                if (_emailKey.currentState.validate()) {
                  _emailFocus.unfocus();
                }
                _isAllFieldsValidated();
              },
              validator: (String value) {
                if (value.trim().isEmpty) {
                  return "Please input your email";
                } else if (!EmailValidator.validate(value.trim())) {
                  return "Invalid Email";
                }
              },
              controller: _emailTextController,
              focusNode: _emailFocus, textFormatter: [],
            ),
          ),
          // SizedBox(height: 5),
          Align(alignment: Alignment.centerLeft, child: Text('Password', style: loginCredTitle,)),
          Form(
            key: _passwordKey,
            child: CustomTextField(
              hintText: "Password",
              onChanged: (value) {
                _passwordKey.currentState.validate();
                _isAllFieldsValidated();
              },
              onSubmit: (value) {
                if (_passwordKey.currentState.validate()) {
                  _passwordFocus.unfocus();
                }
                _isAllFieldsValidated();
              },
              validator: (String value) {
                if (value.trim().isEmpty) return "Please input your Password";
              },
              controller: _passwordTextController,
              focusNode: _passwordFocus, textFormatter: [],
            ),
          ),
        ],
      ),
    );
  }

// login Button
  Widget _loginButton() {
    return Container(
      margin: const EdgeInsets.only(left: 35, right: 35),
      child: RaisedButton(
  color: ColorPickers.buttonBg,
  shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
  textColor: Colors.white, // foreground
   onPressed: _canMoveNextPage ? () => _signInTab() : null,
  child: Text('Login', style: button_text),
  elevation: 0,
)
      
    );
  }

// Forgot Password...
  Widget _forgotPassword() {
    return Center(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '',
          style: login_subTitle,
        ),
        TextButton(
            onPressed: () {},
            child: Text(
              'Forgot your password?',
              style: register_now,
            ))
      ],
    ));
  }

  // Validate All Field....
  bool _isAllFieldsValidated() {
    setState(() {
      _canMoveNextPage =
          EmailValidator.validate(_emailTextController.text.trim()) &&
              _passwordTextController.text.trim() != null;
    });
    return _canMoveNextPage;
  }

  _signInTab() async{
    setState(() {
      isLoading = true;
    });
    try {
  UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
             email: _emailTextController.text, password: _passwordTextController.text
          ).then((value) => 
              value
          );
           setState(() {
              isLoading = false;
            });
          if (userCredential != null) {
            authWidget(userCredential.user.uid);
          }
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found' || e.code == 'wrong-password') {
            ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: ColorPickers.divider_text,
            content: Text(e.code.toString()),
            duration: const Duration(milliseconds: 2500),
            width: displayWidth(context),
            behavior: SnackBarBehavior.floating,
          ),
        );
        }
        setState(() {
              isLoading = false;
            });
  }
  }
  // Cheeck If User already store data in firestore ....
  authWidget(String uid) async{
    setState(() {
      isLoading = true;
    });
    await _authRepository.checkExist(uid).then((value){
      setState(() {
        isLoading = false;
      });
      if(value) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ChatScreen(), fullscreenDialog: true));
      }else {
         Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => UserNameSelection(), fullscreenDialog: true));
      }
    });
  }

  // Google SignIn Tab....
  _googleSignInTab() async{
    setState(() {
      isLoading = true;
    });
    final uid = await signInWithGoogle()
    .then((result) =>  result
    );
    setState(() {
      isLoading = false;
    });
     authWidget(uid);
  }
}
class ContextKeeper {
  static BuildContext buildContext;

  void init(BuildContext context) {
    buildContext = context;
  }
}
