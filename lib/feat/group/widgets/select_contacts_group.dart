import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imess/common/widgets/error.dart';
import 'package:imess/common/widgets/loader.dart';
import 'package:imess/feat/select_contacts/controller/select_contact_controller.dart';

final selectedGroupContacts = StateProvider<List<String>>((ref) => []);

class SelectContactsGroup extends ConsumerStatefulWidget {
  const SelectContactsGroup({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectContactsGroupState();
}

class _SelectContactsGroupState extends ConsumerState<SelectContactsGroup> {
  List<int> selectedContactsIndex = [];

  void selectContact(int index, String uid) {
    if (selectedContactsIndex.contains(index)) {
      selectedContactsIndex.removeAt(index);
    } else {
      selectedContactsIndex.add(index);
    }
    setState(() {});
    ref
        .read(selectedGroupContacts.notifier)
        .update((state) => [...state, uid]);
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
                    onTap: () => selectContact(index, contact["uid"]!),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(
                          contact["username"]!,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        leading: selectedContactsIndex.contains(index)
                            ? IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.done),
                              )
                            : null,
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
