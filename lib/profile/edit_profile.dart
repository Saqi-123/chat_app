import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sign_in_flutter/constants/constants.dart';
import 'package:sign_in_flutter/profile/profile.dart';
import 'package:sign_in_flutter/repositories/auth_repository.dart';
import 'package:sign_in_flutter/repositories/rest_repository.dart';
import 'package:sign_in_flutter/widgets/bottom_navigation.dart';
import 'package:sign_in_flutter/widgets/custom_progress_bar.dart';
import 'package:sign_in_flutter/widgets/custom_text_field.dart';
import 'package:sign_in_flutter/widgets/loading_text.dart';
import 'package:sign_in_flutter/widgets/page_size.dart';
class EditProfile extends StatefulWidget {
  final props;
const EditProfile ({ Key key, this.props}): super(key: key);
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  List<dynamic> _tags=[];
  final _linkKey = GlobalKey<FormState>();
  final _nameKey = GlobalKey<FormState>();
  final _usernameKey = GlobalKey<FormState>();
  final _linkTextController = TextEditingController();
  final _nameTextController = TextEditingController();
   final _bioTextController = TextEditingController();
  final _usernameTextController = TextEditingController();
  final picker = ImagePicker();
  File _image;
  bool isLoading = false;
  final RestRepository restRepository = RestRepository();
@override
void initState() { 
  super.initState();
  _tags.addAll(widget.props.tags);
  _nameTextController.text = widget.props.name;
  _usernameTextController.text = widget.props?.username != null ? widget.props?.username : '';
  _bioTextController.text = widget.props?.bio != null ? widget.props?.bio : '';
  _linkTextController.text = widget.props?.link != null ? widget.props?.link : '';
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
      title: Text("Edit Page",style: header_title,),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: ColorPickers.buttonBg),
        onPressed: () => Navigator.of(context).pop(),
      ),
      backgroundColor: ColorPickers.whiteColor,
      elevation: 0,
    ),
      bottomNavigationBar: BottomNavigation(),
      body: SingleChildScrollView(
        child: Container(
          height: displayHeight(context),
          width: displayWidth(context),
            margin: EdgeInsets.only(left: 35, right: 35),
            child: Column(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            _imageWidget(context),
            _userSection(context),
            _bioWidget(context),
            _tagSection(context),
            SizedBox(height: 5),
            _linkWidget(context),
            _buttonWidget(context)
              ],
            ),
      ),
    ),
    );
  }
   Widget _buildAppbar() {
    return AppBar(
      title: Text("Edit Page",style: header_title,),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: ColorPickers.buttonBg),
        onPressed: () => Navigator.of(context).pop(),
      ),
      backgroundColor: ColorPickers.whiteColor,
      elevation: 0,
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
    });
  }
  // User Selection Widget .....
  Widget _userSection(BuildContext context) {
   return Container(
      child: Column(
        children: [
          Row(
                children: <Widget>[
                  Text('Name',style: edit_profile_titles,),
                     SizedBox(width: 78,),
                  Expanded(
                 child: Form(
                    key: _nameKey,
                    child: CustomTextField(
                      hintText: "Name",
                      onChanged: (value) {
                        _nameKey.currentState.validate();
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
               ),
                ],
              ),
          Row(
                children: <Widget>[
                  Text('Username',style: edit_profile_titles,),
                     SizedBox(width: 50,),
                  Expanded(
                 child: Form(
                    key: _usernameKey,
                    child: CustomTextField(
                      hintText: "UserName",
                      onChanged: (value) {
                        _usernameKey.currentState.validate();
                      },
                      onSubmit: (value) {
                        if (_usernameKey.currentState.validate()) {
                          // _passwordFocus.unfocus();

                        }
                      },
                      validator: (String value) {
                        if (value.trim().isEmpty) return "Please enter userName";
                      },
                      textFormatter: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^[a-zA-Z0-9]+([\s+a-zA-Z0-9])*')),
                      ],
                      controller: _usernameTextController,
            ),
          ),
               ),
                ],
              ),
        ],
      ),
    );
  }

   Widget _bioWidget(BuildContext context) {
   return Container(
     child: Column(
       children: [
         Align(alignment: Alignment.topLeft, child: Text('Bio',style: edit_profile_titles,)),
         SizedBox(height: 5),
         Container(
           padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.7),
                            border: Border.all(color: ColorPickers.blackColor),
                          ),   
            child: TextField(
                      maxLines: 4,
                      decoration: InputDecoration.collapsed(hintText: "Enter your bio here"),
                      controller: _bioTextController,
                    ),
          ),
       ],
     ),
   );
  }
   Widget _tagSection(BuildContext context) {
   return Container(
     child: Column(
       children: [
         Align(alignment: Alignment.topLeft, child: Text('Tags',style: edit_profile_titles,)),
         SizedBox(height: 5),
         Container(
            height: 120,
             decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.7),
                            border: Border.all(color: ColorPickers.blackColor),
                          ),   
             width: displayWidth(context),
                 child : Center(
                   child: Tags(  
                itemCount: defaultTags.length, 
                itemBuilder: (int index){ 
                    return Tooltip(
                    message: defaultTags[index],
                    child:ItemTags(
                      index: index,
                      elevation: 0,
                      active: widget.props.tags.contains(defaultTags[index]),
                      textActiveColor: ColorPickers.whiteColor,
                      textColor: ColorPickers.blackColor,
                      activeColor: ColorPickers.activeTag,
                      color: ColorPickers.tagsBg,
                      title:defaultTags[index],
                      onPressed: (item) => _selectedTags(item),
             )
          );
      },
      
    ),
              ),
                 ),
       ],
     ),
   );
  }
  // Selected Tagss.....
  _selectedTags(var item) {
    if(item.active) {
        setState(() {
       _tags.add(item.title);
    });
    } else {
      setState(() {
        _tags.remove(item.title);
      });
    }
  }
  Widget _linkWidget(BuildContext context) {
   return Container(
      child: Row(
        children: <Widget>[
          Text('Link',style: edit_profile_titles,),
          SizedBox(width: 50,),
           Expanded(
             child: Form(
                key: _linkKey,
                child: CustomTextField(
                  hintText: "Link",
                  onChanged: (value) {
                    _linkKey.currentState.validate();
                  },
                  onSubmit: (value) {
                    if (_linkKey.currentState.validate()) {
                      // _passwordFocus.unfocus();

                    }
                  },
                  validator: (String value) {
                    if (value.trim().isEmpty) return "Please enter Link";
                  },
                  controller: _linkTextController,
        ),
      ),
           ),
        ],
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
  onPressed: () {updateUserProfile(context);},
  child: Text('Save Changes',style: button_text),
  elevation: 0,
)

    );
  }
  // Update UserProfile Data....
  updateUserProfile(BuildContext context) async{
    setState(() {
      isLoading = true;
    });
    try{
       final uid = (await AuthRepository().currentUser).uid;
      if (_image == null) {
         final response = await restRepository.updateUserProfile(uid, _nameTextController.text,_usernameTextController.text,_bioTextController.text,_linkTextController.text,_tags);
        if (response == 'success!') {
          setState(() {
            isLoading = false;
          });
           Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
        } else if (response != 'success!') {
          setState(() {
            isLoading = false;
          });
          throw ErrorDescription("Error creating user name: $response");
        }
      }else {
        final downloadImage =
          await restRepository.uploadImageToFirebase(uid, _image);
          if (downloadImage != null) {
            final response = await restRepository.updateUserProfile(uid, _nameTextController.text,_usernameTextController.text,_bioTextController.text, _linkTextController.text,_tags);
        if (response == 'success!') {
          setState(() {
            isLoading = false;
          });
          Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
        } else if (response != 'success!') {
          setState(() {
            isLoading = false;
          });
          throw ErrorDescription("Error creating user name: $response");
        }
          }
      }

    } catch (e) {
      throw e;
    }
  }
}