import 'package:flutter/material.dart';
import 'package:sign_in_flutter/constants/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewContainer extends StatefulWidget {
  final url;

  WebViewContainer(this.url);

  @override
  createState() => _WebViewContainerState(this.url);
}

class _WebViewContainerState extends State<WebViewContainer> {
  var _url;

  _WebViewContainerState(this._url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text("HayHay",style: header_title,),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: ColorPickers.buttonBg),
        onPressed: () => Navigator.of(context).pop(),
      ),
      backgroundColor: ColorPickers.whiteColor,
      elevation: 0,
    ),
        body: Column(
          children: [
            Expanded(
                child: WebView(
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: _url))
          ],
        ));
  }
}
