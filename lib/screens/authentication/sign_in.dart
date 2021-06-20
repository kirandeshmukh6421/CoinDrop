import 'package:coindrop/services/database/auth.dart';
import 'package:coindrop/shared/constants.dart';
import 'package:coindrop/shared/loading.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  // User Form Inputs.
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? SafeArea(
            child: Loading(),
          )
        : SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: kMediumGrey,
              body: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Log Into',
                        style: TextStyle(
                          color: Colors.blueGrey[100],
                          fontFamily: 'OpenSans',
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      kAppLogoName,
                      SizedBox(height: 50.0),
                      Container(
                        alignment: Alignment.centerLeft,
                        decoration: kBoxStyle,
                        height: 60.0,
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
                        alignment: Alignment.centerLeft,
                        decoration: kBoxStyle,
                        height: 62.0,
                        child: TextFormField(
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'OpenSans',
                          ),
                          decoration: kTextInputDecoration.copyWith(
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.blueGrey,
                            ),
                            hintText: 'Enter your Password',
                            hintStyle: kHintStyle,
                          ),
                          validator: (val) => val.length < 6
                              ? '\t\t\tPassword should atleast be 6 characters long'
                              : null,
                          obscureText: true,
                          onChanged: (val) {
                            setState(() => password = val.trim());
                          },
                        ),
                      ),
                      SizedBox(height: 30.0),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        decoration: BoxDecoration(
                          color: Colors.blue[300],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextButton(
                            child: Text(
                              'Sign In',
                              style: TextStyle(color: kDarkGrey),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() => loading = true);
                                dynamic result =
                                    await _auth.signInWithEmailAndPassword(
                                        email, password);
                                if (result.runtimeType == String) {
                                  setState(() {
                                    loading = false;
                                    error = result;
                                  });
                                }
                              }
                            }),
                      ),
                      SizedBox(height: 12.0),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () => widget.toggleView(),
                          // padding: EdgeInsets.only(right: 0.0),
                          child: Text(
                            'Don\'t have an Account? Sign Up',
                            style: kLabelStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
