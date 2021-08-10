import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:sign_in_flutter/account_setting/setting.dart';
import 'package:sign_in_flutter/constants/constants.dart';
import 'package:sign_in_flutter/repositories/auth_repository.dart';
import 'package:sign_in_flutter/repositories/google_auth.dart';
import 'package:sign_in_flutter/repositories/rest_repository.dart';
import 'package:sign_in_flutter/widgets/bottom_navigation.dart';
import 'package:sign_in_flutter/widgets/custom_progress_bar.dart';
import 'package:sign_in_flutter/widgets/loading_text.dart';
import 'package:sign_in_flutter/widgets/page_size.dart';
import 'package:sign_in_flutter/widgets/web_view_container.dart';

import '../login_page.dart';
class GuestProfile extends StatefulWidget {
  final String uuid;
  final bool bottomCheck;
  GuestProfile({this.uuid, this.bottomCheck = false});

  @override
  _GuestProfileState createState() => _GuestProfileState();
}

class _GuestProfileState extends State<GuestProfile> {
  final RestRepository restRepository = RestRepository();
  final AuthRepository _authRepository = AuthRepository();
  
   var response;
  User user;
   bool isLoading = true;
   int following;
   int follow;
   bool isAlreadyFollows = false;
  @override
  void initState() { 
    super.initState();
    _getUserProfile();
  }
  // Get Use Profile Record .....
  _getUserProfile() async {
    user = await _authRepository.currentUser;
    final data = await restRepository.getUserData(uid: widget.uuid);
    final followingSectionRecord = await restRepository.fetchFollowsSection(widget.uuid);
    final isAlreadyFollow = await restRepository.isAlreadyFollowTheUser(widget.uuid, user.uid);
    setState(() {
      response = data;
      isLoading= false;
      following = followingSectionRecord[0]['following'];
      follow = followingSectionRecord[1]['follow'];
      isAlreadyFollows = isAlreadyFollow ?? false ;
    });
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
      backgroundColor: ColorPickers.whiteColor,
      appBar: AppBar(
      title: Text("Profile Page",style: header_title,),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: ColorPickers.buttonBg),
        onPressed: () => Navigator.of(context).pop(),
      ),
      backgroundColor: ColorPickers.whiteColor,
      elevation: 0,
    ),
      bottomNavigationBar: widget.bottomCheck ? null : BottomNavigation(),
      body: SafeArea(
        child: Container(
          
            child: Column(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            _imageWidget(context),
            _userSection(context),
            _followSection(context),
             response?.bio != null ? _bioWidget(context) : Container(),
             response?.tags != null ? _tagSection(context): Container(),
            SizedBox(height: 5),
            response?.link != null ? _linkWidget(context) : Container(),
            _buttonWidget(context)
              ],
            ),
      ),
    ),
    );
  }
  // Build APPBAR
  Widget _buildAppbar() {
    return AppBar(
      title: Text("Profile Page",style: header_title,),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: ColorPickers.buttonBg),
        onPressed: () => Navigator.of(context).pop(),
      ),
       actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Logout', 'Settings'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
           child: Image.asset('assets/setting_icon.png'),
          ),
        ],
      backgroundColor: ColorPickers.whiteColor,
      elevation: 0,
    );
  }
  void handleClick(String value) {
    switch (value) {
      case 'Logout':
      signOutGoogle();
                  Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => LoginPage(), fullscreenDialog: true));
        break;
      case 'Settings':
      Navigator.push(context, MaterialPageRoute(builder: (context) => SettingPage()));
        break;
    }
}
  Widget _imageWidget(BuildContext context) {
    return Container(
               width: 137,
               height: 130,
              margin: EdgeInsets.only(left: 5, right: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.7),
                border: Border.all(color: ColorPickers.blackColor),
              ),
            child: ClipRRect(
               borderRadius: BorderRadius.circular(10.7),
              child: FadeInImage.assetNetwork(
                    placeholder: cupertinoActivityIndicatorSmall,
                    image: response.image,
                    fit: BoxFit.fill,
                  ),
            ),
    );
  }
  Widget _userSection(BuildContext context) {
   return Container(
      child: Column(
        children: [
          Text(response?.name, style: profile_name,),
          Text('${response?.username}', style: profile_username,)
        ],
      ),
    );
  }
  Widget _followSection(BuildContext context) {
   return Container(
     color: ColorPickers.followerSectionBg,
     padding: EdgeInsets.only(top: 10, bottom:10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
         Column(
           children: [
             Text(following.toString(),style: follow_title,),
             Text('following', style: follow_sub_title,)
           ],
         ),
         Column(
           children: [
             Text(follow.toString() == 'null' ? '0' :follow.toString() , style: follow_title,),
             Text('followers', style: follow_sub_title,)
           ],
         ),
         Column(
           children: [
             Text('0',style: follow_title,),
             Text('kudos', style: follow_sub_title,)
           ],
         ),
        ],

      ),
    );
  }
   Widget _bioWidget(BuildContext context) {
   return Container(
     alignment: Alignment.center,
     margin: EdgeInsets.only(left: 35, right: 35),
      child: Text(response.bio,
      style: bio_text,textAlign: TextAlign.justify,),
    );
  }
   Widget _tagSection(BuildContext context) {
   return Container(
     margin: EdgeInsets.only(left: 35, right: 35),
       height: 40,
       width: displayWidth(context),
           child : Center(
             child: Wrap(
          children: List.generate(
              response.tags.length,
              (index) {
                return Container(
                  width: 60,
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.only(left: 5,top: 10),
                  decoration: BoxDecoration(
                    color: ColorPickers.tagsBg,
                      borderRadius: BorderRadius.circular(10.7),
                    ),
                  child: Center( child: Text(response.tags[index], style: tagTitle,)),
                );
              },
          ),
        ),
           ),
   );
  }
  Widget _linkWidget(BuildContext context) {
   return Container(
     child: new RichText(
            text: new TextSpan(
              children: [
                new TextSpan(
                  text: '',
                  style: new TextStyle(color: Colors.black),
                ),
                new TextSpan(
                  text: response.link,
                  style: new TextStyle(color: Colors.blue),
                  recognizer: new TapGestureRecognizer()
                    ..onTap = () {Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WebViewContainer(response.link)));
                  },
                ),
              ],
            ),
     ),
    );
  }
  Widget _buttonWidget(BuildContext context) {
   return Container(
      child: RaisedButton(
  color: ColorPickers.buttonBg,
  shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
  textColor: Colors.white, // foreground
  onPressed: () {
    _followingSection();
   },
  child: Text(isAlreadyFollows ? 'UnFollow' : 'Follow',style: button_text,),
  elevation: 0,
)

    );
  }
  // Following Section
_followingSection() async{
   var response;
  setState(() {
    isLoading = true;
  });
   if (isAlreadyFollows) {
     response = await restRepository.unFollowUser(widget.uuid, user.uid);
   } else {
     response = await restRepository.addFollowing(widget.uuid, user.uid);
   }
   if (response == "update success!") {
     _getUserProfile();
    //  setState(() {
    //    isLoading = false;
    //  });
   }
}
}
