import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:provider/provider.dart';

import 'screens/home.dart';
import './screens/wrapper.dart';
import 'controllers/usersController.dart';
import 'models/user.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override 
  Widget build(BuildContext context) {
    return StreamProvider<AppUser>.value(
      value: UserController().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Food Truck App",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Wrapper(),
      )
    );
  }
}

// class IntroScreen extends StatelessWidget {
//   @override 
//   Widget build(BuildContext context) {
//     User result = FirebaseAuth.instance.currentUser;
//     print("\n\n");
//     print(result);
//     return new SplashScreen(
//       navigateAfterSeconds: result != null ? Home(uid: result.uid) : Wrapper(),
//       seconds: 5,
//       title: new Text(
//         "Food Truck App",
//         style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
//       ),
//       // image: Image.asset("assets/images/dart.pn", fit: BoxFit.scaleDown),
//       backgroundColor: Colors.white,
//       styleTextUnderTheLoader: new TextStyle(),
//       photoSize: 100.0,
//       onClick: () => print("flutter"),
//       loaderColor: Colors.red
//     );
//   }
// }