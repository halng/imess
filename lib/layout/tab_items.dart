import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:imess/feat/chat/screens/chat_screen.dart';
import 'package:imess/feat/feed/screen/feed_screen.dart';
import 'package:imess/feat/post/screen/add_post_screen.dart';
import 'package:imess/feat/profile/screen/profile_screen.dart';
import 'package:imess/feat/search/search_sreen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const ChatLayout(),
  const FeedScreen(),
  const AddPostScreen(),
  const SearchScreen(),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
