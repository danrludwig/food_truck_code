import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home.dart';
import './user/signup.dart';
import '../models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    final user = Provider.of<AppUser>(context);

    // return etiher Home or Authenticate widget
    if (user == null) {
      return SignUp();
    } else {
      return Home();
    }
  }

}