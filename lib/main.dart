import 'package:detak_medis/views/auth/login.dart';
import 'package:detak_medis/views/auth/register.dart';
import 'package:detak_medis/views/onboard/get_started.dart';
import 'package:flutter/material.dart';
import 'package:detak_medis/views/chatbot/chatbot.dart';
import 'package:detak_medis/views/home/home_page.dart';
import 'package:detak_medis/views/upload/upload_image.dart';
import 'package:detak_medis/views/doctor/find_doctor.dart';

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
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/chatbot': (context) => const ChatbotPage(), 
        '/upload-document': (context) => const UploadImagePage(),
        '/find-doctor': (context) => const FindDoctorPage(),
        // Tambahkan route lain di sini sesuai kebutuhan
      },
    );
  }
}
