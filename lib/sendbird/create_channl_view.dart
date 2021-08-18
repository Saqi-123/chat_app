import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';
import 'package:sign_in_flutter/constants/constants.dart';
import 'package:sign_in_flutter/repositories/auth_repository.dart';
import 'package:sign_in_flutter/sendbird/group_channel_view.dart';
import 'package:sign_in_flutter/widgets/bottom_navigation.dart';

class CreateChannelView extends StatefulWidget {
   final bool bottomCheck;
   CreateChannelView({this.bottomCheck = false});
  @override
  _CreateChannelViewState createState() => _CreateChannelViewState();
}

class _CreateChannelViewState extends State<CreateChannelView> {
  final Set<User> _selectedUsers = {};
  final List<User> _availableUsers = [];
  var currentUser;
  final AuthRepository _authRepository = AuthRepository();
  Future<List<User>> getUsers() async {
    try {
      final query = ApplicationUserListQuery();
      List<User> users = await query.loadNext();
      return users;
    } catch (e) {
      print('create_channel_view: getUsers: ERROR: $e');
      return [];
    }
  }

  Future<GroupChannel> createChannel(List<String> userIds) async {
    try {
      final params = GroupChannelParams()..userIds = userIds;
      final channel = await GroupChannel.createChannel(params);
      return channel;
    } catch (e) {
      print('createChannel: ERROR: $e');
      throw e;
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    getUsers().then((users) {
      setState(() {
        _availableUsers.clear();
        _availableUsers.addAll(users);
      });
    }).catchError((e) {
      print('initState: ERROR: $e');
    });
  }
  // Getting Current User ID.......
   _getCurrentUser() async{
    currentUser = await _authRepository.currentUser.then((value) => value.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar:widget.bottomCheck ? BottomNavigation() : null,
      appBar: navigationBar(),
      body: body(context),
    );
  }

  Widget navigationBar() {
    return AppBar(
      automaticallyImplyLeading: true,
      backgroundColor: Colors.white,
      centerTitle: true,
       leading: BackButton(color: ColorPickers.buttonBg),
      title: Text(
        'Select members',
        style: header_title,
      ),
      elevation: 0,
      actions: [
        TextButton(
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).buttonColor)),
          onPressed: () {
            if (_selectedUsers.toList().length < 1) {
              // Don't create a channel if there isn't another user selected
              return;
            }
            createChannel(
                    [for (final user in _selectedUsers.toList()) user.userId])
                .then((channel) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => GroupChannelView(groupChannel: channel),
                ),
              );
            }).catchError((error) {
              print(
                  'create_channel_view: navigationBar: createChannel: ERROR: $error');
            });
          },
          child: Text(
            "Create",
            style: createChannelColor,
          ),
        )
      ],
    );
  }

  Widget body(BuildContext context) {
    return ListView.builder(
        itemCount: _availableUsers.length,
        itemBuilder: (context, index) {
          User user = _availableUsers[index];
          if (user.userId == currentUser) return Container();
          return CheckboxListTile(
            title: Text(user.nickname.isEmpty ? user.userId : user.nickname,
                style: TextStyle(color: Colors.black)),
            controlAffinity: ListTileControlAffinity.platform,
            value: _selectedUsers.contains(user),
            // value: SendbirdSdk().currentUser.userId == user.userId,
            activeColor: Theme.of(context).primaryColor,
            onChanged: (bool value) {
              // Using a set to store which users we want to create
              // a channel with.
              setState(() {
                if (value) {
                  _selectedUsers.add(user);
                } else {
                  _selectedUsers.remove(user);
                }
              });
            },
            secondary: user.profileUrl.isEmpty
                ? CircleAvatar(
                    child: Text(
                    (user.nickname.isEmpty ? user.userId : user.nickname)
                        .substring(0, 1)
                        .toUpperCase(),
                  ))
                : CircleAvatar(
                    backgroundImage: NetworkImage(user.profileUrl),
                  ),
          );
        });
  }
}