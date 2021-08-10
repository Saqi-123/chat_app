import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sendbird_sdk/sdk/sendbird_sdk_api.dart';
import 'package:sign_in_flutter/repositories/auth_repository.dart';
import 'package:sign_in_flutter/sendbird/channel_list_view.dart';
import 'package:sign_in_flutter/sendbird/create_channl_view.dart';
import 'package:sign_in_flutter/sendbird/login_view.dart';
import 'package:sign_in_flutter/widgets/bottom_navigation.dart';
class ChatScreen extends StatefulWidget {
  ChatScreen({Key key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
   final sendbird = SendbirdSdk(appId: '28A97237-32B3-4FA8-A220-2A9B8BB17026');
  final AuthRepository _authRepository = AuthRepository();
  var uuid;
  @override
  void initState() { 
    super.initState();
    _gettingCurrentUser();

  }
  _gettingCurrentUser() async {
     User user = await _authRepository.currentUser;
     setState(() {
       uuid = user.uid;
     });
  }
 Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigation(),
      // body: Container(
      //   child: _connectToSendbirdServer()
      // ),
      body: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sendbird Demo',
        initialRoute: "/login",
        routes: <String, WidgetBuilder>{
          '/login': (context) => LoginView(),
          '/channel_list': (context) => ChannelListView(),
          '/create_channel': (context) => CreateChannelView(),
        },
        theme: ThemeData(
            fontFamily: "Gellix",
            primaryColor: Color(0xff742DDD),
            buttonColor: Color(0xff742DDD),
            textTheme: TextTheme(
                headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
                headline6:
                    TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold)),
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: Color(0xff732cdd),
              selectionHandleColor: Color(0xff732cdd),
              selectionColor: Color(0xffD1BAF4),
            )),
      ),
    );
  }
}
