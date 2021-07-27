import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:sign_in_flutter/constants/constants.dart';
import 'package:sign_in_flutter/onboarding/greeting.dart';
import 'package:sign_in_flutter/repositories/auth_repository.dart';
import 'package:sign_in_flutter/repositories/rest_repository.dart';
import 'package:sign_in_flutter/widgets/custom_progress_bar.dart';
import 'package:sign_in_flutter/widgets/loading_text.dart';
class TagsScreen extends StatefulWidget {

  @override
  _TagsScreenState createState() => _TagsScreenState();
}

class _TagsScreenState extends State<TagsScreen> {
  List<String> _tags=[];
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
          margin: EdgeInsets.only(left: 35, right:35),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _headerWidget(),
                SizedBox(height: 50),
                _defaultTagsWidget(),
                SizedBox(height: 22),
                _nextButton(context)
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _headerWidget() {
    return Container(
      child: Column(
        children: [
          Text('What are your',style: bodyTitle),
          Text('interests?',style: bodyTitle)
        ]
      ),
    );
  }
  // Default Tags Widget ....
  Widget _defaultTagsWidget(){

    return Container(
      child: Tags(  
      itemCount: defaultTags.length, 
      itemBuilder: (int index){ 
          return Tooltip(
          message: defaultTags[index],
          child:ItemTags(
            index: index,
            elevation: 0,
            textActiveColor: ColorPickers.blackColor,
            textColor: ColorPickers.whiteColor,
            activeColor: ColorPickers.tagsBg,
            color: ColorPickers.activeTag,
            title:defaultTags[index],
             onPressed: (item) => _selectedTags(item),
          )
          );
      },
      
    ),
    );
  }
  // Button Widget ...
   Widget _nextButton(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
          child: RaisedButton(
        onPressed: _canMoveNextPage
            ? () => uploadTags(context)
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
  // store Tags into store.....
  uploadTags(BuildContext context) async {
    final uid = (await AuthRepository().currentUser).uid;
    var response = await restRepository.addTags(uid,_tags);
      if (response == 'update success!') {
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => GreetingScreen(), fullscreenDialog: true));
    } else if (response != 'success!') {
      setState(() {
        isLoading = false;
      });
      throw ErrorDescription("Error creating user name: $response");
    }
  }
  // Selected Tagss.....
  _selectedTags(var item) {
    if(!item.active) {
        setState(() {
       _tags.add(item.title);
    });
    _isAllFieldsValidated();
    } else {
      setState(() {
        _tags.remove(item.title);
      });
      _isAllFieldsValidated();
    }
  }
  bool _isAllFieldsValidated() {
    if (_tags != null) {
      setState(() {
        _canMoveNextPage = true;
      });
    }
    return _canMoveNextPage;
  }
}