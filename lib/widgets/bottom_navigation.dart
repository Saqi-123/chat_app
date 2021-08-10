import 'package:flutter/material.dart';
import 'package:sign_in_flutter/chat/chat.dart';
import 'package:sign_in_flutter/constants/constants.dart';
import 'package:sign_in_flutter/profile/profile.dart';
import 'package:sign_in_flutter/sendbird/create_channl_view.dart';
class BottomNavigation extends StatefulWidget {

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
// Selected Tab ....
  void _onItemTap(int index) {
  
    // setState(() {
    //   widget.selectedIndex = index;
    //   // _currentIndex = index;
    // });
    _navigateToScreen(index);
  }
  void _navigateToScreen(int indxxx) {
    print('chkecing INdex $indxxx');
     if (indxxx == 0) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
    }
    if (indxxx == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (builder) => CreateChannelView(bottomCheck: true)));
    }
    if (indxxx == 2) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
    }

  }
  @override
 Widget build(BuildContext context) {
    return Container(
      child: BottomNavigationBar(
        backgroundColor: ColorPickers.bottomNavigatorBackground,
        showSelectedLabels: false,
        showUnselectedLabels: false,
          items:[
            BottomNavigationBarItem(
                icon: Image.asset("assets/bottom_navigator_icon/home_icon.png",),
                label: '',
                activeIcon:new Image.asset("assets/bottom_navigator_icon/home_icon.png",)
                // backgroundColor: Colors.teal
            ),
            BottomNavigationBarItem(
              icon: Image.asset("assets/bottom_navigator_icon/add_icon.png",),
               label: '',
              activeIcon:new Image.asset("assets/bottom_navigator_icon/add_icon.png",)
            ),
             BottomNavigationBarItem(
              icon: Image.asset("assets/bottom_navigator_icon/person_icon.png",),
               label: '',
              activeIcon:new Image.asset("assets/bottom_navigator_icon/person_icon.png",)
            ),
          ],
          type: BottomNavigationBarType.fixed,
          // currentIndex: widget.selectedIndex ,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.red,
          iconSize: 25,
          onTap:  _onItemTap,
          elevation: 0
      ),
    );
  }
}