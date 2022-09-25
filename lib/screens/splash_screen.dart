import 'dart:async';

import 'package:blogappflutter/screens/home_screen.dart';
import 'package:blogappflutter/screens/optionscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    // ignore: non_constant_identifier_names
    final User = _firebaseAuth.currentUser;
    if (User != null) {
      Timer(
          Duration(seconds: 3),
          () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) =>  HomeScreen(),
                ),
                (route) => false,
              ));
    } else {
      Timer(
          Duration(seconds: 3),
          () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const OptionScreen(),
                ),
                (route) => false,
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Image(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.6,
                image: const AssetImage("images/bloglogo.jpg")),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 30),
            child: Text(
              "Blog!",
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 30,
                  fontWeight: FontWeight.w300),
            ),
          )
        ],
      ),
    );
  }
}
