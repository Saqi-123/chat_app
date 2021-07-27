import 'package:sendbird_sdk/sdk/sendbird_sdk_api.dart';

class SendBirdRepos{
  SendBirdRepos();
  final sendbird = SendbirdSdk();
  // ignore: unused_element
  Future<dynamic> connectToSendbirdServer(String uuid) async {
      try {
    final user = await sendbird.connect(uuid);
    print('User Connected to SendBird Server $user');
    return user;
    // The user is connected to Sendbird server.
} catch (e) {
    print('called on Catch Handler $e' );
}
  }
}