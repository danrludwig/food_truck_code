class AppUser {
  
  final String uid;

  AppUser({ this.uid });

}

class UserData {

  final String uid;
  final String name;
  final String phoneNumber;
  final String hours;
  final String status;
  final int rating;
  final String foodType;
  final String email;
  final double lat;
  final double lng;

  UserData({this.uid, this.name, this.phoneNumber, this.hours, this.status, 
    this.rating, this.foodType, this.email, this.lat, this.lng});

}