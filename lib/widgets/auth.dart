
import 'package:flutter/material.dart';
import 'package:sign_in_flutter/chat/chat.dart';
import 'package:sign_in_flutter/onboarding/username_selection.dart';
import 'package:sign_in_flutter/repositories/auth_repository.dart';
class AuthWidget extends StatefulWidget {

  @override
  _AuthWidgetState createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  final AuthRepository _authRepository = AuthRepository();
  String id;
  @override
  void initState() { 
    super.initState();
    _getUserId();
  }
  _getUserId() async {
    id = (await _authRepository.currentUser).uid;
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: _authRepository.checkExist(id),
        initialData: false,
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
              return ChatScreen();
            }else{
              return UserNameSelection();
            } 
        });
  }
}
