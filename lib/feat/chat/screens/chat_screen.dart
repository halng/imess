import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imess/common/utils/colors.dart';
import 'package:imess/feat/auth/controller/auth_controller.dart';
import 'package:imess/feat/chat/widgets/contacts_list.dart';
import 'package:imess/feat/group/screens/create_group_screen.dart';
import 'package:imess/feat/select_contacts/screens/manage_user.dart';

class ChatLayout extends ConsumerStatefulWidget {
  const ChatLayout({Key? key}) : super(key: key);

  @override
  ConsumerState<ChatLayout> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends ConsumerState<ChatLayout>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        ref.read(authControllerProvider).setUserState(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: appBarColor,
            centerTitle: false,
            title: const Text(
              'iMess - Chat',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              // IconButton(
              //   icon: const Icon(Icons.search, color: Colors.grey),
              //   onPressed: () async {
              //     Navigator.pushNamed(context, SelectContactsScreen.routeName);
              //   },
              // ),
              PopupMenuButton(
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.grey,
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const Text(
                      'Create Group',
                    ),
                    onTap: () => Future(
                      () => Navigator.pushNamed(
                          context, CreateGroupScreen.routeName),
                    ),
                  )
                ],
              ),
            ]),
        body: const ContactsList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Navigator.pushNamed(context, ManageUserScreen.routeName);
          },
          backgroundColor: tabColor,
          child: const Icon(
            Icons.comment,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
