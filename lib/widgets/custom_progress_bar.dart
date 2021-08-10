import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sign_in_flutter/widgets/page_size.dart';

import 'loading_text.dart';

class CustomPageProgressBar extends StatelessWidget {
  final LoadingText loadingText;

  CustomPageProgressBar({@required this.loadingText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: displayWidth(context),
        height: displayHeight(context),
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: loadingText,
            ),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
