import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/model.dart';

class DoctorProvider with ChangeNotifier {
  List<DoctorInformation> _doctors = [];
  List<DoctorInformation> get doctors => _doctors;

  DoctorInformation? _currentDoctor;
  DoctorInformation? get currentUser => _currentDoctor!;

  Future<void> fetchDoctors() async {
    try {
      QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
          .collection('Doctor')
          .orderBy(DoctorField.lastMessageTime, descending: true)
          .get();
      List<DoctorInformation> doctors = [];
      for (QueryDocumentSnapshot userSnapshot in usersSnapshot.docs) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        String name = userData['name'] ?? '';
        String email = userData['email'] ?? '';
        String password = userData['password'] ?? '';
        List<String> availableDates =
            (userData['availableDates'] ?? []).cast<String>();
        List<String> availableTimeRanges =
            (userData['availableTimeRanges'] ?? []).cast<String>();
        String contact = userData['contact'] ?? '';
        String docPhotoUrl = userData['docPhotoUrl'] ?? '';
        String doctorDoc = userData['doctorDoc'] ?? '';
        String doctorId = userData['doctorId'] ?? '';
        String gender = userData['gender'] ?? '';
        String language = userData['language'] ?? '';
        String speciality = userData['speciality'] ?? '';
        String role = userData['role'] ?? '';
        bool approved = userData['approved'] ?? '';
        String lastMessageTime = userData['lastMessageTime'] ?? '';

        DoctorInformation doctor = DoctorInformation(
            name: name,
            email: email,
            password: password,
            availableDates: availableDates,
            availableTimeRanges: availableTimeRanges,
            contact: contact,
            docPhotoUrl: docPhotoUrl,
            doctorDoc: doctorDoc,
            doctorId: doctorId,
            gender: gender,
            language: language,
            speciality: speciality,
            role: role,
            approved: approved,
            lastMessageTime: lastMessageTime);
        doctors.add(doctor);
      }
      _doctors = doctors;
      notifyListeners();
    } catch (error) {
      print('Error fetching doctors: $error');
    }
  }

  Future<void> fetchCurrentDoctor(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Doctor')
          .doc(userId)
          .get();
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      String name = userData['name'] ?? '';
      String email = userData['email'] ?? '';
      String password = userData['password'] ?? '';
      List<String> availableDates =
          (userData['availableDates'] ?? []).cast<String>();
      List<String> availableTimeRanges =
          (userData['availableTimeRanges'] ?? []).cast<String>();
      String contact = userData['contact'] ?? '';
      String docPhotoUrl = userData['docPhotoUrl'] ?? '';
      String doctorDoc = userData['doctorDoc'] ?? '';
      String doctorId = userData['doctorId'] ?? '';
      String gender = userData['gender'] ?? '';
      String language = userData['language'] ?? '';
      String speciality = userData['speciality'] ?? '';
      String role = userData['role'] ?? '';
      bool approved = userData['approved'] ?? '';
      String lastMessageTime = userData['lastMessageTime'] ?? '';

      DoctorInformation doctor = DoctorInformation(
          name: name,
          email: email,
          password: password,
          availableDates: availableDates,
          availableTimeRanges: availableTimeRanges,
          contact: contact,
          docPhotoUrl: docPhotoUrl,
          doctorDoc: doctorDoc,
          doctorId: doctorId,
          gender: gender,
          language: language,
          speciality: speciality,
          role: role,
          approved: approved,
          lastMessageTime: lastMessageTime);
      _currentDoctor = doctor;
      notifyListeners();
    } catch (error) {
      print('Error fetching current doctor: $error');
    }
  }
}
