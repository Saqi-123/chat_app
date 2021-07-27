import 'package:flutter/material.dart';
import 'package:sign_in_flutter/constants/constants.dart';
import 'package:sign_in_flutter/repositories/auth_repository.dart';
import 'package:sign_in_flutter/widgets/bottom_navigation.dart';
import 'package:sign_in_flutter/widgets/custom_text_field.dart';
import 'package:sign_in_flutter/widgets/page_size.dart';
class SettingPage extends StatefulWidget {

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final _currentPasswordKey = GlobalKey<FormState>();
  final _newPasswordKey = GlobalKey<FormState>();
  final _confirmPasswordKey = GlobalKey<FormState>();
  final _currentPasswordTextController = TextEditingController();
  final _newPasswordTextController = TextEditingController();
  final _confirmPasswordTextController = TextEditingController();
  final AuthRepository _authRepository = AuthRepository();
  bool checkCurrentPasswordValid = true;
  bool _canMoveNextPage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPickers.whiteColor,
      appBar: AppBar(
      title: Text("Setting Page",style: header_title,),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: ColorPickers.buttonBg),
        onPressed: () => Navigator.of(context).pop(),
      ),
      backgroundColor: ColorPickers.whiteColor,
      elevation: 0,
    ),
      bottomNavigationBar: BottomNavigation(),
      body: SafeArea(
        child: Container(
          width: displayWidth(context),
          height: displayWidth(context),
          margin: EdgeInsets.only(right:35.0,left: 35.0, top: 60),
          child: Column(
            children: [
              _currentPasswordWidget(),
              SizedBox(height: 20),
              _newPasswordWidget(),
              SizedBox(height: 20),
              _confirmPasswordWidget(),
              _buttonWidget(context),
            ],
          ),
        ),
      ),
    );
  }
  // Current Form Widget.....
  Widget _currentPasswordWidget() {
    return Container(
      child: Column(
        children: [
          Align(alignment: Alignment.topLeft, child: Text("Current Password",style: edit_profile_titles,)),
          Form(
            key: _currentPasswordKey,
            child: CustomTextField(
              hintText: "Current Password",
               paswordValid: checkCurrentPasswordValid ? '' : 'Please double check your current password',
              onChanged: (value) {
                _currentPasswordKey.currentState.validate();
                // _isAllFieldsValidated();
              },
              onSubmit: (value) {
                if (_currentPasswordKey.currentState.validate()) {
                  // _isAllFieldsValidated();
                }
              },
              validator: (String value) {
                if (value.trim().isEmpty) return "Please enter current password";
              },
              controller: _currentPasswordTextController,
        ),
      ),
        ],
      ),
    );
  }
  // New Password Widget
  Widget _newPasswordWidget() {
    return Container(
      child: Column(
        children: [
          Align(alignment: Alignment.topLeft, child: Text("New Password",style: edit_profile_titles,)),
          Form(
            key: _newPasswordKey,
            child: CustomTextField(
              hintText: "New Password",
              onChanged: (value) {
                _newPasswordKey.currentState.validate();
                _isAllFieldsValidated();
              },
              onSubmit: (value) {
                if (_newPasswordKey.currentState.validate()) {
                  _isAllFieldsValidated();
                }
              },
              validator: (String value) {
                if (value.trim().isEmpty) return "Please enter new password";
              },
              controller: _newPasswordTextController,
        ),
      ),
        ],
      ),
    );
  }
  // Confirm Password Widget ....
  Widget _confirmPasswordWidget(){
    return Container(
      child: Column(
        children: [
           Align(alignment: Alignment.topLeft, child: Text("Confirm Password", style: edit_profile_titles,)),
          Form(
            key: _confirmPasswordKey,
            child: CustomTextField(
              hintText: "Confirm Password",
              onChanged: (value) {
                _confirmPasswordKey.currentState.validate();
                _isAllFieldsValidated();
              },
              onSubmit: (value) {
                if (_confirmPasswordKey.currentState.validate()) {
                  _isAllFieldsValidated();
                }
              },
              validator: (value) {
               return  _newPasswordTextController.text == value ? null : 'Please validate your entered password';
              },
              controller: _confirmPasswordTextController,
        ),
      ),
        ],
      ),
    );
  }
  Widget _buttonWidget(BuildContext context) {
   return Container(
     alignment: Alignment.topRight,
      child: RaisedButton(
        color: ColorPickers.buttonBg,
        shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
        textColor: Colors.white, // foreground
        onPressed: _canMoveNextPage ?  ()   async {
          checkCurrentPasswordValid = await _validateCurrentPassword(_currentPasswordTextController.text);
          setState(() {
            
          });
          // ignore: unnecessary_statements
          checkCurrentPasswordValid  ? showToast : print('not validated....');
        } : null,
        child: Text('Change Password',style: button_text,),
        elevation: 0,
      )

    );
 }
//  Validate Current Password ....
Future<bool> _validateCurrentPassword(String currentPassword) async {
  return await _authRepository.validatePassword(currentPassword);
}
bool _isAllFieldsValidated() {
  if (_newPasswordTextController.text.trim() != '' && _confirmPasswordTextController.text.trim() != '') {
      if (_newPasswordTextController.text == _confirmPasswordTextController.text) {
        setState(() {
      _canMoveNextPage = true;
    });
      }
     
  }
    
    return _canMoveNextPage;
  }
 }