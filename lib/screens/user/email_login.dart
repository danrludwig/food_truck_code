import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../controllers/usersController.dart';
import '../home.dart';

class EmailLogIn extends StatefulWidget {
  @override
  _EmailLogInState createState() => _EmailLogInState();
}

class _EmailLogInState extends State<EmailLogIn> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final UserController _auth = UserController();

  bool isLoading = false;
  String error = "";
  
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: Text("Login")),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Enter Email Address",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                // The validator receives the text that the user has entered
                validator: (value) {
                  if (value.isEmpty) {
                    return "Enter Email Address";
                  } else if (!value.contains('@')) {
                    return "Please enter a valid email address!";
                  } 
                  return null;
                },
              )
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextFormField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: "Enter Password",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  )
                ),
                // The validator receives the text that the user has entered
                validator: (value) {
                  if (value.isEmpty) {
                    return "Enter Password";
                  } else if (value.length < 6) {
                    return "Password must be atleast 6 characters!";
                  }
                  return null;
                }
              )
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: isLoading ? CircularProgressIndicator() : RaisedButton(
                color: Colors.lightBlue,
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    setState(() {
                      isLoading = true;
                    });
                    dynamic result = await _auth.signInWithEmailAndPassword(emailController.text.toString(), passwordController.text.toString());
                    // print(result);
                    if (result == null) {
                      setState(() {
                        isLoading = false;
                        error = "Invalid credentials.";
                      });
                    } else {
                      Navigator.of(context).pop();
                    }
                  }
                },
                child: Text("Submit")
              )
            ),
            SizedBox(height: 12.0),
            Text(
              error,
              style: TextStyle(color: Colors.red, fontSize: 14.0)
            )
          ])
        )
      )
    );
  }

  void logInToFb() {
    FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text, 
      password: passwordController.text)
      .then((result) {
        isLoading = false;
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) =>  Home(uid: result.user.uid)),
        );
      }).catchError((err) {
        print(err.message);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(err.message),
              actions: [
                FlatButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }
                )
              ]
            );
          }
        );
      });
  }
}