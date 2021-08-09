import 'package:coindrop/models/app_user.dart';
import 'package:coindrop/screens/authentication/authenticate.dart';
import 'package:coindrop/tabs/bottom_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Check if user is logged in or out by subscribing to the User Stream using the Provider Package.
    final user = Provider.of<AppUser>(context);
    // print(user);

    // Return either the Home or Authenticate widget based on User Login status.
    if (user == null) {
      return Authenticate();
    } else {
      return HomePage(FirebaseAuth.instance.currentUser.emailVerified);
    }
  }
}
