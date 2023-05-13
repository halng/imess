import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:imess/common/repos/firebase_storage.dart';
import 'package:imess/common/utils/helper.dart';
import 'package:imess/models/group.dart' as model;

final groupRepositoryProvider = Provider(
  (ref) => GroupRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref,
  ),
);

class GroupRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;
  GroupRepository({
    required this.firestore,
    required this.auth,
    required this.ref,
  });

  void createGroup(BuildContext context, String name, File profilePic,
      List<String> uids) async {
    try {
      var groupId = const Uuid().v1();

      String profileUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
            'group/$groupId',
            profilePic,
          );
      model.Group group = model.Group(
        senderId: auth.currentUser!.uid,
        name: name,
        groupId: groupId,
        lastMessage: '',
        groupPic: profileUrl,
        membersUid: [auth.currentUser!.uid, ...uids],
        timeSent: DateTime.now(),
      );

      await firestore.collection('groups').doc(groupId).set(group.toMap());
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void addUserIntoGroup(
      BuildContext context, String groupUid, String userUid) async {
    try {
      await firestore.collection("groups").doc(groupUid).update({
        'membersUid': FieldValue.arrayUnion([userUid]),
      });
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void delUserIntoGroup(
      BuildContext context, String groupUid, String userUid) async {
    try {
      await firestore.collection("groups").doc(groupUid).update({
        'membersUid': FieldValue.arrayRemove([userUid]),
      });
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void delGroup(BuildContext context, String groupUid) async {
    try {
      await firestore.collection("groups").doc(groupUid).delete();
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void delChat(BuildContext context, String senderId, String receiverId) async {
    try {
      await firestore
          .collection("users")
          .doc('$senderId/chats/$receiverId')
          .delete();
      await firestore
          .collection("users")
          .doc('$receiverId/chats/$senderId')
          .delete();
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
