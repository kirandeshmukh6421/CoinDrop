import 'dart:async';

import 'package:coindrop/screens/wrapper.dart';
import 'package:coindrop/shared/constants.dart';
import 'package:coindrop/shared/loading2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyScreen extends StatefulWidget {
  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final auth = FirebaseAuth.instance;
  User user;
  Timer timer;

  @override
  void initState() {
    user = auth.currentUser;
    user.sendEmailVerification();

    timer = Timer.periodic(Duration(seconds: 2), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMediumGrey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            kAppName,
            SizedBox(
              height: 50,
            ),
            Text(
              'An email has been sent to',
              style: kLabelStyle,
            ),
            Text(
              '${user.email}',
              style: kLabelStyle,
            ),
            Text(
              'Please verify.',
              style: kLabelStyle,
            ),
            SizedBox(
              height: 20,
            ),
            Loading2()
          ],
        ),
      ),
    );
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser;
    await user.reload();
    if (user.emailVerified) {
      timer.cancel();
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Wrapper()));
    }
  }
}
