import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:splashscreen/splashscreen.dart';

import '../home.dart';
import 'signup.dart';

class IntroScreen extends StatelessWidget {
  @override 
  Widget build(BuildContext context) {
    User result = FirebaseAuth.instance.currentUser;
    return new SplashScreen(
      navigateAfterSeconds: result != null ? Home(uid: result.uid) :SignUp(),
      seconds: 5,
      title: new Text(
        "Welcome To Meet up!",
        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      image: Image.asset("assets/images/dart.pn", fit: BoxFit.scaleDown),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 100.0,
      onClick: () => print("flutter"),
      loaderColor: Colors.red
    );
  }
}