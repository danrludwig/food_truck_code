import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/truck.dart';
import '../models/global.dart';
import '../models/user.dart';


class TruckController {

  final String uid;
  TruckController({ this.uid });

  // Collection reference
  final CollectionReference truckCollection = FirebaseFirestore.instance.collection("trucks");

  Future updateUserData(String foodType, String hours, String, name, String phoneNumber, 
                        int rating, String status, String email, double lat, double lng) async {
    return await truckCollection.doc(uid).set({
      "foodType": foodType,
      "hours": hours,
      "name": name, 
      "phoneNumber": phoneNumber,
      "rating": rating,
      "status": status,
      "email": email,
      "lat": lat,
      "lng": lng,
    });
  }

  // truck list from snapshot
  List<Truck> _truckListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc){
      // print(doc.data());
      return Truck( 
        name: doc.data()["name"] ?? "",
        phoneNumber: doc.data()["phoneNumber"] ?? "",
        hours: doc.data()["hours"] ?? "",
        status: doc.data()["status"] ?? "",
        rating: doc.data()["rating"] ?? 0,
        foodType: doc.data()["foodType"] ?? "",
        email: doc.data()["email"] ?? "",
        lat: doc.data()["lat"] ?? 0.0,
        lng: doc.data()["lng"] ?? 0.0,
      );
    }).toList();
  }

  // get truck stream
  Stream<List<Truck>> get trucks {
    return  truckCollection.snapshots()
      .map(_truckListFromSnapshot);
  } 

  // get user doc stream
  Stream<UserData> get userData {
    return truckCollection.doc(uid).snapshots()
    .map(_userDataFromSnapshot);
  }

  // userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data()["name"],
      phoneNumber: snapshot.data()["phoneNumber"],
      hours: snapshot.data()["hours"],
      status: snapshot.data()["status"],
      rating: snapshot.data()["rating"],
      foodType: snapshot.data()["foodType"],
      email: snapshot.data()["email"],
      lat: snapshot.data()["lat"],
      lng: snapshot.data()["lng"],
    );
  }
}

class TruckList extends StatefulWidget {
  @override
  _TruckListState createState() => _TruckListState();
}

class _TruckListState extends State<TruckList> {
  @override
  Widget build(BuildContext context) {

    final trucks = Provider.of<List<Truck>>(context);

    return ListView.builder(
      // itemCount: trucks.length,
      padding: EdgeInsets.only(left: 20.0),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return TruckTile(truck: trucks[index]);
      },
    );
  }
}

class TruckTile extends StatelessWidget {

  final Truck truck;
  TruckTile({ this.truck });

  Future<void> _gotoLocation(double lat, double lng) async {
    // GoogleMapController _controller;
    // final GoogleMapController controller = await _controller.future;
    GoogleMapController _controller;
    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(lat, lng), 
                      zoom: 15.0, 
                      tilt: 50.0, 
                      bearing: 45.0)
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _gotoLocation(truck.lat, truck.lng);
      },
    child: Container(
      // padding: EdgeInsets.only(top: 450, bottom: 50),
      // // margin: EdgeInsets.all(10),
      // width: 250,
      // height: 450,
      // child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(right: 20),
        width: 250,
        // height: 250,
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
              children: <Widget> [
                // Container(
                //   child: CircleAvatar(
                //     backgroundImage: new AssetImage("lib/assets/somone.jpg")
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
                  Text("Status: ", style: truckCardSubTitleStyle,),
                  Text(truck.status, style: statusStyles[truck.status]),
                ]
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text("Rating: " +truck.rating.toString(), style: truckCardSubTitleStyle,)
                    ]
                  ),
                  Row(
                    children: getRatings(truck)
                  )
                ],
              )
            )
          ]
        )
    )
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
        ratings.add(new Icon(
          Icons.star_border,
          color: Colors.black
        ));
      }
    }
    return ratings;
  }

  Map statusStyles = {
    "Available": statusAvailableStyle,
    "Unavailable": statusUnavailableStyle,
  };

}

// class TruckMarkers extends StatefulWidget {
//   @override
//   _TruckMarkerState createState() => _TruckMarkerState();
// }

// class _TruckMarkerState extends State<TruckMarkers> {

//   Widget _child;
//   Map<MarkerId, Marker> markers = <MarkerId, Marker>();

//   void initMarker(request, requestId) {
//     var markerIdVal = requestId;
//     final MarkerId markerId = MarkerId(markerIdVal);
//     // creating a new MARKER
//     final Marker marker = Marker(
//       markerId: markerId,
//       position:
//         LatLng(request["location"].latitude, request["location"].longitude),
//       infoWindow:
//         InfoWindow(title: "Fetched Markers", snippet: request["address"]),
//     );
//     setState(() {
//       markers[markerId] = marker;
//       print(markerId);
//     });
//   }

//   void populateClients() {
//     FirebaseFirestore.instance.collection("trucks").get()
//     .then((docs) {
//       if (docs.docs.isNotEmpty) {
//         for (int i=0; i < docs.docs.length; i++) {
//           initMarker(docs.docs[i].data, docs.docs[i].id);
//         }
//       }
//     });
//   }

//   @override
//   void initState() {
//     _child = RippleIndicator("Getting Location");
//     getCurrentLocation();
//     populateClients();
//     super.initState();
//   }
  

//   @override 
//   Widget build(BuildContext context) {
//     return Set<Markers>.of(markers.values);
//   }
// }