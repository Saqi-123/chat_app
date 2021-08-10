import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_flutter/constants/constants.dart';
import 'package:sign_in_flutter/repositories/email_pass_auth.dart';
// import 'package:sign_in_flutter/repositories/facebook_auth.dart';
import 'package:sign_in_flutter/repositories/google_auth.dart';
import 'package:sign_in_flutter/widgets/custom_progress_bar.dart';
import 'package:sign_in_flutter/widgets/custom_text_field.dart';
import 'package:sign_in_flutter/widgets/loading_text.dart';
import 'package:sign_in_flutter/widgets/page_size.dart';
import 'onboarding/username_selection.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPage createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _emailKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();
  FocusNode _emailFocus = FocusNode();
  FocusNode _passwordFocus = FocusNode();
  bool _canMoveNextPage = false;
  bool isLoading = false;
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
      body: SafeArea(
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Login Header
  Widget _loginTitle() {
    return Container(
      margin: EdgeInsets.only(left: 30),
      child: Center(
        child: Row(
          children: [
            Text(
              'Join',
              style: login_title,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Container(
                  padding: EdgeInsets.only(top: 10),
                  child: Center(
                    child: Row(
                      children: [
                        Text(
                          'Already have an account?',
                          style: login_subTitle,
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Center(
                              child: Text(
                                'Log in here!',
                                style: register_now,
                              ),
                            ))
                      ],
                    ),
                  )),
            ),
          ],
        ),
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
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text('Join with Google', style: login_button),
              )
            ],
          ),
        ),
      ),
    );
  }
  // Login with Facebook ...
  // Widget _signInWithFacebook() {
  //   return Container(
  //     width: displayWidth(context),
  //     margin: EdgeInsets.only(left: 35, right: 35),
  //     child: OutlineButton(
  //       splashColor: Colors.grey,
  //       onPressed: () {
  //         signInWithFacebook().then((result) {
  //           if (result != null) {
  //             Navigator.of(context).push(
  //               MaterialPageRoute(
  //                 builder: (context) {
  //                   return FirstScreen();
  //                 },
  //               ),
  //             );
  //           }
  //         });
  //       },
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.7)),
  //       highlightElevation: 0,
  //       borderSide: BorderSide(color: Colors.grey),
  //       child: Padding(
  //         padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
  //         child: Row(
  //           mainAxisSize: MainAxisSize.min,
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: <Widget>[
  //             // Images.google_image,
  //             Padding(
  //               padding: const EdgeInsets.only(left: 10),
  //               child: Text(
  //                 'Login with Facebook',
  //                 style: login_button
  //               ),
  //             )
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
        child: Text('Join now', style: button_text),
      elevation: 0,
)
      
    );
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

  // SignIn Tab .....
  _signInTab() {
    setState(() {
      isLoading = true;
    });
    registerWithEmailAndPass(
            _emailTextController.text, _passwordTextController.text)
        .then((result) {
      setState(() {
        isLoading = false;
      });
      if (result == 'The password provided is too weak.' ||
          result == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: ColorPickers.divider_text,
            content: Text(result.toString()),
            duration: const Duration(milliseconds: 2500),
            width: displayWidth(context),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else if (result != null) {
       Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) {
          return UserNameSelection();
        }), ModalRoute.withName('/'));
      }
    });
  }

  // Google SignIn Tab....
  _googleSignInTab() {
    setState(() {
      isLoading = true;
    });
    signInWithGoogle().then((result) {
      setState(() {
        isLoading = false;
      });
      if (result != null) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) {
          return UserNameSelection();
        }), ModalRoute.withName('/'));
      }
    });
  }
}
