import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../models/global.dart';
import '../models/truck.dart';
import '../controllers/usersController.dart';
import './user/signup.dart';
import '../controllers/trucksController.dart';


final firestoreInstance = FirebaseFirestore.instance;

class Home extends StatelessWidget {
  Home({this.uid});
  final String uid;
  final String title = "Home";
  final UserController _auth = UserController();

  GoogleMapController _controller;

  static const LatLng _center = const LatLng(41.735210, -111.834860);
  Location _location = Location();

  void _onMapCreated(GoogleMapController controller) {
    // _controller.complete(controller);
    _controller = controller;
    _location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude, l.longitude), zoom: 15),
        )
      );
    });
  }

  @override 
  Widget build(BuildContext context) {
    return StreamProvider<List<Truck>>.value(
      value: TruckController().trucks,
      child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              onPressed: () async {
                await _auth.signOut();
                // FirebaseAuth auth = FirebaseAuth.instance;
                // auth.signOut().then((res) {
                //   Navigator.pushAndRemoveUntil(
                //     context,
                //     MaterialPageRoute(builder: (context) => SignUp()),
                //     (Route<dynamic> route) => false);
                // });
              }
            )
          ]
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
              // myLocationButtonEnabled: false,
              myLocationEnabled: true,
            ),
            Container(
              margin: EdgeInsets.only(bottom: 400),
              child: Center(
                child: Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.grey,
                        blurRadius: 20.0,
                      ),
                    ],
                    color: Colors.white,
                  ),
                  height: 50,
                  width: 300,
                  child: TextField(
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      hintText: "What food are you craving?",
                      hintStyle: TextStyle(fontFamily: "Gotham", fontSize: 15),
                      icon: Icon(Icons.search, color: Colors.black,),
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent))
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 550, bottom: 50),
              child: ListView(
                padding: EdgeInsets.only(left: 20),
                children: getTrucksInArea(),
                scrollDirection: Axis.horizontal,
              )
            )
          ]
        ),
        drawer: NavigateDrawer(uid: this.uid)
      ),
    ));

    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text(title),
    //     actions: <Widget>[
    //       IconButton(
    //         icon: Icon(
    //           Icons.exit_to_app,
    //           color: Colors.white,
    //         ),
    //         onPressed: () {
    //           FirebaseAuth auth = FirebaseAuth.instance;
    //           auth.signOut().then((res) {
    //             Navigator.pushAndRemoveUntil(
    //               context,
    //               MaterialPageRoute(builder: (context) => SignUp()),
    //               (Route<dynamic> route) => false);
    //           });
    //         },
    //       )
    //     ]
    //   ),
    //   body: Center(child: Text("Welcome!")),
    //   drawer: NavigateDrawer(uid: this.uid)
    // );
  }


  // void _onMapCreated(GoogleMapController controller) {
  //   // _controller.complete(controller);
  //   _controller = controller;
  //   _location.onLocationChanged.listen((l) {
  //     _controller.animateCamera(
  //       CameraUpdate.newCameraPosition(
  //         CameraPosition(target: LatLng(l.latitude, l.longitude), zoom: 15),
  //       )
  //     );
  //   });
  // }

  
  List<Truck> getTrucks() {
    List<Truck> trucks = [];

    for (int i=0; i<10; i++) {
      AssetImage profilePic = new AssetImage("lib/assets/chicken.jpg");
      Truck myTruck = new Truck("Chicken On Wheels", "435-801-4351", "9am - 10pm", "Available", 4, "American");
      trucks.add(myTruck);
    }
    return trucks;
  }

  List<Widget> getTrucksInArea() {
    List<Truck> trucks = getTrucks();
    List<Widget> cards = [];
    for (Truck truck in trucks) {
      cards.add(truckCard(truck));
    }
    return cards;
  }

  Map statusStyles = {
    "Available": statusAvailableStyle,
    "Unavailable": statusUnavailableStyle,
  };

  Widget truckCard(Truck truck) {
    return Container(
      padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(right: 20),
          width: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.white,
            boxShadow: [
          new BoxShadow(
                color: Colors.grey,
                blurRadius: 20.0,
              ),
            ],
          ),
          child: 
          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  // Container(
                  //   child: CircleAvatar(
                  //     backgroundImage: truck.profilePicture
                  //   ),
                  // ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(truck.name, style: truckCardTitleStyle,),
                      Text(truck.foodType, style: truckCardSubTitleStyle,)
                    ],
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Row(
                  children: <Widget>[
                    Text("Status:  ", style: truckCardSubTitleStyle,),
                    Text(truck.status, style: statusStyles[truck.status])
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text("Rating: " + truck.rating.toString(), style: truckCardSubTitleStyle,)
                      ],
                    ),
                    Row(
                      children: getRatings(truck)
                    )

                  ],
                ),
              )
            ],
          ),
        );
  }

  List<Widget> getRatings(Truck truck) {
    List<Widget> ratings = [];
    for (int i=0; i < 5; i++) {
      if (i < truck.rating) {
        ratings.add(
          new Icon(
            Icons.star,
            color: Colors.yellow
          )
        );
      } else {
        ratings.add(
          new Icon(
            Icons.star_border,
            color: Colors.black
          )
        );
      }
    }
    return ratings;
  }
}


class NavigateDrawer extends StatefulWidget {
  final String uid;
  NavigateDrawer({Key, key, this.uid}) : super(key: key);
  @override
  _NavigateDrawerState createState() => _NavigateDrawerState();
}

class _NavigateDrawerState extends State<NavigateDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountEmail: FutureBuilder(
              future: FirebaseDatabase.instance
                    .reference()
                    .child("Users")
                    .child(widget.uid)
                    .once(),
                builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data.value['email']);
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
            accountName: FutureBuilder(
                future: FirebaseDatabase.instance
                    .reference()
                    .child("Users")
                    .child(widget.uid)
                    .once(),
                builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data.value['name']);
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            ),
            ListTile(
              leading: new IconButton(
                icon: new Icon(Icons.home, color: Colors.black),
                onPressed: () => null,
              ),
              title: Text("Home"),
              onTap: () {
                print(widget.uid);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home(uid: widget.uid)),
                );
              }
            ),
            ListTile(
              leading: new IconButton(
                icon: new Icon(Icons.settings, color: Colors.black),
                onPressed: () => null,
              ),
              title: Text("Settings"),
              onTap: () {
                print(widget.uid);
              }
            )
        ]
      )
    );
  }
}
