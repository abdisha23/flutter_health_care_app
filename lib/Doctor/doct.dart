//import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../Auntethication/storage.dart';
import '../models/model.dart' as model;

class Doct {
  final FirebaseAuth _docAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestoreOfDoctor = FirebaseFirestore.instance;

  // Future<model.DoctorInformation> getDoctorDetails() async {
  //   User currentUser = _docAuth.currentUser!;
  //   DocumentSnapshot snap = await _firestoreOfDoctor
  //       .collection("Doctor")
  //       .doc(currentUser.uid)
  //       .get();
  //   return model.DoctorInformation.fromSnap(snap);
  // }

  // Stream<List<model.DoctorInformation>> readDoctors() =>
  //     FirebaseFirestore.instance.collection('Doctor').snapshots().map(
  //         (snapshot) => snapshot.docs
  //             .map((doc) => model.DoctorInformation.fromSnap(
  //                 doc.data() as DocumentSnapshot<Object?>))
  //             .toList());

  Future<String> signUpDoctor({
    required String email,
    required String password,
    required String name,
    required String speciality,
    // required String experience,
    // required String location,
    required String language,
    // required bool telemedicineAvailable,
    // required List<String> servicesOffered,
    // required String education,
    required String contact,
    // required bool available,
    // required String pricing,
    required String gender,
    required Uint8List file,
    required Uint8List docIdFile,
    required String doctorId,
    required List<String> availableDates,
    required List<String> availableTimeRanges,
    required String role,
    required bool approved,
  }) async {
    String res = 'Some error';
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          name.isNotEmpty ||
          speciality.isNotEmpty) {
        UserCredential cred = await _docAuth.createUserWithEmailAndPassword(
            email: email, password: password);
        String profilePictureUrl =
            await Storage().uploadImageToStorage('doctorsPics', file, false);
        String doctordoc = await Storage()
            .uploadImageToStorage('doctorsDocs', docIdFile, false);
        model.DoctorInformation doctor = model.DoctorInformation(
          docPhotoUrl: profilePictureUrl,
          doctorDoc: doctordoc,
          email: email,
          password: password,
          name: name,
          speciality: speciality,
          // experience: experience,
          // profilePictureUrl: profilePictureUrl,
          // location: location,
          language: language,
          // telemedicineAvailable: telemedicineAvailable,
          // servicesOffered: servicesOffered,
          // education: education,
          contact: contact,
          // available: available,
          // pricing: pricing,
          gender: gender,
          doctorId: cred.user!.uid,
          availableDates: availableDates,
          availableTimeRanges: availableTimeRanges,
          role: role,
          lastMessageTime: DateTime.now().toIso8601String(),
          approved: false,
        );
        _firestoreOfDoctor
            .collection('Doctor')
            .doc(cred.user!.uid)
            .set(doctor.toJson());
        res = 'success';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> loginDoctor({
    required String email,
    required String password,
  }) async {
    String res = 'some error';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        //add user
        await _docAuth.signInWithEmailAndPassword(
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
}
