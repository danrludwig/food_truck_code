import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';
import 'trucksController.dart';

class UserController {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on firebase user
  AppUser _userFromFirebaseUser(User user) {
    return user != null ? AppUser(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<AppUser> get user {
    return _auth.onAuthStateChanged
      .map(_userFromFirebaseUser);
  }

  // sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      print(email);
      print(password);
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    } 
  }

  // register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;

      // create a new document for the user with the uid
      await TruckController(uid: user.uid).updateUserData("", "", "", "", "", 0, "");

      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    } 
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   // create user object based on FirebaseUser
//   AppUser _userFromFirebaseUser(User user) {
//     return user != null ? AppUser(uid: user.uid) : null;
//   }

//   // auth change user stream
//   Stream<AppUser> get user {
//     return _auth.onAuthStateChanged
//     .map(_userFromFirebaseUser);
//   }

//   // sign in anonomously
//   Future signInAnon() async {
//     try{
//       UserCredential result = await _auth.signInAnonymously();
//       User user = result.user;
//       return _userFromFirebaseUser(user);
//     } catch(error) {
//       print(error.toString());
//       return null;
//     }
//   }

//   // sign in with email and password

//   // register with email and password

//   // sign out
//   Future signOut() async {
//     try {
//       return await _auth.signOut();
//     } catch (error) {
//       print(error.toString());
//       return null;
//     }
//   }

// }


// // import 'package:cloud_firestore/cloud_firestore.dart';

// // class userController {
  
// //   final String uid;
// //   userController({ this.uid });

// //   final CollectionReference userCollection = Firestore.instance.collection("Users");

// //   Future updateUserData(String email, String name, String password) async {
// //     return await userCollection.document(uid).setData({
// //       "email": email,
// //       "name": name,
// //       "password": password
// //     });
// //   }

}