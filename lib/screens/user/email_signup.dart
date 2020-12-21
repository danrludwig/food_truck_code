import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../controllers/usersController.dart';
import '../home.dart';

class EmailSignUp extends StatefulWidget {
  @override
  _EmailSignUpState createState() => _EmailSignUpState();
}

class _EmailSignUpState extends State<EmailSignUp> {

  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String error = "";

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  DatabaseReference dbRef = FirebaseDatabase.instance.reference().child("Users");
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  // TextEditingController ageController = TextEditingController();

  final UserController _auth = UserController(); 

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up")),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Enter User's Name",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  )
                ),
                // The validator receives the text the user has entered
                validator: (value) {
                  if (value.isEmpty) {
                    return "Name Required";
                  }
                  return null;
                }
              )
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Enter Email",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)
                  )
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Enter an Email Address";
                  } else if (!value.contains('@')) {
                    return "Email Required";
                  }
                  return null;
                }
              )
            ),
            // Padding(
            //   padding: EdgeInsets.all(20.0),
            //   child: TextFormField(
            //     controller: ageController,
            //     decoration: InputDecoration(
            //       labelText: "Enter Age",
            //       enabledBorder: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(10.0)
            //       )
            //     ),
            //     validator: (value) {
            //       if (value.isEmpty) {
            //         return "Enter Age";
            //       }
            //       return null;
            //     }
            //   )
            // ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextFormField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: "Enter Password",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)
                  )
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Enter Password";
                  } else if (value.length < 6) {
                    return "Password must be atleast 6 characters";
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
                    dynamic result = await _auth.registerWithEmailAndPassword(emailController.text.toString(), passwordController.text.toString());
                    if (result == null) {
                      setState(() {
                        isLoading = false;
                        error = "Please supply a valid email and password.";
                      });
                    } else {
                      Navigator.of(context).pop();
                    }
                  }
                },
                child: Text("Submit")
              ),
            ),
            SizedBox(height: 12.0),
            Text(
              error,
              style: TextStyle(color: Colors.red, fontSize: 14.0)
            )
          ],)
        )
      )
    );
  }

  void registerToFb() {
    firebaseAuth.createUserWithEmailAndPassword(
      email: emailController.text, password: passwordController.text)
      .then((result) {
        dbRef.child(result.user.uid).set({
          "email": emailController.text,
          // "age": ageController.text,
          "name": nameController.text,
        }).then((res) {
          isLoading = false;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home(uid: result.user.uid)),
          );
        });
      }).catchError((err) {
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
        isLoading = false;
      });
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    // ageController.dispose();
  }
}