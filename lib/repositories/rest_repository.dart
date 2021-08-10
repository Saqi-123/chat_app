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
  // ********************************************************************************** 
  //                             add tags into firestore ....
  // ********************************************************************************** 

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
   // ********************************************************************************** 
  //                             Upload Image into firebase ....
  // ********************************************************************************** 

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
 // ********************************************************************************** 
  //                            Get User Profile ......
  // ********************************************************************************** 
  
   Future<UserProfileData> getUserData({@required String uid}) async {
    final data =
        (await getDocumentForUserDetails(_firestore, uid).get())
            .data();
    if (data == null) throw new ErrorDescription('User data not found.');
    return UserProfileData.fromJson(data);

  }
   // ********************************************************************************** 
  //                           Get User Profile Document
  // ********************************************************************************** 
  
  static DocumentReference getDocumentForUserDetails(
    FirebaseFirestore firestore,
    String uid, 
  ) =>
      firestore.doc('user_data/$uid');
// ********************************************************************************** 
//                          Store the image firebase storage ....
// ********************************************************************************** 
  

  static Reference getRootFolderForSkinConditionSessionImages(
    FirebaseStorage storage,
    String uid,
  ) =>
      storage.ref().child('user/$uid/private/image');

// ********************************************************************************** 
//               Save the image link into "User_date" into cloud_firestore....
// ********************************************************************************** 

  static DocumentReference getDocumentForSessionDetailsForSkinCondtion(
    FirebaseFirestore firestore,
    String uid,
  ) =>
      firestore.doc('user_data/$uid');
// ********************************************************************************** 
//                            Update user Profile .....
// ********************************************************************************** 


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
// ********************************************************************************** 
//                         Add Following and Follow User
// ********************************************************************************** 
  

  Future addFollowing(String otherUser, String currentUser) {
    try{
      var snapshot = _firestore.collection("user_data");
      snapshot.doc(otherUser)
      .collection("following_tag")
      .add({
        'id': currentUser
      });
      var followingQuery =snapshot.doc(currentUser)
      .collection("follow_tag")
      .add({'id': otherUser}).then((value) => 'update success!');
    return followingQuery;
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }
// ********************************************************************************** 
//                        UnFollow User 
// ********************************************************************************** 
  

  unFollowUser(String otherUserId, String currentUserId) async {
    try{
      var query = _firestore.collection("user_data");
      var querySnapshotFollowing =  query.doc(otherUserId).collection("following_tag").where("id", isEqualTo: currentUserId.trim());
      var querySnapshotFollow = query.doc(currentUserId).collection('follow_tag').where("id", isEqualTo: otherUserId.trim());
      await querySnapshotFollowing.get().then((item) {
      item.docs.forEach((doc) {
        doc.reference.delete();
      });
      });
      var deleteDoc = await querySnapshotFollow.get().then((value){
        value.docs.forEach((doc) {
          doc.reference.delete();
         });
      }).then((value) => 'update success!');
      return deleteDoc;

    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }
// ********************************************************************************** 
//                    Fetch the following and follow User Count
// ********************************************************************************** 
  

  fetchFollowsSection(String uuid) async{
    try {
      
      var query = _firestore.collection("user_data").doc(uuid);

      var followingSnapshotquery = await query
      .collection("following_tag").get().then((value)  {
        if(value.docs.length > 0) {
          return value.size;
        } else {
          return 0;
        }
      });

      var followSnapshotQuery = await query.collection("follow_tag").get().then((value) {
        if (value.docs.length > 0) {
           return value.size;
        } else {
          return 0;
        }
      });
      var send = [{'following': followingSnapshotquery}, {'follow': followSnapshotQuery}];
      return send;
    }on FirebaseException catch (e) {
      return Future.error(e);
    }
  }

// ********************************************************************************** 
//                   Check Current User is Already Following the other User
// ********************************************************************************** 

  isAlreadyFollowTheUser(String otherUserId, String currentUserId) async{
    var isAlreadyFollows;
    try{
      var query = _firestore.collection("user_data").doc(otherUserId);
       await query.collection("following_tag").get().then((value) {
        if (value.docs.length > 0) {
          value.docs.forEach((item) {
            if (item.data()['id'] == currentUserId) {
              isAlreadyFollows = true;
            }else {
              isAlreadyFollows =  false;
            }
          });
        }
      });
      return isAlreadyFollows;
    }on FirebaseException catch(error) {
      return Future.error(error);
    }

  }
}
