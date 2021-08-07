import 'package:flutter/material.dart';
import 'package:coindrop/models/app_user.dart';
import 'package:coindrop/screens/splash_screen.dart';
import 'package:coindrop/services/database/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'shared/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: kDarkGrey,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<AppUser>.value(
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CoinDrop',
        theme: ThemeData(
          primaryColor: kDarkGrey,
          accentColor: kAccentColor,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
