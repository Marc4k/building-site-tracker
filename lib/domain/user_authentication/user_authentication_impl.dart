import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../error/failures.dart';
import 'user_authentication.dart';

class UserAuthenticationImpl extends UserAuthentication {
  @override
  Future<void> signOutUser() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Future<Either<UserCredential, Failure>> signInUser(
      String email, String password) async {
    try {
      UserCredential user;

      user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      return left(user);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "network-request-failed":
          return right(UserAuthFailure(
              errorMessage:
                  "Oops, sieht so aus, als hätten Sie\nkeine Verbindung mehr."));

        case "wrong-password":
          return right(UserAuthFailure(
              errorMessage: "Leider ist das eingegebene Passwort falsch."));

        default:
          return right(UserAuthFailure(
              errorMessage: "Leider ist das eingegebene Passwort falsch."));
      }
    }
  }

  @override
  Future<Either<UserCredential, Failure>> signUpUser(
      String email, String password, String name) async {
    try {
      UserCredential user;

      user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final document = FirebaseFirestore.instance.collection('user').doc();

      await document.set({
        "name": name,
      });

      return left(user);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "email-already-in-use":
          return right(UserAuthFailure(
              errorMessage: "Leider ist diese E-Mail schon vergeben."));

        case "network-request-failed":
          return right(UserAuthFailure(
              errorMessage:
                  "Oops, sieht so aus, als hätten Sie\nkeine Verbindung mehr."));

        default:
          return right(UserAuthFailure(errorMessage: e.code));
      }
    }
  }

  @override
  Future<List<String>> getAllNames() async {
    List<String> names = [];

    await FirebaseFirestore.instance.collection("user").get().then((snapshot) {
      snapshot.docs.forEach((element) {
        //Object? data = element.data();
        Map<String, dynamic> data = element.data() as Map<String, dynamic>;

        names.add(data["name"]);
      });
    });

    return names;
  }

  @override
  Future<void> deleteUser({required String name}) async {
    UserCredential user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: "$name@tracker.at", password: "123456");

    String userId = user.user!.uid;

    await FirebaseFirestore.instance
        .collection("time")
        .where("userID", isEqualTo: userId)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((element) {
        //Object? data = element.data();
        Map<String, dynamic> data = element.data() as Map<String, dynamic>;

        element.reference.delete();
      });
    });

    await FirebaseFirestore.instance
        .collection("user")
        .where("name", isEqualTo: name)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((element) {
        //Object? data = element.data();
        Map<String, dynamic> data = element.data() as Map<String, dynamic>;

        element.reference.delete();
      });
    });

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? remove_user = auth.currentUser;
    remove_user!.delete();
  }
}
