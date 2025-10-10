import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
  bool isLoading = false;

  FirebaseAuth auth = FirebaseAuth.instance;
  UserCredential? firebaseUser;
  Map<String, dynamic> userData = {};

  void signUp({
    required Map<String, dynamic> userData,
    required String pass,
    required VoidCallback onOnSucess,
    required VoidCallback onFail,
  }) {
    isLoading = true;
    notifyListeners();

    auth
        .createUserWithEmailAndPassword(email: userData['email'], password: pass)
        .then((user) async {
          firebaseUser = user;
          onOnSucess();

          await saveUserData(userData);

          isLoading = false;
          notifyListeners();
        })
        .catchError((e) {
          log(e);
          onFail();
          isLoading = false;
          notifyListeners();
        });
  }

  void signIn() async {}

  void recoverPass() {}

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await FirebaseFirestore.instance.collection('users').doc(firebaseUser?.user?.uid).set(userData);
  }
}
