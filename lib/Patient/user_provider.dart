import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthcare_app/Auntethication/auth.dart';

import 'user.dart';

class UserProvider with ChangeNotifier {
  //for refreshUsers
  Users? _user;
  final Auth _auth = Auth();
  //Users get getCurrentUser => _user!;
  //for fetchUsers function
  List<Users> _users = [];
  List<Users> get getUsers => _users;

  Future<void> fetchUsers() async {
    try {
      QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .orderBy(UserField.lastMessageUserTime, descending: true)
          .get();
      List<Users> users = [];
      for (QueryDocumentSnapshot userSnapshot in usersSnapshot.docs) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        String name = userData['name'] ?? '';
        String email = userData['email'] ?? '';
        String password = userData['password'] ?? '';
        String photoUrl = userData['photoUrl'] ?? '';
        String uid = userData['uid'] ?? '';
        List followers = userData['followers'] ?? '';
        List following = userData['following'] ?? '';
        String lastMessageTime = userData['lastMessageTime'] ?? '';
        String role = userData['role'] ?? '';

        Users user = Users(
            name: name,
            email: email,
            password: password,
            photoUrl: photoUrl,
            uid: uid,
            followers: followers,
            following: following,
            role: role,
            lastMessageTime: lastMessageTime);
        users.add(user);
      }
      _users = users;
      notifyListeners();
    } catch (error) {
      print('Error fetching users: $error');
    }
  }

  Users? _currentUser;

  Users get getCurrentUser => _currentUser!;

  // Future<void> fetchCurrentUser(String userId) async {
  //   try {
  //     DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(userId)
  //         .get();

  //     _currentUser = Users(
  //       name: userSnapshot.get('name'),
  //       email: userSnapshot.get('email'),
  //       password: userSnapshot.get('password'),
  //       photoUrl: userSnapshot.get('photoUrl'),
  //       lastMessageTime: userSnapshot.get('lastMessageTime'),
  //       uid: userSnapshot.get('uid'),
  //       followers: userSnapshot.get("followers"),
  //       following: userSnapshot.get("following"),
  //       // Add other user properties as needed
  //     );
  //     notifyListeners();
  //   } catch (error) {
  //     print('Error fetching current user: $error');
  //   }
  // }
  Future<void> fetchCurrentUser(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      //List<Users> users = [];

      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      String name = userData['name'] ?? '';
      String email = userData['email'] ?? '';
      String password = userData['password'] ?? '';
      String photoUrl = userData['photoUrl'] ?? '';
      String uid = userData['uid'] ?? '';
      List followers = userData['followers'] ?? '';
      List following = userData['following'] ?? '';
      String lastMessageTime = userData['lastMessageTime'] ?? '';
      String role = userData['role'] ?? '';

      Users user = Users(
          name: name,
          email: email,
          password: password,
          photoUrl: photoUrl,
          uid: uid,
          followers: followers,
          following: following,
          role: role,
          lastMessageTime: lastMessageTime);
      _currentUser = user;
      notifyListeners();
    } catch (error) {
      print('Error fetching current user: $error');
    }
  }
}
