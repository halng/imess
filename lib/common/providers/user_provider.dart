import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:imess/feat/auth/repository/auth_repository.dart';
import 'package:imess/models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;

  UserModel get getUser => _user!;

  Future<void> refreshUser() async {
    UserModel? user = await AuthRepository(
            auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance)
        .getCurrentUserData();
    _user = user;
    notifyListeners();
  }
}
