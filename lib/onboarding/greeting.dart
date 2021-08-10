import 'package:flutter/material.dart';
import 'package:sign_in_flutter/chat/chat.dart';
import 'package:sign_in_flutter/constants/constants.dart';

class GreetingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPickers.whiteColor,
      appBar: appBar,
      body: Container(
        margin: EdgeInsets.only(right: 35, left: 35),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _headerTitle(),
              SizedBox(height: 50),
              _buttonWidget(context),
            ],
          ),
        ),
      ),
    );
  }

  // Header Title....
  Widget _headerTitle() {
    return Container(
      child: Column(
        children: [
          Text("Great You${'re'} all done.",style: bodyTitle,),
          Text("May we chooose a",style: bodyTitle,),
          Text('chatroom for you?',style: bodyTitle,)
        ],
      ),);
  }
   Widget _buttonWidget(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
          child: Column(
            children: [
              RaisedButton(
        onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ChatScreen(), fullscreenDialog: true));
        },
        color: ColorPickers.buttonBg,
        child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Okay!',
                style: button_text,
              ),
        ),
        elevation: 0,
        shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.7),),
      ),
      _mayBeLaterButton(context)
            ],
          )),
    );
  }

  Widget _mayBeLaterButton(BuildContext context) {
    return Container(
      child: TextButton(
          onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ChatScreen(), fullscreenDialog: true));
              },
          child: Text(
            'No thanks, I’ll find one myself.',
            style: greetingDescription,
          )),
    );
  }
}
