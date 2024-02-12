import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1_1/Feature/auth/Csreen/auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 10), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Auth(),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 253, 253),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Image.network(
                  'https://upload.wikimedia.org/wikipedia/ckb/4/45/Uhd-univ-logo.jpg')),
          SizedBox(
            height: 100,
          ),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.red),
          )
        ],
      ),
    );
  }
}
