import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_app/Notification/notification.dart';
import 'package:provider/provider.dart';

import '../Providers/provider.dart';
import '../models/model.dart';

class DocMyAppointmentPage extends StatefulWidget {
  const DocMyAppointmentPage({super.key});

  @override
  State<DocMyAppointmentPage> createState() => _MyAppointmentPageState();
}

class _MyAppointmentPageState extends State<DocMyAppointmentPage> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    super.initState();
    Provider.of<AppointmentsProvider>(context, listen: false)
        .fetchAppointment();
    // Provider.of<DoctorProvider>(context, listen: false).fetchDoctors();
    Provider.of<UserProvider>(context, listen: false).fetchUsers();

    Provider.of<DoctorProvider>(context, listen: false)
        .fetchCurrentDoctor(userId);
  }

  @override
  Widget build(BuildContext context) {
    final appointments = Provider.of<AppointmentsProvider>(context);
    final List<Appointment> app = appointments.appointments;

    final patients = Provider.of<UserProvider>(context);
    final List<Users> patient = patients.getUsers;

    final user = Provider.of<DoctorProvider>(context);
    final DoctorInformation docto = user.currentUser!;

    return Container(
      height: 800,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: app.length,
        itemBuilder: (context, index) {
          Users user = patient.firstWhere(
              (user) =>
                  user.uid == app[index].userId &&
                  (docto.doctorId == app[index].doctorId),
              orElse: () => const Users(
                    name: '',
                    email: '',
                    password: '',
                    role: '',
                    lastMessageTime: '',
                    photoUrl: '',
                    uid: '',
                    followers: [],
                    following: [],
                  ));
          if (user.uid == app[index].userId &&
              docto.doctorId == app[index].doctorId) {
            return Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.width / 2.8,
                  width: 400,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.yellow,
                        blurRadius: 4,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                            child: Image.network(
                              user.photoUrl,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image(
                            //   image: NetworkImage(patient[index].docPhotoUrl),
                            // ),
                            Text(user.name,
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blue.withOpacity(0.6))),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              user.email,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.blue.withOpacity(0.6)),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text('Dates: ${app[index].date}',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blue.withOpacity(0.6))),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              'Times: ${app[index].timeRange}',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.blue.withOpacity(0.6)),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '4.5',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.blue.withOpacity(0.6)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            );
          } else {
            return const Text('');
          }
        },
      ),
    );
  }
}
