import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_ride/screens/home.dart';
import 'package:go_ride/screens/login.dart';
import 'package:go_ride/screens/offers.dart';
import 'package:go_ride/screens/otp_input.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_ride/controllers/login.dart';
import 'package:go_ride/firebase_options.dart';

bool isLoggedIn = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  await UserPreferences.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: UserPreferences.instance.isLoggedIn ? 'map' : '/',
      routes: {
        '/': (context) => const Login(),
        'login': (context) => const Login(),
        'otp': (context) => const OtpInput(),
        'map': (context) => const Home(),
        'offers': (context) => const Offers()
      },
    );
  }
}
