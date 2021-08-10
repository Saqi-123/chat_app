import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sign_in_flutter/constants/constants.dart';
import 'package:sign_in_flutter/onboarding/image_selection.dart';
import 'package:sign_in_flutter/repositories/auth_repository.dart';
import 'package:sign_in_flutter/repositories/rest_repository.dart';
import 'package:sign_in_flutter/widgets/custom_progress_bar.dart';
import 'package:sign_in_flutter/widgets/custom_text_field.dart';
import 'package:sign_in_flutter/widgets/loading_text.dart';

class UserNameSelection extends StatefulWidget {
  @override
  _UserNameSelection createState() => _UserNameSelection();
}

class _UserNameSelection extends State<UserNameSelection> {
  final _userNameKey = GlobalKey<FormState>();
  final _userNameTextController = TextEditingController();
  bool _canMoveNextPage = false;
  bool isLoading = false;
  final RestRepository restRepository = RestRepository();
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
      appBar: appBar,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(left: 35, right: 35),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _headerTitle(),
                SizedBox(height: 50),
                _subHeaderTitle(),
                SizedBox(height: 22),
                _textFieldWidget(),
                 SizedBox(height: 22),
                _buttonFieldWidget(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Header Title....
  Widget _headerTitle() {
    return Column(
      children: [
        Text(
          'Hi hi to',
          style: login_title,
        ),
        Text(
          'HayHay!',
          style: login_title,
        ),
      ],
    );
  }

// SubHeader Title
  Widget _subHeaderTitle() {
    return Container(
      child: Text(
        'What${"'s"} your name?',
        style: login_subTitle,
      ),
    );
  }

// TextField ....
  Widget _textFieldWidget() {
    return Container(
      child: Form(
        key: _userNameKey,
        child: CustomTextField(
          hintText: "Enter your name",
          onChanged: (value) {
            _userNameKey.currentState.validate();
            _isAllFieldsValidated();
          },
          onSubmit: (value) {
            if (_userNameKey.currentState.validate()) {
              // _passwordFocus.unfocus();

            }
            _isAllFieldsValidated();
          },
          validator: (String value) {
            if (value.trim().isEmpty) return "Please enter user name";
          },
          textFormatter: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^[a-zA-Z]+([\s+a-zA-Z])*')),
                      ],
          controller: _userNameTextController,
        ),
      ),
    );
  }

// Enter Button Field Widget...
  Widget _buttonFieldWidget(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
          child: RaisedButton(
        onPressed: _canMoveNextPage
            ? () => _addUserName(context)
            : null,
        color: ColorPickers.buttonBg,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Enter',
            style: button_text,
          ),
        ),
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.7),),
      )),
    );
  }

// Store user name to firestore ...
  _addUserName(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    final uid = (await AuthRepository().currentUser).uid;
    final email = (await AuthRepository().currentUser).email;
    final userName = _userNameTextController.text;
    var response = await restRepository.addUser(uid, email, userName);

    if (response == 'success!') {
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => ImageSelection(name: _userNameTextController.text), fullscreenDialog: true));
    } else if (response != 'success!') {
      setState(() {
        isLoading = false;
      });
      throw ErrorDescription("Error creating user name: $response");
    }
  }

  // Validate All Field....
  bool _isAllFieldsValidated() {
    setState(() {
      _canMoveNextPage = _userNameKey.currentState.validate();
    });
    return _canMoveNextPage;
  }
}
