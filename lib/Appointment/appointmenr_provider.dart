import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/model.dart';
import '../models/model.dart' as model;

class AppointmentsProvider with ChangeNotifier {
  List<Appointment> _appointments = [];
  List<Appointment> get appointments => _appointments;

  Appointment? _currentAppointment;
  Appointment? get currentAppointment => _currentAppointment;
  Future<String> addAppointment({
    required String doctorId,
    required String userId,
    required String date,
    required timeRange,
  }) async {
    String res = 'Some error';
    try {
      if (doctorId.isNotEmpty) {
        model.Appointment appointment = model.Appointment(
          doctorId: doctorId,
          userId: userId,
          date: date,
          timeRange: timeRange,
        );
        FirebaseFirestore.instance
            .collection('appointment')
            .doc()
            .set(appointment.toJson());
        res = 'success';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> fetchAppointment() async {
    try {
      QuerySnapshot usersSnapshot =
          await FirebaseFirestore.instance.collection('appointment').get();
      List<Appointment> appointments = [];
      for (QueryDocumentSnapshot userSnapshot in usersSnapshot.docs) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        String doctorId = userData['doctorId'] ?? '';
        String userId = userData['userId'] ?? '';
        String availableDates = userData['date'] ?? [];
        String availableTimeRanges = userData['timeRange'] ?? [];

        Appointment appointment = Appointment(
          date: availableDates,
          timeRange: availableTimeRanges,
          doctorId: doctorId,
          userId: userId,
        );
        appointments.add(appointment);
      }
      _appointments = appointments;
      notifyListeners();
    } catch (error) {
      print('Error fetching appointments: $error');
    }
  }

  Future<void> fetchCurrentAppointment() async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('appointment')
          .doc()
          .get();

      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      String doctorId = userData['doctorId'] ?? '';
      String userId = userData['userId'] ?? '';
      String availableDates = userData['date'] ?? [];
      String availableTimeRanges = userData['timeRange'] ?? [];

      Appointment appointment = Appointment(
        date: availableDates,
        timeRange: availableTimeRanges,
        doctorId: doctorId,
        userId: userId,
      );
      _currentAppointment = appointment;
      notifyListeners();
    } catch (error) {
      print('Error fetching current Appointment: $error');
    }
  }
}
