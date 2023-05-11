import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:imess/feat/chat/screens/chat_screen.dart';

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
