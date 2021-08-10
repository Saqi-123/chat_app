import 'dart:io';

import 'package:http/http.dart' as http;
class SendBirdRepository {
  SendBirdRepository();
  Future<http.Response> updateUserProfile(String appId, String uuid, String name, String image) {
    final userProfile = {
      "user_id": uuid,
      "nickname": name,
      "profile_url": image,
      "issue_access_token": 'true',
      "session_token_expires_at": "1542945056625",
    };
    // https://api-28A97237-32B3-4FA8-A220-2A9B8BB17026.sendbird.com
  return http.post(Uri.parse('https://api-28A97237-32B3-4FA8-A220-2A9B8BB17026.sendbird.com/v3/users/$uuid'),body: userProfile );
}
}