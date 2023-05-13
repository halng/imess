import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imess/common/utils/colors.dart';
import 'package:imess/common/utils/helper.dart';
import 'package:imess/common/widgets/flow_button.dart';
import 'package:imess/feat/auth/controller/auth_controller.dart';
import 'package:imess/feat/auth/repository/auth_repository.dart';
import 'package:imess/feat/auth/screens/login_screen.dart';
import 'package:imess/feat/chat/screens/mobile_chat_screen.dart';
import 'package:imess/feat/post/controller/post_controller.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  bool isEdit = false;
  String username = '';
  String bio = '';

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      // get post lENGTH
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnackBar(
        context: context,
        content: e.toString(),
      );
    }
    username = userData['username'];
    bio = userData['bio'];
    setState(() {
      isLoading = false;
    });
  }

  void updateUser(String username, String bio) {
    if (username.isNotEmpty && bio.isNotEmpty) {
      ref.read(authControllerProvider).updateUser(context, username, bio);
      userData.update('username', (value) => username);
      userData.update('bio', (value) => bio);
      showSnackBar(context: context, content: 'Edit successfully');
      setState(() {
        isEdit = false;
      });
    } else {
      showSnackBar(context: context, content: 'Fill out all the fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: backgroundColor,
              title: Text(
                userData['username'],
              ),
              centerTitle: false,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(
                              userData['photoUrl'],
                            ),
                            radius: 40,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStatColumn(postLen, "posts"),
                                    buildStatColumn(followers, "followers"),
                                    buildStatColumn(following, "following"),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FirebaseAuth.instance.currentUser!.uid ==
                                            widget.uid
                                        ? FollowButton(
                                            text: 'Sign Out',
                                            backgroundColor: backgroundColor,
                                            textColor: primaryColor,
                                            borderColor: Colors.grey,
                                            function: () async {
                                              await AuthRepository(
                                                      auth:
                                                          FirebaseAuth.instance,
                                                      firestore:
                                                          FirebaseFirestore
                                                              .instance)
                                                  .signOut();
                                              // ignore: use_build_context_synchronously
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const LoginScreen(),
                                                ),
                                              );
                                            },
                                          )
                                        : isFollowing
                                            ? FollowButton(
                                                text: 'Unfollow',
                                                backgroundColor: Colors.white,
                                                textColor: Colors.black,
                                                borderColor: Colors.grey,
                                                function: () async {
                                                  await PostController()
                                                      .followUser(
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid,
                                                    userData['uid'],
                                                  );

                                                  setState(() {
                                                    isFollowing = false;
                                                    followers--;
                                                  });
                                                },
                                              )
                                            : FollowButton(
                                                text: 'Follow',
                                                backgroundColor: Colors.blue,
                                                textColor: Colors.white,
                                                borderColor: Colors.blue,
                                                function: () async {
                                                  await PostController()
                                                      .followUser(
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid,
                                                    userData['uid'],
                                                  );

                                                  setState(() {
                                                    isFollowing = true;
                                                    followers++;
                                                  });
                                                },
                                              ),
                                    FirebaseAuth.instance.currentUser!.uid !=
                                            widget.uid
                                        ? FollowButton(
                                            text: 'Chat Now',
                                            backgroundColor: backgroundColor,
                                            textColor: primaryColor,
                                            borderColor: Colors.grey,
                                            function: () async {
                                              Navigator.pushNamed(context,
                                                  MobileChatScreen.routeName,
                                                  arguments: {
                                                    'name':
                                                        userData["username"],
                                                    'uid': userData["uid"],
                                                    'profilePic':
                                                        userData["photoUrl"],
                                                    "isGroupChat": false
                                                  });
                                            },
                                          )
                                        : Container()
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      isEdit == false
                          ? GestureDetector(
                              onTap: () {
                                if (FirebaseAuth.instance.currentUser!.uid ==
                                    widget.uid) {
                                  setState(() {
                                    isEdit = true;
                                  });
                                }
                              },
                              child: Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.only(
                                    top: 15,
                                  ),
                                  child: Wrap(spacing: 50, children: [
                                    Text(
                                      userData['username'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      userData['bio'],
                                    ),
                                  ])),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.only(
                                        top: 15,
                                      ),
                                      child: Wrap(spacing: 50, children: [
                                        TextField(
                                          controller: TextEditingController(
                                              text: userData['username']),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          onChanged: (text) {
                                            username = text;
                                          },
                                        ),
                                        TextField(
                                          controller: TextEditingController(
                                              text: userData['bio']),
                                          onChanged: (text) {
                                            bio = text;
                                          },
                                        ),
                                      ])),
                                  FollowButton(
                                      text: 'Edit',
                                      backgroundColor: backgroundColor,
                                      textColor: primaryColor,
                                      borderColor: Colors.grey,
                                      function: () {
                                        updateUser(username, bio);
                                      }),
                                  FollowButton(
                                      text: 'Cancel',
                                      backgroundColor: backgroundColor,
                                      textColor: primaryColor,
                                      borderColor: Colors.grey,
                                      function: () {
                                        setState(() {
                                          isEdit = false;
                                        });
                                      })
                                ]),
                      // Container(
                      //   alignment: Alignment.centerLeft,
                      //   padding: const EdgeInsets.only(
                      //     top: 1,
                      //   ),
                      //   child: Text(
                      //     userData['bio'],
                      //   ),
                      // ),
                    ],
                  ),
                ),
                const Divider(),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 1.5,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        DocumentSnapshot snap =
                            (snapshot.data! as dynamic).docs[index];

                        return Image(
                          image: NetworkImage(snap['postUrl']),
                          fit: BoxFit.cover,
                        );
                      },
                    );
                  },
                )
              ],
            ),
          );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
