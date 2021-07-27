import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sign_in_flutter/rest_modal/user_profile_data.dart';

class RestRepository {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;
  RestRepository();
  Future addUser(String id, String email, String name) {
    try {
      var snapshot = _firestore.collection('user_data').doc(id).set({
        'id': id,
        'email': email,
        'name': name,
      }).then((value) => 'success!');
      return snapshot;
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }
  // add tags into firestore ....
  Future addTags(String id,var tags) {
    try{
       var snapshot = _firestore.collection('user_data').doc(id).set({
      'tags': FieldValue.arrayUnion(tags)
    },SetOptions(merge: true)).then((value) => 'update success!');
    return snapshot;
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }
  // Upload Image into firebase ....

  Future uploadImageToFirebase(String id, File image) async {
    try {
      // upload images to storage bucket and get urls
      final storageRef = getRootFolderForSkinConditionSessionImages(
        _storage,
        id,
      );
      var filename = basename(image.path);
      var ref = storageRef.child('$filename');

      final uploadTask = ref.putFile(image);
      final snapshot = await uploadTask;
      final downloadURL = await snapshot.ref.getDownloadURL();

      // update firestore database with urls
      getDocumentForSessionDetailsForSkinCondtion(_firestore, id)
          .set({'image_urls': downloadURL}, SetOptions(merge: true));

      return downloadURL;
    } catch (e) {
      throw e;
    }
  }

  // Get User Profile ......
   Future<UserProfileData> getUserData({@required String uid}) async {
     print('called User ID $uid');
    final data =
        (await getDocumentForUserDetails(_firestore, uid).get())
            .data();
    if (data == null) throw new ErrorDescription('User data not found.');
    return UserProfileData.fromJson(data);
  // }

  }

  // Get User Profile Document
  static DocumentReference getDocumentForUserDetails(
    FirebaseFirestore firestore,
    String uid, 
  ) =>
      firestore.doc('user_data/$uid');

  // Store the image firebase storage ....

  static Reference getRootFolderForSkinConditionSessionImages(
    FirebaseStorage storage,
    String uid,
  ) =>
      storage.ref().child('user/$uid/private/image');

  // Save the image link into "User_date" into cloud_firestore....

  static DocumentReference getDocumentForSessionDetailsForSkinCondtion(
    FirebaseFirestore firestore,
    String uid,
  ) =>
      firestore.doc('user_data/$uid');

// Update user Profile .....
Future updateUserProfile(String id, String name,String username, String bio, String link, var tags) {
    try {
      var snapshot = _firestore.collection('user_data').doc(id).set({
        'id': id,
        'name': name,
        'username': username,
        'bio': bio,
        'link': link,
        'tags': FieldValue.arrayUnion(tags)
      }, SetOptions(merge: true)).then((value) => 'success!');
      return snapshot;
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }

}
