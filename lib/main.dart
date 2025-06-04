import 'package:detak_medis/views/auth/login.dart';
import 'package:detak_medis/views/auth/register.dart';
// import 'package:detak_medis/views/chatbot.dart';
import 'package:detak_medis/views/find_doctor.dart';
import 'package:detak_medis/views/get_started.dart';
import 'package:detak_medis/views/edit_form.dart';
import 'package:detak_medis/views/profile.dart';
import 'package:flutter/material.dart';
// import 'package:detak_medis/views/chatbot/chatbot.dart';
// import 'package:detak_medis/views/home/home_page.dart';
import 'package:detak_medis/views/upload_image.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/', 
      routes: {
        '/': (context) => const OnboardingPage(),
        '/edit-profile': (context) => const EditForm(),
        '/profile': (context) => const ProfilePage(),
        '/login': (context) => const LoginPage(), 
        '/register': (context) => const RegisterPage(),
        // '/home': (context) => const HomePage(),
        // '/chatbot': (context) => const ChatBot(), 
        '/upload-document': (context) => const UploadImagePage(),
        '/find-doctor': (context) => const FindDoctorPage(),
      },
    );
  }
}
