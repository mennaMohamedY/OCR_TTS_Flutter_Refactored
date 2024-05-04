
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tts_refactor/ocr_and_tts/ocr_and_tts_screen.dart';
import 'package:tts_refactor/splash_screen/splash_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName:(context)=>SplashScreen(),
        CompineOCRTTSScreen.routeName:(context)=>CompineOCRTTSScreen(),
      },

    );
  }
}

