import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:musicplayer/Pages/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
 @override
  void initState() {
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>   HomePageContainer() ));
     });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color.fromARGB(255, 221, 133, 243), Color.fromARGB(255, 129, 10, 150)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,)
        ),
        child: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
          child: Column(
           children: [
            SizedBox(
               height: 200,
                width: 200,
              child: Lottie.asset("lib/assest/splashScreenAnimation.json"),
            ),
            Text("Welcome",style: GoogleFonts.acme(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),),
            Text("to",style: GoogleFonts.acme(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),),
            Text("Harmony",style: GoogleFonts.acme(
              color: Colors.white,
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
            ),
            Text("Let the party Begin's",style: GoogleFonts.acme(
              color: Colors.white,
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),),
          ],
                  ),
        ) ,
      ) ));
  }
}