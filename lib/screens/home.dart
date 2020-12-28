import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../models/truck.dart';
import '../controllers/usersController.dart';
import '../controllers/trucksController.dart';
import '../models/user.dart';


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
    _controller = controller;
    _location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude, l.longitude), zoom: 15),
        )
      );
    });
  }

  Marker utahStateMarker = Marker(
    markerId: MarkerId("utahState"),
    position: LatLng(41.757134, -111.803287),
    infoWindow: InfoWindow(title: "Utah State"),
    icon: BitmapDescriptor.defaultMarker
  );

  Marker someOtherMarker = Marker(
    markerId: MarkerId("otherMarker"),
    position: LatLng(41.745159, -111.809746),
    infoWindow: InfoWindow(title: "Other Marker"),
    icon: BitmapDescriptor.defaultMarker
  );



  @override 
  Widget build(BuildContext context) {
    return StreamProvider<List<Truck>>.value(
      value: TruckController().trucks,
      child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              // markers: mapHazardEventMarkers,
              mapType: MapType.normal,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
              // myLocationButtonEnabled: false,
              myLocationEnabled: true,
              // markers: getMarkers(),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 520),
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
            // TruckList()
            Container(
              padding: EdgeInsets.only(top: 450, bottom: 50),
              child: TruckList()
            )
            // Container(
            //   padding: EdgeInsets.only(top: 550, bottom: 50),
            //   child: ListView(
            //     padding: EdgeInsets.only(left: 20),
            //     children: TruckList(),
            //     scrollDirection: Axis.horizontal,
            //   )
            // )
          ]
        ),
        drawer: NavigateDrawer(uid: this.uid)
      ),
    )
    );
  }
}


class NavigateDrawer extends StatefulWidget {
  final String uid;
  NavigateDrawer({Key, key, this.uid}) : super(key: key);
  @override
  _NavigateDrawerState createState() => _NavigateDrawerState();
}

class _NavigateDrawerState extends State<NavigateDrawer> {

  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {

    final user = Provider.of<AppUser>(context);
    final UserController _auth = UserController();
  



    return StreamBuilder<UserData>(
      stream: TruckController(uid: user.uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {

          UserData userData = snapshot.data;

          return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountEmail: Container(
                  child: Text(userData.email)
                ),
                accountName: Container(
                  child: Text(userData.name),
                ),
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
                ),
                ListTile(
                  leading: new IconButton(
                    icon: new Icon(Icons.logout, color: Colors.black),
                    onPressed: () => null,
                  ),
                  title: Text("Logout"),
                  onTap: () {
                    _auth.signOut();
                  }
                )
            ]
          )
        );
        } else {

        }
      }
    );
  }
}
