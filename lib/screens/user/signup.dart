import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import '../../controllers/usersController.dart';

import 'email_login.dart';
import 'email_signup.dart';
import '../home.dart';

class SignUp extends StatelessWidget {

  final UserController _userController = UserController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text("Food Truck App",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                fontFamily: "Roboto"
              )),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: SignInButton(
              Buttons.Email,
              text: "Sign up with Email",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EmailSignUp()),
                );
              }
            )
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: SignInButton(
              Buttons.Google,
              text: "Sign up with Google",
              onPressed: () {},
            )
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: GestureDetector(
              child: Text("Log In Using Email",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.blue
                )),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EmailLogIn()),
                  );
                }
            )
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: GestureDetector(
              child: Text("Log In As Guest",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.blue
                )),
                onTap: () async {
                  dynamic result = await _userController.signInAnon();
                  if (result == null) {
                    print("error signing in");
                  } else {
                    print("Signed in");
                    print(result.uid);
                  }
                }
                // onTap: () {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(builder: (context) => Home()),
                //   );
                // }
            )
          )
        ])
      )
    );
  }
}