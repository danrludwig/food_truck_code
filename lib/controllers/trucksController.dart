import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/truck.dart';


class TruckController {

  final String uid;
  TruckController({ this.uid });

  // Collection reference
  final CollectionReference truckCollection = FirebaseFirestore.instance.collection("trucks");

  Future updateUserData(String foodType, String hours, String, name, String phoneNumber, int rating, String status) async {
    return await truckCollection.doc(uid).set({
      "foodType": foodType,
      "hours": hours,
      "name": name, 
      "phoneNumber": phoneNumber,
      "rating": rating,
      "status": status
    });
  }

  // truck list from snapshot
  List<Truck> _truckListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc){
      return Truck( 
        name: doc.data()["name"] ?? "",
        phoneNumber: doc.data()["phoneNumber"] ?? "",
        hours: doc.data()["hours"] ?? "",
        status: doc.data()["status"] ?? "",
        rating: doc.data()["rating"] ?? 0,
        foodType: doc.data()["foodType"] ?? "",
      );
    }).toList();
  }

  // get truck stream
  Stream<List<Truck>> get trucks {
    return  truckCollection.snapshots()
      .map(_truckListFromSnapshot);
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
      itemCount: trucks.length,
      itemBuilder: (context, index) {
        return TruckTile(truck: trucks[index]);
      },
    );
  }
}

class TruckTile extends StatelessWidget {

  final Truck truck;
  TruckTile({ this.truck });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      
    );
  }
}