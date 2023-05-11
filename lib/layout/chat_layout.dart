// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:imess/common/utils/colors.dart';
// import 'package:imess/common/utils/helper.dart';
// import 'package:imess/feat/auth/controller/auth_controller.dart';
// import 'package:imess/feat/chat/widgets/contacts_list.dart';
// import 'package:imess/feat/group/screens/create_group_screen.dart';
// import 'package:imess/feat/select_contacts/screens/select_contacts_screen.dart';
// import 'package:imess/feat/status/screens/confirm_status_screen.dart';
// import 'package:imess/feat/status/screens/status_contacts_screen.dart';

// class ChatLayout extends ConsumerStatefulWidget {
//   const ChatLayout({Key? key}) : super(key: key);

//   @override
//   ConsumerState<ChatLayout> createState() => _MobileLayoutScreenState();
// }

// class _MobileLayoutScreenState extends ConsumerState<ChatLayout>
//     with WidgetsBindingObserver, TickerProviderStateMixin {
//   late TabController tabBarController;
//   @override
//   void initState() {
//     super.initState();
//     tabBarController = TabController(length: 3, vsync: this);
//     WidgetsBinding.instance.addObserver(this);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     WidgetsBinding.instance.removeObserver(this);
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     super.didChangeAppLifecycleState(state);
//     switch (state) {
//       case AppLifecycleState.resumed:
//         ref.read(authControllerProvider).setUserState(true);
//         break;
//       case AppLifecycleState.inactive:
//       case AppLifecycleState.detached:
//       case AppLifecycleState.paused:
//         ref.read(authControllerProvider).setUserState(false);
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         appBar: AppBar(
//           elevation: 0,
//           backgroundColor: appBarColor,
//           centerTitle: false,
//           title: const Text(
//             'iMess - Chat',
//             style: TextStyle(
//               fontSize: 20,
//               color: Colors.grey,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.search, color: Colors.grey),
//               onPressed: () {},
//             ),
//             PopupMenuButton(
//               icon: const Icon(
//                 Icons.more_vert,
//                 color: Colors.grey,
//               ),
//               itemBuilder: (context) => [
//                 PopupMenuItem(
//                   child: const Text(
//                     'Create Group',
//                   ),
//                   onTap: () => Future(
//                         () => Navigator.pushNamed(
//                         context, CreateGroupScreen.routeName),
//                   ),
//                 )
//               ],
//             ),
//           ],
//           bottom: TabBar(
//             controller: tabBarController,
//             indicatorColor: tabColor,
//             indicatorWeight: 4,
//             labelColor: tabColor,
//             unselectedLabelColor: Colors.grey,
//             labelStyle: const TextStyle(
//               fontWeight: FontWeight.bold,
//             ),
//             tabs: const [
//               Tab(
//                 text: 'CHATS',
//               ),
//               Tab(
//                 text: 'STATUS',
//               ),
//               Tab(
//                 text: 'CALLS',
//               ),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           controller: tabBarController,
//           children: const [
//             ContactsList(),
//             StatusContactsScreen(),
//             Text('Calls')
//           ],
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () async {
//             if (tabBarController.index == 0) {
//               Navigator.pushNamed(context, SelectContactsScreen.routeName);
//             } else {
//               File? pickedImage = await pickImageFromGallery(context);
//               if (pickedImage != null) {
//                 Navigator.pushNamed(
//                   context,
//                   ConfirmStatusScreen.routeName,
//                   arguments: pickedImage,
//                 );
//               }
//             }
//           },
//           backgroundColor: tabColor,
//           child: const Icon(
//             Icons.comment,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imess/common/utils/colors.dart';
import 'package:imess/common/utils/helper.dart';
import 'package:imess/feat/auth/controller/auth_controller.dart';
import 'package:imess/feat/chat/widgets/contacts_list.dart';
import 'package:imess/feat/group/screens/create_group_screen.dart';
import 'package:imess/feat/select_contacts/screens/select_contacts_screen.dart';
import 'package:imess/feat/status/screens/confirm_status_screen.dart';
import 'package:imess/feat/status/screens/status_contacts_screen.dart';

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
              IconButton(
                icon: const Icon(Icons.search, color: Colors.grey),
                onPressed: () {},
              ),
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
            Navigator.pushNamed(context, SelectContactsScreen.routeName);
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
