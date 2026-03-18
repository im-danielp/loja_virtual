import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
  bool isLoading = false;

  FirebaseAuth auth = FirebaseAuth.instance;
  User? firebaseUser;
  Map<String, dynamic> userData = {};

  UserModel() {
    _loadCurrentUser();
  }

  static UserModel of(BuildContext context) => ScopedModel.of<UserModel>(context);

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
        .then((userCredential) async {
          firebaseUser = userCredential.user;
          await saveUserData(userData);
          onOnSucess();
          isLoading = false;
          notifyListeners();
        })
        .catchError((e) {
          log(e.toString());
          onFail();
          isLoading = false;
          notifyListeners();
        });
  }

  void signIn({
    required String email,
    required String pass,
    required VoidCallback onSucess,
    required VoidCallback onFail,
  }) async {
    auth
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((userCredential) async {
          firebaseUser = userCredential.user;
          await _loadCurrentUser();
          onSucess();
          isLoading = false;
          notifyListeners();
        })
        .catchError((e) {
          onFail();
          firebaseUser = null;
          isLoading = false;
          notifyListeners();
        });
  }

  void recoverPass(String email) {
    auth.sendPasswordResetEmail(email: email);
  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await FirebaseFirestore.instance.collection('users').doc(firebaseUser?.uid).set(userData);
  }

  void signOut() async {
    await auth.signOut();
    userData = {};
    firebaseUser = null;
    notifyListeners();
  }

  Future<void> _loadCurrentUser() async {
    firebaseUser ??= auth.currentUser;
    if (firebaseUser != null && userData.isEmpty) {
      DocumentSnapshot docUser = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser?.uid)
          .get();
      userData = docUser.data() as Map<String, dynamic>? ?? {};
      notifyListeners();
    }
  }
}
