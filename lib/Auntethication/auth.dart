import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../Auntethication/auntethication.dart';
import '../models/model.dart' as model;

class Auth {
  final FirebaseAuth _auth = FirebaseAuth
      .instance; //The FirebaseAuth class is used to authenticate users and manage their authentication state using Firebase authentication services, such as email/password authentication, Google Sign-In, Facebook Login, etc.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.Users> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection("users").doc(currentUser.uid).get();
    return model.Users.fromSnap(snap);
  }

  Future<List<model.Users>> getAllUser() async {
    final snap = await _firestore.collection("users").get();
    final userData = snap.docs.map((e) => model.Users.fromSnap(e)).toList();
    return userData;
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String name,
    required Uint8List? file,
    required String role,
    // required String address,
    // required String dateOfBirth,
    // required String gender,
    // required String phone,
  }) async {
    String res = 'Somer error occurred';
    try {
      if (email.isNotEmpty || password.isNotEmpty || name.isNotEmpty) {
        //register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String photoUrl =
            await Storage().uploadImageToStorage('profilePics', file!, false);
        // Get the current date and time
        DateTime now = DateTime.now();

// Format the date and time as needed (e.g., in ISO 8601 format)
        String formattedDateTime = now.toIso8601String();
        //add user info to database
        model.Users user = model.Users(
          email: email,
          password: password,
          name: name,
          photoUrl: photoUrl,
          uid: cred.user!.uid,
          lastMessageTime: formattedDateTime,
          followers: [],
          following: [],
          role: role,
          // address: address,
          // dateOfBirth: dateOfBirth,
          // gender: gender,
          // phone: phone,
        );
        _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());
        res = 'success';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> signUpAdmin({
    required String email,
    required String password,
    required String name,
    required Uint8List? fileAdmin,
    required String role,
    required String address,
    required String dateOfBirth,
    required String gender,
    required String phone,
    required bool approved,
  }) async {
    String res = 'Somer error occurred';
    try {
      if (email.isNotEmpty || password.isNotEmpty || name.isNotEmpty) {
        //register admin
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String photoUrl = await Storage()
            .uploadImageToStorage('AdminPics', fileAdmin!, false);
        //add user info to database
        model.Admin user = model.Admin(
          email: email,
          password: password,
          name: name,
          photoUrl: photoUrl,
          uid: cred.user!.uid,
          role: role,
          address: address,
          dateOfBirth: dateOfBirth,
          gender: gender,
          phone: phone,
          approved: false,
        );
        _firestore.collection('Admins').doc(cred.user!.uid).set(user.toJson());
        res = 'success';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

//login user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = 'some error';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        //add user
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = 'Please enter all the fields';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //login Admin
  Future<String> loginAdmin({
    required String email,
    required String password,
  }) async {
    String res = 'some error';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        //add user
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = 'Please enter all the fields';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> handleSignOut() async {
    await _auth.signOut();
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
