import 'package:flutter/material.dart';

class Truck {
  String name;
  String phoneNumber;
  String hours;
  String status;
  int rating;
  AssetImage profilePicture;
  String foodType;

  Truck(this.name, this.phoneNumber, this.hours, this.status, 
    this.rating, this.profilePicture, this.foodType);
}