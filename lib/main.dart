//import 'dart:html';
//import 'dart:js';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_app/Admin/signup_admin.dart';
import 'package:healthcare_app/Chat/page/chats_page.dart';
//import 'package:healthcare_app/ChatUser/page/chats_page_user.dart';
import 'package:healthcare_app/Doctor/doctor-page.dart';
import 'package:healthcare_app/Doctor/doctor.dart';
import 'package:healthcare_app/Post/add_post.dart';
import 'package:healthcare_app/Post/feeds.dart';
import 'package:healthcare_app/Providers/provider.dart';
// import 'package:healthcare_app/Auntethication/signUpOne.dart';
// import 'package:healthcare_app/Patient/home.dart';
// import 'package:healthcare_app/Auntethication/signup_screen.dart';
// import 'package:healthcare_app/Doctor/home_of_doctor.dart';
// import 'package:healthcare_app/Doctor/welcomePage.dart';
// import 'package:healthcare_app/Screens/registeration_choice.dart';
import 'package:healthcare_app/responsive/responsive.dart';
import 'package:healthcare_app/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// import 'Appointment/my_appointment_page.dart';
// import 'Chat U/page/chats_page2.dart';
// import 'Notification/notification.dart';
import 'package:timezone/data/latest.dart'
    as tzdata; // Import the timezone data
//import 'package:timezone/timezone.dart' as tz; // Import the timezone library
import 'Screens/screen.dart';
//import 'Appointment/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tzdata.initializeTimeZones(); // Initialize the time zones

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyB4Cu_e1VtMn6InoQKctVDkQQGYVbMVz9g',
        appId: '1:994264266102:web:aedbdeb7fb1eee81aa7657',
        messagingSenderId: '994264266102',
        projectId: 'healthcare-app-6417',
        storageBucket: 'healthcare-app-6417.appspot.com',
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => DoctorProvider(),
        ),
        ChangeNotifierProvider(create: (_) => AppointmentsProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Healthcare App',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        home: StreamBuilder(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ResponsiveScreenLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('${snapshot.error}'));
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            }
            return const LoginScreen();
          },
          stream: null,
        ),
      ),
    );
  }
}
