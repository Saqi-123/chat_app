import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class ColorPickers {
  static const Color blackColor = Color(0xFF000000);
  static const Color divider = Color(0xFF787878);
  static const Color divider_text = Color(0xFFACACAC);
  static const Color whiteColor = Colors.white;
  static const Color darkGreyColor = Color(0xff212121);
  static const Color mainAccentColor = Color(0xfffbb040);
  static const Color textHintColor = Colors.grey;
  static const Color validTextBorderColor = Colors.lightGreen;
  static const Color registerNow = Color(0xFF415FFF);
  static const Color appbarColor = Color(0xFF008457);
  static const Color greetingColor = Color(0xFFFFAB40);
  static const Color bottomNavigatorBackground = Color(0xFF008457);
  static const Color followerSectionBg = Color(0xFFFFE7CA);
  static const Color buttonBg = Color(0xFFFFAB40);
  static const Color tagsBg = Color(0xFFC4C4C4); 
  static const Color activeTag = Color(0xFF008457);
  static const Color drwaerBg = Color(0xFF262626);
}

final greenButtonStyle = ButtonStyle(
    padding: MaterialStateProperty.all(EdgeInsets.all(15)),
    backgroundColor:
        MaterialStateProperty.all(ColorPickers.validTextBorderColor),
    textStyle: MaterialStateProperty.all(TextStyle(
        fontWeight: FontWeight.w900, color: ColorPickers.whiteColor)));
final disabledButtonStyle = ButtonStyle(
    padding: MaterialStateProperty.all(EdgeInsets.all(14)),
    backgroundColor: MaterialStateProperty.all(ColorPickers.whiteColor),
    textStyle: MaterialStateProperty.all(TextStyle(
        fontWeight: FontWeight.w900, color: ColorPickers.darkGreyColor)));

final appBar = AppBar(
  backgroundColor: ColorPickers.whiteColor,
   elevation: 0,
   title: Align(
     alignment: Alignment.topLeft,
     child: Container(
       margin: EdgeInsets.only(left: 5),
       child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 15),
                        child: Image.asset(
                     'assets/app_bar/logo_icon.png',
                        fit: BoxFit.cover,
                        // height: 45,
                  ),
                      ),
                  Container(
                      child: Image.asset('assets/app_bar/logo_title.png'))
                ],

              ),
     ),
   ),
   centerTitle: false,
   automaticallyImplyLeading: false,
  // titleSpacing: 30.0,
);
final showToast =  Fluttertoast.showToast(
        msg: 'Change Password Successfully',
        toastLength: Toast.LENGTH_LONG,
         gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: ColorPickers.blackColor,
        textColor: Colors.white,
        fontSize: 16.0
    );
const login_button = TextStyle(
    fontWeight: FontWeight.w600, fontSize: 13, color: ColorPickers.blackColor);
const divider_text = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 18,
    color: ColorPickers.divider_text);
var login_title = GoogleFonts.montserrat(
  textStyle:  TextStyle(
    fontWeight: FontWeight.bold, fontSize: 24, color: ColorPickers.blackColor,)
);
var drawerHeaderStyle = GoogleFonts.montserrat(
  textStyle:  TextStyle(
    fontWeight: FontWeight.bold, fontSize: 18, color: ColorPickers.whiteColor,)
);
var drawerSubHeader = GoogleFonts.montserratAlternates(
  textStyle: TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 13,
    color: ColorPickers.whiteColor)
);
var header_title = GoogleFonts.montserrat(
  textStyle: TextStyle(
    fontWeight: FontWeight.bold, fontSize: 18, color: ColorPickers.blackColor)
);
var createChannelColor = GoogleFonts.montserrat(
  textStyle: TextStyle(
    fontWeight: FontWeight.bold, fontSize: 18, color: Colors.purple)
);
var send_bird_sign_button = GoogleFonts.montserrat(
  textStyle: TextStyle(
    fontWeight: FontWeight.bold, fontSize: 18, color: ColorPickers.whiteColor)
);
var login_subTitle = GoogleFonts.montserratAlternates(
  textStyle: TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 13,
    color: ColorPickers.blackColor)
);
var greetingDescription = GoogleFonts.montserratAlternates(
  textStyle: TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 13,
    color: ColorPickers.greetingColor)
);
var loginCredTitle = GoogleFonts.montserratAlternates(
  textStyle: TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14,
    color: ColorPickers.blackColor)
);
var bodyTitle = GoogleFonts.montserrat(
  textStyle:  TextStyle(
    fontWeight: FontWeight.bold, fontSize: 24, color: ColorPickers.blackColor,)
);
const sub_heading = TextStyle(
    fontWeight: FontWeight.bold, fontSize: 13, color: ColorPickers.blackColor);
var register_now = GoogleFonts.roboto(
  textStyle: TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12,
    color: ColorPickers.registerNow)
);

const app_bar_title = TextStyle(
    fontWeight: FontWeight.bold, fontSize: 18, color: ColorPickers.whiteColor);
const bio_text = TextStyle(
    fontWeight: FontWeight.normal, fontSize: 13, color: ColorPickers.blackColor);
var edit_profile_titles = GoogleFonts.montserrat(
  textStyle:  TextStyle(
    fontWeight: FontWeight.w500, fontSize: 14, color: ColorPickers.blackColor)
);
const setting_page_label = TextStyle(
    fontWeight: FontWeight.normal, fontSize: 14, color: ColorPickers.blackColor);
var profile_name = GoogleFonts.montserrat(
  textStyle:  TextStyle(
    fontWeight: FontWeight.bold, fontSize: 24, color: ColorPickers.blackColor)
);
var profile_username = GoogleFonts.montserratAlternates(
  textStyle: TextStyle(
    fontWeight: FontWeight.w500, fontSize: 13, color: ColorPickers.blackColor)
);
var follow_title = GoogleFonts.montserratAlternates(
  textStyle: TextStyle(
    fontWeight: FontWeight.w700, fontSize: 13, color: ColorPickers.blackColor)
);
var follow_sub_title = GoogleFonts.montserratAlternates(
  textStyle: TextStyle(
    fontWeight: FontWeight.w500, fontSize: 13, color: ColorPickers.blackColor)
);
var tagTitle = GoogleFonts.montserratAlternates(
  textStyle: TextStyle(
    fontWeight: FontWeight.w500, fontSize: 10, color: ColorPickers.blackColor)
);
var button_text = GoogleFonts.montserratAlternates(
  textStyle: TextStyle(
    fontWeight: FontWeight.w600, fontSize: 13, color: ColorPickers.whiteColor),
);


const defaultTags = [
  "#Tag1",
  "#Tag2",
  "#Tag3",
  "#Tag4",
  "#Tag5",
  "#Tag6",
  "#Tag7",
  "#Tag8",
  "#Tag9",
  "#Tag10",
];