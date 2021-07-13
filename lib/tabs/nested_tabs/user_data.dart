import 'package:coindrop/models/app_user.dart';
import 'package:coindrop/services/database/user_database.dart';
import 'package:coindrop/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    AppUser user = Provider.of<AppUser>(context);
    return StreamBuilder<UserData>(
      initialData: null,
      stream: UserDatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData userData = snapshot.data;
          return Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    // UserDatabaseService(uid: user.uid).updateUserData('Kiran');
                    // UserDatabaseService(uid: user.uid)
                    //     .addCoin('ADA', 'Cardano');
                  });
                },
                child: Text('Update User'),
              ),
              Center(
                child: Text(
                  '${userData.name}/${userData.email}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        } else {
          return Loading();
        }
      },
    );
  }
}
