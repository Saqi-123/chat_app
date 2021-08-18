import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sign_in_flutter/constants/constants.dart';
import 'package:sign_in_flutter/repositories/auth_repository.dart';
import 'package:sign_in_flutter/repositories/send_bird_auth.dart';
import 'package:sign_in_flutter/widgets/custom_progress_bar.dart';
import 'package:sign_in_flutter/widgets/custom_text_field.dart';
import 'package:sign_in_flutter/widgets/loading_text.dart';

class LoginView extends StatefulWidget {
  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  final _appIdController =
      TextEditingController(text: "YOUR_APPLICATION_ID_HERE");
  final _userIdController = TextEditingController();
  final _nameTextController = TextEditingController();
  final _nameKey = GlobalKey<FormState>();
  bool _enableSignInButton = false;
  bool isLoading = false;
  var uuid;
  File _image;
   final picker = ImagePicker();
  @override
  void initState() { 
    super.initState();
    gettingCurrentUser();
  }
  // Getting Current User Info
  gettingCurrentUser() async {
    final uid = (await AuthRepository().currentUser).uid;
    setState(() {
      uuid = uid;
    });
    _userIdController.text = uuid;
    _appIdController.text = "28A97237-32B3-4FA8-A220-2A9B8BB17026";
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
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: body(context),
    );
  }
  
   Widget _buildAppbar() {
    return AppBar(
      title: Text("Create Send Bird Profile",style: header_title,),
      centerTitle: true,
      automaticallyImplyLeading: false,
      backgroundColor: ColorPickers.whiteColor,
      elevation: 0,
    );
  }

  Widget body(BuildContext context) {
   if (isLoading) {
      return CustomPageProgressBar(
          loadingText: LoadingText(
        textStyle: TextStyle(fontSize: 20),
      ));
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
       backgroundColor: ColorPickers.whiteColor,
      appBar: _buildAppbar(),
      body: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 100),
          child: Column(
            children: [
               _imageWidget(context),
               SizedBox(height: 40),
               _userNickName(context),
              SizedBox(height: 30),
              FractionallySizedBox(
                widthFactor: 1,
                child: _signInButton(context, _enableSignInButton),
              )
              
            ],
          )),
    );
  }
    // Image Widget ....
  Widget _imageWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _getImageFromGallery();
      },
      child: Container(
                 width: 137,
                 height: 130,
                margin: EdgeInsets.only(left: 5, right: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.7),
                  color: Colors.grey,
                  border: Border.all(color: ColorPickers.blackColor),
                ),
                child: _image == null ? 
                Image.asset('assets/camera_icon.png')
                :
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.7),
                  child: Image.file(_image, fit: BoxFit.fill)),
      ),
    );
  }
   // Get Image From Gallery .....
  Future _getImageFromGallery() async {
    var image = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image.path);
       _enableSignInButton = _shouldEnableSignInButton();
    });
  }
  Widget _userNickName(BuildContext context) {
    return Container(
      child: Form(
                    key: _nameKey,
                    child: CustomTextField(
                      hintText: "Enter nick name",
                      onChanged: (value) {
                      setState(() {
                        _enableSignInButton = _shouldEnableSignInButton();
                        
                      });
                      },
                      onSubmit: (value) {
                        if (_nameKey.currentState.validate()) {
                          // _passwordFocus.unfocus();

                        }
                      },
                      validator: (String value) {
                        if (value.trim().isEmpty) return "Please enter name";
                      },
                      textFormatter: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^[a-zA-Z]+([\s+a-zA-Z])*')),
                      ],
                      controller: _nameTextController,
            ),
          ),
    );
  }

  bool _shouldEnableSignInButton() {
    if (_image == null) {
      return false;
    }
    else if (_nameTextController.text.isEmpty) {
      return false;
    }
      return true;
    
  }

  Widget _signInButton(BuildContext context, bool enabled) {
    if (enabled == false) {
      return TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
            foregroundColor:
                MaterialStateProperty.all<Color>(Colors.grey[300])),
        onPressed: () {},
        child: Text(
          "Sign In",
          style: header_title,
        ),
      );
    }
    return TextButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFFFAB40)),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white)),
      onPressed: () async{
        setState(() {
          isLoading = true;
        });
        final user = await SendBirdAuth().createUser(_userIdController.text, _nameTextController.text, _image);
        final response = json.decode(user.body);
        if (user.statusCode == 200) {
           await SendBirdAuth().connect(_appIdController.text, _userIdController.text, _nameTextController.text,response['access_token']).then((user) {
             setState(() {
               isLoading = false;
             });
              Navigator.pushNamed(context, '/channel_list');
        }).catchError((error) {
          setState(() {
            isLoading = false;
          });
          print('login_view: _signInButton: ERROR: $error');
        });
        }
      },
      child: Text(
        "Sign In",
        style: send_bird_sign_button,
      ),
    );
  }

}
