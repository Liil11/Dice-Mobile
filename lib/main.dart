import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Core
import 'firebase_options.dart'; // File hasil generate dari flutterfire configure
import 'screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Wajib jika main async
  
  // Inisialisasi Firebase
  // Pastikan Anda sudah menjalankan 'flutterfire configure' untuk mendapatkan firebase_options.dart
  // Jika belum, hapus parameter 'options' dan biarkan default (tapi setup manual lebih ribet)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, 
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dice & Dice App',
      theme: ThemeData(
        fontFamily: 'Serif',
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
}