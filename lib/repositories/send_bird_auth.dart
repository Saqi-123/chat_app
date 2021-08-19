import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pPath;
import 'package:sendbird_sdk/core/models/user.dart';
import 'package:sendbird_sdk/sdk/sendbird_sdk_api.dart';
import 'package:sign_in_flutter/repositories/rest_repository.dart';

class SendBirdAuth{
  SendBirdAuth();
  final sendbird = SendbirdSdk();
   final RestRepository restRepository = RestRepository();
  // ignore: unused_element
Future<User> connect(String appId, String userId, String name, String token) async {
    try {
      final sendbird = SendbirdSdk(appId: appId);
      final user = await sendbird.connect(userId, nickname: name, accessToken: token);
      return user;
    } catch (e) {
      print('login_view: connect: ERROR: $e');
      throw e;
    }
  }

// **************************************************************
//             Create a User through API PLATFORM
// **************************************************************

createUser(String userId, String name, File profileImage) async {
    final downloadImage = await restRepository.uploadImage(userId, profileImage);
  try{
     final headers = 
     {
       "Content-Type": "application/json",
       "Api-Token": "bfa9466e49bbd7aa58d8aa6684f8860d823102a5"
      };
      final body = json.encode({
        "user_id": userId,
        "nickname": name,
        "profile_url": downloadImage,
        "issue_access_token": true,
        "session_token_expires_at": 1542945056625,
      });
    final res = await http.post(Uri.parse('https://api-28A97237-32B3-4FA8-A220-2A9B8BB17026.sendbird.com/v3/users'),headers: headers, body: body);
    return res;

  }catch (e) {
      print('login_view: connect: ERROR: $e');
      throw e;
    }
}

// **************************************************************
// Checking User is Already register or not
// **************************************************************

checkingUser(String uuid) async {
  try{
      final headers = 
     {
       "Content-Type": "application/json",
       "Api-Token": "bfa9466e49bbd7aa58d8aa6684f8860d823102a5"
      };
    final user = await http.get(Uri.parse('https://api-28A97237-32B3-4FA8-A220-2A9B8BB17026.sendbird.com/v3/users/$uuid'),headers: headers);
    if (user.statusCode == 200) {
      return {'found':"found", 'body':json.decode(user.body)};
    } else { return "not found";}
  } catch (e) {
      print('login_view: connect: ERROR: $e');
      return "not found";
      // throw e;
    }
}
 
}