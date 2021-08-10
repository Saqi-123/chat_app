import 'package:sendbird_sdk/core/models/user.dart';
import 'package:sendbird_sdk/sdk/sendbird_sdk_api.dart';

class SendBirdAuth{
  SendBirdAuth();
  final sendbird = SendbirdSdk();
  // ignore: unused_element
Future<User> connect(String appId, String userId, String name, ) async {
    try {
      final sendbird = SendbirdSdk(appId: appId);
      final user = await sendbird.connect(userId, nickname: name);
      return user;
    } catch (e) {
      print('login_view: connect: ERROR: $e');
      throw e;
    }
  }
}