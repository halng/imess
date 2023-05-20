import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final bool isOnline;
  final String bio;
  final String phoneNumber;
  final List followers;
  final List following;
  final List groupId;

  const UserModel(
      {required this.username,
      required this.uid,
      required this.photoUrl,
      required this.email,
      required this.bio,
      required this.followers,
      required this.following,
      required this.isOnline,
      required this.phoneNumber,
      required this.groupId});

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
        username: snapshot["username"],
        uid: snapshot["uid"],
        email: snapshot["email"],
        photoUrl: snapshot["photoUrl"],
        bio: snapshot["bio"],
        isOnline: snapshot["isOnline"],
        phoneNumber: snapshot["phoneNumber"],
        followers: snapshot["followers"],
        following: snapshot["following"],
        groupId: snapshot["groupId"]);
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "bio": bio,
        "followers": followers,
        "following": following,
        "groupId": groupId,
        "isOnline": isOnline,
        "phoneNumber": phoneNumber
      };
}
