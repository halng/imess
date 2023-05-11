import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:imess/layout/chat_layout.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const ChatLayout(),
  // const SearchScreen(),
  // const AddPostScreen(),
  // const Text('notifications'),
  // ProfileScreen(
  //   uid: FirebaseAuth.instance.currentUser!.uid,
  // ),
];
