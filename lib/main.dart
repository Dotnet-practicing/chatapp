import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timer/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCwgo0T1-QmTQj1_qaU_30jmTqKPUoi7vI",
      authDomain: "chatapp-3b9ba.firebaseapp.com",
      projectId: "chatapp-3b9ba",
      storageBucket: "chatapp-3b9ba.appspot.com",
      messagingSenderId: "507490110599",
      appId: "1:507490110599:web:cd81cc4c3042df540e3c22",
      measurementId: "G-KXB9WXJDW2",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue, scaffoldBackgroundColor: Colors.white),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
