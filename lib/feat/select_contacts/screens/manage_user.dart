import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imess/feat/group/controller/group_controller.dart';
import 'package:imess/feat/group/widgets/select_contacts_group.dart';

class ManageUserScreen extends ConsumerStatefulWidget {
  static const String routeName = '/select-contact';
  final String groupId;

  const ManageUserScreen({Key? key, required this.groupId}) : super(key: key);

  @override
  ConsumerState<ManageUserScreen> createState() => _ManageUserScreen();
}

class _ManageUserScreen extends ConsumerState<ManageUserScreen> {
  void addUser(WidgetRef ref, BuildContext context) {
    ref.read(groupControllerProvider).managerUser(
          context,
          widget.groupId,
          ref.read(selectedGroupContacts),
        );
    ref.read(selectedGroupContacts.notifier).update((state) => []);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("User List"),
          actions: [
            IconButton(
              onPressed: () {
                addUser(ref, context);
              },
              icon: const Icon(
                Icons.done,
              ),
            ),
          ],
        ),
        body: Center(
            child: Column(
          children: [SelectContactsGroup(groupId: widget.groupId)],
        )));
  }
}
