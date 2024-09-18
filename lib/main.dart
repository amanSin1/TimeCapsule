import 'package:Time_Capsule/pages/wrapper.dart';
import 'package:Time_Capsule/screens/on_boarding_screen.dart';
import 'package:Time_Capsule/themes/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'firebase_options.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Time Capsule',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeClass.lightTheme, // applies this theme if the device theme is light mode
      darkTheme: ThemeClass.darkTheme, // applies this theme if the device theme is dark mode
      home: const Wrapper(),
    );

  }
}
