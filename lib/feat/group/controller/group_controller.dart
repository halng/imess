import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:imess/feat/group/repository/group_repository.dart';

final groupControllerProvider = Provider((ref) {
  final groupRepository = ref.read(groupRepositoryProvider);
  return GroupController(
    groupRepository: groupRepository,
    ref: ref,
  );
});

class GroupController {
  final GroupRepository groupRepository;
  final ProviderRef ref;
  GroupController({
    required this.groupRepository,
    required this.ref,
  });

  void createGroup(
      BuildContext context, String name, File profilePic, List<String> uids) {
    groupRepository.createGroup(context, name, profilePic, uids);
  }

  void managerUser(BuildContext context, String groupId, List<String> userId) {
    groupRepository.addUserIntoGroup(context, groupId, userId);
  }
  
  void delGroup(BuildContext context, String groupId) {
    groupRepository.delGroup(context, groupId);
  }

  void delChat(BuildContext context, String senderId, String receiverId) {
    groupRepository.delChat(context, senderId, receiverId);
  }
}
