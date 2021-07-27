import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sign_in_flutter/Tags/tags.dart';
import 'package:sign_in_flutter/constants/constants.dart';
import 'package:sign_in_flutter/repositories/auth_repository.dart';
import 'package:sign_in_flutter/repositories/rest_repository.dart';
import 'package:sign_in_flutter/widgets/custom_progress_bar.dart';
import 'package:sign_in_flutter/widgets/loading_text.dart';


class ImageSelection extends StatefulWidget {
  final String name;
  ImageSelection({@required this.name});
  @override
  _ImageSelectionState createState() => _ImageSelectionState();
}

class _ImageSelectionState extends State<ImageSelection> {
  File _image;
  File _imageFile;
  bool isLoading = false;
  final picker = ImagePicker();
  bool _canMoveNextPage = false;
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
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _headerTitle(),
                  SizedBox(height: 50),
                  _subHeaderTitle(),
                     SizedBox(height: 22),
                  _nextButton(context)
                ],
              ),
            )),
      ),
    );
  }

  // Header Title....
  Widget _headerTitle() {
    return Container(
      child: Column(
        children: [
          Text('Nice to meet', style: bodyTitle,),
          Text('${widget.name}', style: bodyTitle,),
        ],
      ),
    );
  }

  // SubHeader Title
  Widget _subHeaderTitle() {
    return Container(
      child: Column(
        children: [
          Text(
            'now choose a profile image',
            style: login_subTitle,
          ),
          SizedBox(height: 20),
          _imageWidget(context),
        ],
      ),
    );
  }

 // Image Widget ....
  Widget _imageWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _getImage();
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

// Get Image From Gallary or Camera....
  Future _getImage() async {
    var image = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(image.path);
    });
    _isAllFieldsValidated();
  }

// Next Button
// Enter Button Field Widget...
  Widget _nextButton(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
          child: RaisedButton(
        onPressed: _canMoveNextPage
            ? () => uploadImage(context)
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

// Upload Image to firestore and cloud storage .....

  uploadImage(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    try {
      if (_image != null) {
        _imageFile = _image;
      } 
      final uid = (await AuthRepository().currentUser).uid;
      final downloadImage =
          await restRepository.uploadImageToFirebase(uid, _imageFile);

      if (downloadImage != null) {
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => TagsScreen(), fullscreenDialog: true));
      }
    } catch (e) {
      throw e;
    }
  }
  bool _isAllFieldsValidated() {
    if (_image != null) {
      setState(() {
        _canMoveNextPage = true;
      });
    }
    return _canMoveNextPage;
  }
}
