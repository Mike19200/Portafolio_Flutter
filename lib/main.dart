import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:portafolio_webapp_2026/Screens/home_screen.dart';
import 'package:portafolio_webapp_2026/models/scroll_behaviour.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const PortafolioApp());
}

class PortafolioApp extends StatelessWidget {
  const PortafolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portafolio MikeDev',
      debugShowCheckedModeBanner: false,
      scrollBehavior: MyCustomScrollBehavior(),
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,

        // Color estilo TikTok
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFE2C55),
          brightness: Brightness.dark,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
