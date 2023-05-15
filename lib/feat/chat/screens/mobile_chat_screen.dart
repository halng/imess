import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imess/common/utils/colors.dart';
import 'package:imess/common/widgets/loader.dart';
import 'package:imess/feat/auth/controller/auth_controller.dart';
import 'package:imess/feat/call/controller/call_controller.dart';
import 'package:imess/feat/call/screens/call_pickup_screen.dart';
import 'package:imess/feat/chat/widgets/bottom_chat_field.dart';
import 'package:imess/feat/group/controller/group_controller.dart';
import 'package:imess/feat/select_contacts/screens/manage_user.dart';
import 'package:imess/models/user_model.dart';
import 'package:imess/feat/chat/widgets/chat_list.dart';

class MobileChatScreen extends ConsumerWidget {
  static const String routeName = '/mobile-chat-screen';
  final String name;
  final String uid;
  final bool isGroupChat;
  final String profilePic;
  const MobileChatScreen({
    Key? key,
    required this.name,
    required this.profilePic,
    required this.uid,
    required this.isGroupChat,
  }) : super(key: key);

  void makeCall(WidgetRef ref, BuildContext context) {
    ref.read(callControllerProvider).makeCall(
          context,
          name,
          uid,
          profilePic,
          isGroupChat,
        );
  }

  void delChat(
      WidgetRef ref, BuildContext context, bool isGroupChat, String groupId) {
    if (isGroupChat) {
      ref.read(groupControllerProvider).delGroup(context, groupId);
    } else {
      ref
          .read(groupControllerProvider)
          .delChat(context, groupId, FirebaseAuth.instance.currentUser!.uid);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CallPickupScreen(
      scaffold: Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: isGroupChat
              ? Text(name)
              : StreamBuilder<UserModel>(
                  stream: ref.read(authControllerProvider).userDataById(uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Loader();
                    }
                    return Column(
                      children: [
                        Text(name),
                        Text(
                          snapshot.data!.isOnline ? 'online' : 'offline',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    );
                  }),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () => makeCall(ref, context),
              icon: const Icon(Icons.video_call),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.call),
            ),
            PopupMenuButton(
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.grey,
                ),
                itemBuilder: (context) => isGroupChat
                    ? [
                        PopupMenuItem(
                            child: const Text(
                              'Add/Del User',
                            ),
                            onTap: () => Future(
                                  () => Navigator.pushNamed(
                                      context, ManageUserScreen.routeName,
                                      arguments: {"groupId": uid}),
                                )),
                        PopupMenuItem(
                            child: const Text(
                              'Del Group',
                            ),
                            onTap: () {
                              delChat(ref, context, isGroupChat, uid);
                              Navigator.pop(context);
                            })
                      ]
                    : [
                        PopupMenuItem(
                            child: const Text(
                              'Del Chat',
                            ),
                            onTap: () {
                              delChat(ref, context, isGroupChat, uid);
                              Navigator.pop(context);
                            })
                      ]),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ChatList(
                recieverUserId: uid,
                isGroupChat: isGroupChat,
              ),
            ),
            BottomChatField(
              recieverUserId: uid,
              isGroupChat: isGroupChat,
            ),
          ],
        ),
      ),
    );
  }
}
