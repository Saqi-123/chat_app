import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';
import 'dart:async';
import 'package:sign_in_flutter/constants/constants.dart';
import 'package:sign_in_flutter/profile/guest_profile.dart';
import 'package:sign_in_flutter/profile/profile.dart';
import 'package:sign_in_flutter/repositories/auth_repository.dart';
import 'package:sign_in_flutter/sendbird/attchment_modal.dart';
import 'package:sign_in_flutter/widgets/page_size.dart';

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
  final AuthRepository _authRepository = AuthRepository();
  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    getMessages(widget.groupChannel);
    SendbirdSdk().addChannelEventHandler(widget.groupChannel.channelUrl, this);
  }
  _getCurrentUser() async{
    currentUser = await _authRepository.currentUser.then((value) => value.uid);
  }

  @override
  void dispose() {
    SendbirdSdk().removeChannelEventHandler(widget.groupChannel.channelUrl);
    super.dispose();
  }

  @override
  onMessageReceived(channel, message) {
    setState(() {
      _messages.add(message);
    });
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _key,
       endDrawer: _drawerWidget(widget.groupChannel,),
       backgroundColor: Colors.white,
      appBar: _buildAppbar(),
      body: body(context),
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
                                            // child: Image.network(channel.members[index].profileUrl),
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
    // Get Image From Gallery .....
  Future _getImageFromGallery() async {
     final modal = AttachmentModal(context: context);
    final file = await modal.getFile();
     onSendFileMessage(file);
  }
  // upload a image to sendbird..
  void onSendFileMessage(File file) async {
    final params = FileMessageParams.withFile(file);
    final preMessage =
        widget.groupChannel.sendFileMessage(params, onCompleted: (msg, error) {
      final index =
          _messages.indexWhere((element) => element.requestId == msg.requestId);
      if (index != -1) _messages.removeAt(index);
      _messages = [msg, ..._messages];
      _messages.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    });

    _messages = [preMessage, ..._messages];

  }

  Widget body(BuildContext context) {
    ChatUser user = asDashChatUser(SendbirdSdk().currentUser);
    return Container(
       height: displayHeight(context),
          width: displayWidth(context),
            // margin: EdgeInsets.only(left: 20, right: 20),
      child: 
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
        child: Column(
          children: [
            _memberListView(context,widget.groupChannel, user),
            _openDrawer(context),
            SizedBox(height: 20),
            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: DashChat(
                  scrollToBottom : true,
                  dateFormat: DateFormat("E, MMM d"),
                  timeFormat: DateFormat.jm(),
                  showUserAvatar: true,
                  alwaysShowSend: true,
                  key: Key(widget.groupChannel.channelUrl),
                  onSend: (ChatMessage message) async {
                    var sentMessage =
                        widget.groupChannel.sendUserMessageWithText(message.text);
                    setState(() {
                      _messages.add(sentMessage);
                    });
                  },

                  textBeforeImage: true,
                  onPressAvatar: (ChatUser user,) {
                          if (user.uid == currentUser) {
                             Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(chat: true)));
                          } else {
                            print('called else ${widget.groupChannel.members[1].userId}');
                          }
                            
                          },
                   trailing: <Widget>[
                            IconButton(
                              icon: Icon(Icons.photo),
                              onPressed: (){
                               _getImageFromGallery();
                              },
                            )
                   ],
                  sendOnEnter: true,
                  textInputAction: TextInputAction.send,
                  user: user,
                  messages: asDashChatMessages(_messages),
                  inputDecoration:
                      InputDecoration.collapsed(hintText: "Type a message here..."),
                  messageDecorationBuilder: (ChatMessage msg, bool isUser) {
                    return BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      color: isUser
                          ? Theme.of(context).primaryColor
                          : Colors.grey[200], // example
                    );
                  },
                inputContainerStyle: BoxDecoration(
                   borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              color: ColorPickers.blackColor,
                              width: 1,
                            ),
                )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // Navigate to Gust Profile
  _navigateToGustProfile(otherProfile) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => GuestProfile(uuid: otherProfile, bottomCheck: true)));
  }

  // Display the Member of the List 
  _memberListView(BuildContext context, GroupChannel channel, ChatUser user) {
    
    return Container(
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
                            child: Text(
                               channel.members[index].nickname, style: TextStyle(color: ColorPickers.blackColor),),
                          )),
                      ),
                    );
                  }
                 
                    },
              ),
      );
  }
  // Open Drawer 
  Widget _openDrawer(BuildContext context) {
     return Align(
       alignment: Alignment.bottomRight,
        child: GestureDetector(
          onTap: () => {
             _key.currentState.openEndDrawer()
          },
          child: Container(
            color: ColorPickers.buttonBg,
            width: 10,
            height: 65,
          ),
        ),
      );

  }

  List<ChatMessage> asDashChatMessages(List<BaseMessage> messages) {
    // BaseMessage is a Sendbird class
    // ChatMessage is a DashChat class
    List<ChatMessage> result = [];
    if (messages != null) {
      messages.forEach((message) {
        User user = message.sender;
        if (user == null) {
          return;
        }
        result.add(
          ChatMessage(
            createdAt: DateTime.fromMillisecondsSinceEpoch(message.createdAt),
            text: message.message,
            user: asDashChatUser(user),
          ),
        );
      });
    }
    return result;
  }

  ChatUser asDashChatUser(User user) {
    return ChatUser(
      name: user.nickname,
      uid: user.userId,
      avatar: user.profileUrl,
    );
  }
}