import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:sign_in_flutter/constants/constants.dart';
import 'package:sign_in_flutter/profile/guest_profile.dart';
import 'package:sign_in_flutter/repositories/auth_repository.dart';
import 'package:sign_in_flutter/sendbird/components/file_message_item.dart';
import 'package:sign_in_flutter/sendbird/components/message_input.dart';
import 'package:sign_in_flutter/sendbird/components/user_message_item.dart';
import 'package:sign_in_flutter/widgets/page_size.dart';

import 'components/channel_view_modal.dart';

class GroupChannelView extends StatefulWidget {
  final GroupChannel groupChannel;
  GroupChannelView({Key key, @required this.groupChannel}) : super(key: key);

  @override
  _GroupChannelViewState createState() => _GroupChannelViewState();
}

class _GroupChannelViewState extends State<GroupChannelView>
    with ChannelEventHandler {
  List<BaseMessage> _messages = [];
   GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  final picker = ImagePicker();
  File result;
  var currentUser;
  ChannelViewModel model;
  bool channelLoaded = false;
  var allUserRecord;
  final AuthRepository _authRepository = AuthRepository();
  @override
  void initState() {
    super.initState();
    _viewUserInfo();
    _loadMessage();
    _getCurrentUser();
    getMessages(widget.groupChannel);
    SendbirdSdk().addChannelEventHandler(widget.groupChannel.channelUrl, this);
  }
  _viewUserInfo() async {
     final headers = {
       "Content-Type": "application/json",
       "Api-Token": "bfa9466e49bbd7aa58d8aa6684f8860d823102a5" };
    final res = await http.get(Uri.parse('https://api-28A97237-32B3-4FA8-A220-2A9B8BB17026.sendbird.com/v3/users'), headers: headers);
    allUserRecord = json.decode(res.body);
  }
  _getCurrentUser() async{
    currentUser = await _authRepository.currentUser.then((value) => value.uid);
  }
  _loadMessage() {
      model = ChannelViewModel(widget.groupChannel.channelUrl);
    model.loadChannel().then((value) {
      setState(() {
        channelLoaded = true;
      });
      model.loadMessages(reload: true);
    });
  }

  @override
  void dispose() {
    SendbirdSdk().removeChannelEventHandler(widget.groupChannel.channelUrl);
    super.dispose();
  }

  Future<void> getMessages(GroupChannel channel) async {
    try {
      List<BaseMessage> messages = await channel.getMessagesByTimestamp(
          DateTime.now().millisecondsSinceEpoch * 1000, MessageListParams());
      setState(() {
        _messages = messages;
      });
    } catch (e) {
      print('group_channel_view.dart: getMessages: ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChannelViewModel>(
       create: (context) => model,
      child: (!channelLoaded) ?
      Scaffold(
              body: Center(
                child: Container(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(),
                ),
              ),
            ):
       Scaffold(
        resizeToAvoidBottomInset: false,
        key: _key,
         endDrawer: _drawerWidget(widget.groupChannel,),
         backgroundColor: Colors.white,
        appBar: _buildAppbar(),
        body: body(context),
      ),
    );
  }

  Widget _drawerWidget( GroupChannel channel,) {
    ChatUser user = asDashChatUser(SendbirdSdk().currentUser);
    return Container(
      height: displayWidth(context) * 1.2,
      width: displayWidth(context) - 200,
      color: ColorPickers.darkGreyColor,
      child: Theme(
         data: Theme.of(context).copyWith(
                 canvasColor: ColorPickers.drwaerBg, 
              ),
        child: Drawer(
            child: SafeArea(
              child: Container(
              child: Column(
                children: [
              DrawerHeader(
                padding: EdgeInsets.all(0),
                margin: EdgeInsets.all(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Lobby',style: drawerHeaderStyle,
                      ),
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                            color: ColorPickers.drwaerBg,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              color: ColorPickers.whiteColor,
                              width: 1,
                            ),
                          ),
                        child: FlatButton.icon(onPressed: () {Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios, color: ColorPickers.whiteColor,size: 15,), label: Text('Close Pane',style: drawerSubHeader,)))

                    ],
                  ),
                ),
                  Expanded(
                    flex: 1,
                    child: 
                    Container(
                       transform: Matrix4.translationValues(0.0, -30.0, 0.0),
                      child: ListView.builder(
                              shrinkWrap: false,
                              padding: new EdgeInsets.all(0.0),
                              scrollDirection: Axis.vertical,
                              itemCount: channel.members.length,
                              itemBuilder: (BuildContext context, int index){ 
                                if(user.uid == channel.members[index].userId) {
                                  return Container();
                                }else {
                                   return Padding(
                                     padding: const EdgeInsets.all(8.0),
                                     child: Row(
                                       children: [
                                         SizedBox(width: 20),
                                         Container(
                                           height: 40,
                                           width: 40,
                                             decoration: BoxDecoration(
                                                color: ColorPickers.drwaerBg,
                                                borderRadius: BorderRadius.circular(10.0),
                                                border: Border.all(
                                                  color: ColorPickers.whiteColor,
                                                  width: 1,
                                              ),
                                            ),
                                            child: ClipRRect(
                               borderRadius: BorderRadius.circular(8.8),
                              child: Image.network( channel.members[index].profileUrl,fit: BoxFit.cover,height: 47, width: 47.2, )),
                                  ),
                                      SizedBox(width: 20,),
                                  GestureDetector(
                                    onTap: () {
                                      _navigateToGustProfile(channel.members[index].userId);
                                    } ,
                                    child: Container(
                                              child: Center(
                                                child: Text(
                                                   channel.members[index].nickname, style: drawerSubHeader,),
                                              )),
                                  ),
                                       ],
                                     ),
                                   );
                                }
                               
                                  },
                            ),
                    ),
                  ),
                ],
              ),
          ),
            ),
          ),
      ),
    );
  }
  Widget _buildAppbar() {
    return AppBar(
      title: Text("Best Helmets",style: header_title,),
      centerTitle: true,
      leading: BackButton(color: ColorPickers.buttonBg),
      backgroundColor: ColorPickers.whiteColor,
      elevation: 0,
    );
  }

  Widget body(BuildContext context) {
    ChatUser user = asDashChatUser(SendbirdSdk().currentUser);
    return Container(
       height: displayHeight(context),
          width: displayWidth(context),
      child: 
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
        child: Column(
          children: [
            _memberListView(context,widget.groupChannel, user),
            SizedBox(height: 20),
          Consumer<ChannelViewModel>(
                        builder: (context, value, child) {
                          return _messageContainer(context);
                        },
                      ),
            
            _inputContainer(context),
          ],
        ),
      ),
    );
  }
  // Display Message Container
  Widget _messageContainer(BuildContext context) {
    return Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 15, right: 15),
              decoration: BoxDecoration(
                          color: ColorPickers.whiteColor,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: ColorPickers.blackColor,
                            width: 1,
                          ),
                        ),
                       
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ListView.builder(
                  controller: model.lstController,
                  itemCount: model.itemCount,
                  shrinkWrap: true,
                  reverse: true,
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  itemBuilder: (context, index) {
                    if (index == model.messages.length && model.hasNext) {
                      return Center(
                        child: Container(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final message = model.messages[index];
                    final prev = (index < model.messages.length - 1)
                        ? model.messages[index + 1]
                        : null;
                    final next = index == 0 ? null : model.messages[index - 1];

                    if (message is FileMessage) {
                      return FileMessageItem(
                        curr: message,
                        prev: prev,
                        next: next,
                        model: model,
                        isMyMessage: message.isMyMessage,
                        onPress: (pos) {
                          //
                        },
                        onLongPress: (pos) {
                          model.showMessageMenu(
                            context: context,
                            message: message,
                            pos: pos,
                          );
                        },
                      );
                    } 
                    // else if (message is AdminMessage) {
                    //   return AdminMessageItem(curr: message, model: model);
                    // } 
                    else if (message is UserMessage) {
                      return UserMessageItem(
                        curr: message,
                        prev: prev,
                        next: next,
                        model: model,
                        isMyMessage: message.isMyMessage,
                        onPress: (pos) {
                          //
                        },
                        onLongPress: (pos) {
                          model.showMessageMenu(
                            context: context,
                            message: message,
                            pos: pos,
                          );
                        },
                      );
                    } 
                    else {
                      //undefined message type
                      return Container();
                    }
                  },
                ),
                   Container(
       margin: EdgeInsets.only(top: 20),
       child: Align(
         alignment: Alignment.topRight,
          child: GestureDetector(
            onTap: () {
               _key.currentState.openEndDrawer();
            },
            child: Container(
              color: ColorPickers.buttonBg,
              width: 10,
              height: 65,
            ),
          ),
        ),
     ),
              ],
            ),
      ),
    );
  }
  // Input Text Container
  Widget _inputContainer(BuildContext context) {
    return  MessageInput(
                            onPressPlus: () {
                              model.showPlusMenu(context);
                            },
                            onPressSend: (text) {
                              model.onSendUserMessage(text);
                              setState(() {
                                
                              });
                            },
                            onEditing: (text) {
                              model.onUpdateMessage(text);
                            },
                            onChanged: (text) {
                              model.onTyping(text != '');
                            },
                            placeholder: model.selectedMessage?.message,
                            // isEditing: editing,
                          );
  }
  // Navigate to Gust Profile
  _navigateToGustProfile(otherProfile) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => GuestProfile(uuid: otherProfile, bottomCheck: true)));
  }

  // Display the Member of the List 
  _memberListView(BuildContext context, GroupChannel channel, ChatUser user) {
    
    return Container(
       margin: EdgeInsets.only(left: 15, right: 15),
      height: 50,
      width: displayWidth(context),
        child: ListView.builder(
                shrinkWrap: false,
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                itemCount: channel.members.length,
                itemBuilder: (BuildContext context, int index){
                  if(user.uid == channel.members[index].userId) {
                    return Container();
                  }else {
                     return Container(
                  margin: EdgeInsets.only(left: 10),
                  height: 50,
                  width: 50,
                   decoration: BoxDecoration(
                          color: ColorPickers.whiteColor,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: ColorPickers.blackColor,
                            width: 1,
                          ),
                        ),
                      child: GestureDetector(
                        onTap: () {
                          _navigateToGustProfile(channel.members[index].userId);
                        },
                        child: Container(
                          child: Center(
                            child:  ClipRRect(
                                 borderRadius: BorderRadius.circular(8.8),
                                child: Image.network( channel.members[index].profileUrl,fit: BoxFit.cover,height: 47, width: 47.2, )
                                ),
                    // For show User Status Start Here //
                        //     Stack(
                        //       children: [
                        //         ClipRRect(
                        //          borderRadius: BorderRadius.circular(8.8),
                        //         child: Image.network( channel.members[index].profileUrl,fit: BoxFit.cover,height: 47, width: 47.2, )
                        //         ),
                        //         Align(
                        //           alignment: Alignment.bottomRight,
                        //           child: Container(
                        //              height: 10,
                        //             width: 10,
                        //             decoration: BoxDecoration(
                        //           color: Colors.red,
                        //           borderRadius: BorderRadius.circular(4.0),
                        //           border: Border.all(
                        //             color: ColorPickers.blackColor,
                        //             width: 1,
                        //   ),
                        // ),
                        //           ),
                        //         ),
                        //       ],
                        //     )
                        // For show User Status End Here //
                            // child: Text(
                            //    channel.members[index].nickname, style: TextStyle(color: ColorPickers.blackColor),),
                          )),
                      ),
                    );
                  }
                 
                    },
              ),
      );
  }
  ChatUser asDashChatUser(User user) {
    return ChatUser(
      name: user.nickname,
      uid: user.userId,
      avatar: user.profileUrl,
    );
  }
}