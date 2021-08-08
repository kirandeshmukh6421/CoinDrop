import 'package:coindrop/models/app_user.dart';
import 'package:coindrop/services/database/user_database.dart';
import 'package:coindrop/shared/constants.dart';
import 'package:coindrop/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final _formKey = GlobalKey<FormState>();
  String _currentName;
  @override
  Widget build(BuildContext context) {
    AppUser user = Provider.of<AppUser>(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kMediumGrey,
        appBar: AppBar(
          title: kAppName,
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'USER DETAILS',
              style: kLabelStyle.copyWith(fontSize: 25),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: StreamBuilder<UserData>(
                      stream: UserDatabaseService(uid: user.uid).userData,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          UserData userData = snapshot.data;
                          return Form(
                            key: _formKey,
                            child: Column(
                              // mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Username',
                                      style: kLabelStyle,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    decoration: kBoxStyle,
                                    height: 62.0,
                                    child: TextFormField(
                                      initialValue: userData.name,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'OpenSans',
                                      ),
                                      decoration: kTextInputDecoration.copyWith(
                                        prefixIcon: Icon(
                                          Icons.person,
                                          color: Colors.blueGrey,
                                        ),
                                        hintText: userData.name,
                                        hintStyle: kHintStyle,
                                      ),
                                      validator: (val) => val.isEmpty
                                          ? '\t\t\tPlease enter a valid username'
                                          : null,
                                      onChanged: (val) {
                                        setState(
                                            () => _currentName = val.trim());
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Email',
                                      style: kLabelStyle,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  userData.email,
                                  style: kListSubTextStyle.copyWith(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (_formKey.currentState.validate()) {
                                      UserDatabaseService(uid: userData.uid)
                                          .updateUserData(userData.uid,
                                              _currentName, userData.email);
                                      SystemChannels.textInput
                                          .invokeMethod('TextInput.hide');
                                    }
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.30,
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'UPDATE',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Loading();
                        }
                      }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
