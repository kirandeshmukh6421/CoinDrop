import 'package:coindrop/services/database/auth.dart';
import 'package:coindrop/shared/constants.dart';
import 'package:coindrop/shared/loading.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  bool loading = false;
  String error = '';
  @override
  Widget build(BuildContext context) {
    return loading
        ? SafeArea(
            child: Loading(),
          )
        : SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.grey[900],
              body: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.blueGrey[100],
                          fontFamily: 'OpenSans',
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        alignment: Alignment.centerLeft,
                        decoration: kBoxStyle,
                        height: 62.0,
                        child: TextFormField(
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'OpenSans',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          decoration: kTextInputDecoration.copyWith(
                            hintText: 'Enter your Email',
                            hintStyle: kHintStyle,
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.blueGrey,
                            ),
                          ),
                          validator: (val) =>
                              val.isEmpty ? '\t\t\tEnter an email' : null,
                          onChanged: (val) {
                            setState(() => email = val.trim());
                          },
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          decoration: BoxDecoration(
                            color: Colors.blue[300],
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextButton(
                              child: Text(
                                'Send Email',
                                style: TextStyle(color: kDarkGrey),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  await _auth.resetPassword(email);
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: Duration(
                                      milliseconds: 1500,
                                    ),
                                    backgroundColor: Colors.blue,
                                    content: Text(
                                      "An Email has been sent to reset Password",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'OpenSans',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                );
                                Navigator.pop(context);
                              })),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
