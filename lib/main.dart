import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:provider/provider.dart';

import 'screens/home.dart';
import './screens/user/signup.dart';
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
        // home: Wrapper(),
        home: Wrapper(),
      )
    );
  }
}

class IntroScreen extends StatelessWidget {
  @override 
  Widget build(BuildContext context) {
    User result = FirebaseAuth.instance.currentUser;
    print("\n\n");
    print(result);
    return new SplashScreen(
      navigateAfterSeconds: result != null ? Home(uid: result.uid) : Wrapper(),
      seconds: 5,
      title: new Text(
        "Food Truck App",
        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      // image: Image.asset("assets/images/dart.pn", fit: BoxFit.scaleDown),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 100.0,
      onClick: () => print("flutter"),
      loaderColor: Colors.red
    );
  }
}

// // import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'models/global.dart';
// import 'models/truck.dart';
// import 'package:location/location.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// final firestoreInstance = FirebaseFirestore.instance;

// void main() => runApp(MyApp());

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   GoogleMapController _controller;

//   static const LatLng _center = const LatLng(41.735210, -111.834860);
//   Location _location = Location();

//   void _onMapCreated(GoogleMapController controller) {
//     // _controller.complete(controller);
//     _controller = controller;
//     _location.onLocationChanged.listen((l) {
//       _controller.animateCamera(
//         CameraUpdate.newCameraPosition(
//           CameraPosition(target: LatLng(l.latitude, l.longitude), zoom: 15),
//         )
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         body: Stack(
//           children: <Widget>[
//             GoogleMap(
//               onMapCreated: _onMapCreated,
//               initialCameraPosition: CameraPosition(
//                 target: _center,
//                 zoom: 11.0,
//               ),
//               // myLocationButtonEnabled: false,
//               myLocationEnabled: true,
//             ),
//             Container(
//               margin: EdgeInsets.only(bottom: 400),
//               child: Center(
//                 child: Container(
//                   margin: EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     boxShadow: [
//                       new BoxShadow(
//                         color: Colors.grey,
//                         blurRadius: 20.0,
//                       ),
//                     ],
//                     color: Colors.white,
//                   ),
//                   height: 50,
//                   width: 300,
//                   child: TextField(
//                     cursorColor: Colors.black,
//                     decoration: InputDecoration(
//                       hintText: "What food are you craving?",
//                       hintStyle: TextStyle(fontFamily: "Gotham", fontSize: 15),
//                       icon: Icon(Icons.search, color: Colors.black,),
//                       border: InputBorder.none,
//                       focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent))
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.only(top: 550, bottom: 50),
//               child: ListView(
//                 padding: EdgeInsets.only(left: 20),
//                 children: getTrucksInArea(),
//                 scrollDirection: Axis.horizontal,
//               )
//             )
//           ]
//         )
//       ),
//     );
//   }

//   List<Truck> getTrucks() {
//     List<Truck> trucks = [];

//     for (int i=0; i<10; i++) {
//       AssetImage profilePic = new AssetImage("lib/assets/chicken.jpg");
//       Truck myTruck = new Truck("Chicken On Wheels", "435-801-4351", "9am - 10pm", "Available", 4, profilePic, "American");
//       trucks.add(myTruck);
//     }
//     return trucks;
//   }

//   List<Widget> getTrucksInArea() {
//     List<Truck> trucks = getTrucks();
//     List<Widget> cards = [];
//     for (Truck truck in trucks) {
//       cards.add(truckCard(truck));
//     }
//     return cards;
//   }

//   Map statusStyles = {
//     "Available": statusAvailableStyle,
//     "Unavailable": statusUnavailableStyle,
//   };

//   Widget truckCard(Truck truck) {
//     return Container(
//       padding: EdgeInsets.all(10),
//           margin: EdgeInsets.only(right: 20),
//           width: 250,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.all(Radius.circular(20)),
//             color: Colors.white,
//             boxShadow: [
//           new BoxShadow(
//                 color: Colors.grey,
//                 blurRadius: 20.0,
//               ),
//             ],
//           ),
//           child: 
//           Column(
//             children: <Widget>[
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: <Widget>[
//                   Container(
//                     child: CircleAvatar(
//                       backgroundImage: truck.profilePicture
//                     ),
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Text(truck.name, style: truckCardTitleStyle,),
//                       Text(truck.foodType, style: truckCardSubTitleStyle,)
//                     ],
//                   )
//                 ],
//               ),
//               Container(
//                 margin: EdgeInsets.only(top: 30),
//                 child: Row(
//                   children: <Widget>[
//                     Text("Status:  ", style: truckCardSubTitleStyle,),
//                     Text(truck.status, style: statusStyles[truck.status])
//                   ],
//                 ),
//               ),
//               Container(
//                 margin: EdgeInsets.only(top: 40),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Row(
//                       children: <Widget>[
//                         Text("Rating: " + truck.rating.toString(), style: truckCardSubTitleStyle,)
//                       ],
//                     ),
//                     Row(
//                       children: getRatings(truck)
//                     )

//                   ],
//                 ),
//               )
//             ],
//           ),
//         );
//   }

//   List<Widget> getRatings(Truck truck) {
//     List<Widget> ratings = [];
//     for (int i=0; i < 5; i++) {
//       if (i < truck.rating) {
//         ratings.add(
//           new Icon(
//             Icons.star,
//             color: Colors.yellow
//           )
//         );
//       } else {
//         ratings.add(
//           new Icon(
//             Icons.star_border,
//             color: Colors.black
//           )
//         );
//       }
//     }
//     return ratings;
//   }

// }
