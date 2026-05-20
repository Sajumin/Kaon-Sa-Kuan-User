import 'package:flutter/material.dart';
import 'screens/landing_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const KaonSaKuanApp());
}

class KaonSaKuanApp extends StatelessWidget {
  const KaonSaKuanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kaon sa Kuan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Afacad',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8BC349)),
        useMaterial3: true,
      ),
      home: const LandingPage(),
    );
  }
}
