import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_ride/screens/home.dart';
import 'package:go_ride/screens/login.dart';
import 'package:go_ride/screens/otp_input.dart';
import 'package:go_ride/screens/start_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {

        '/': (context) => const Login(),
        'login': (context) => const Login(),
        'otp': (context) => const OtpInput(),
        'map':(context)=>const Home()
      },
    );
  }
}
