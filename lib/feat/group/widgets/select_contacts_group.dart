import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imess/common/widgets/error.dart';
import 'package:imess/common/widgets/loader.dart';
import 'package:imess/feat/select_contacts/controller/select_contact_controller.dart';
import 'package:imess/models/group.dart';

final selectedGroupContacts = StateProvider<List<String>>((ref) => []);

class SelectContactsGroup extends ConsumerStatefulWidget {
  final String groupId;
  const SelectContactsGroup({Key? key, required this.groupId})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectContactsGroupState();
}

class _SelectContactsGroupState extends ConsumerState<SelectContactsGroup> {
  void selectContact(String uid) {
    if (ref.read(selectedGroupContacts).contains(uid)) {
      setState(() {});
      ref.read(selectedGroupContacts).remove(uid);
    } else {
      setState(() {});
      ref.read(selectedGroupContacts).add(uid);
      // .update((state) => [...state, uid]);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.groupId != "NULL") {
      FirebaseFirestore.instance
          .collection('groups')
          .doc(widget.groupId)
          .get()
          .then((value) {
        Group group = Group.fromMap(value.data()!);
        ref.read(selectedGroupContacts).clear();
        ref.read(selectedGroupContacts).addAll([...group.membersUid]);
        // .update((state) => [...group.membersUid]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getUserProvider).when(
          data: (contactList) => Expanded(
            child: ListView.builder(
                itemCount: contactList.length,
                itemBuilder: (context, index) {
                  final contact = contactList[index];
                  return InkWell(
                    onTap: () => selectContact(contact["uid"]!),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(
                          contact["username"]!,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        leading: ref
                                .watch(selectedGroupContacts)
                                .contains(contact["uid"])
                            ? IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.check_box),
                              )
                            : IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.check_box_outline_blank),
                              ),
                      ),
                    ),
                  );
                }),
          ),
          error: (err, trace) => ErrorScreen(
            error: err.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}
