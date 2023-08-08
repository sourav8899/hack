import 'package:flutter/material.dart';
import 'package:hack/bottom.dart';
import 'package:hack/homepage1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final pref = await SharedPreferences.getInstance();
  final showhome =  pref.getBool('showHome') ?? false;
  runApp(MyApp(showhome: showhome));
}

class MyApp extends StatelessWidget {
  final bool showhome;
  
  const MyApp({
    Key? key,
    required this.showhome,
  }) : super(key: key);

  @override
 
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      
      home: showhome ?Bottom(): onBoardingScreen(),
    );
  }
}
