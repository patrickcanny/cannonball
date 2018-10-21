import 'dart:async';
import 'dart:convert' show json;

import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignIn extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<FirebaseUser> _signIn() async {
    print(_auth);
    print(googleSignIn);
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    print(googleSignInAccount);
    GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    FirebaseUser user = await _auth.signInWithGoogle(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken
    );

    print("User name: ${user.displayName}");
    return user;
  }

  void _signOut() {
    googleSignIn.signOut();
    print("User signed out");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Auth Google"),
      ),
      body: new Padding(
        padding: const EdgeInsets.all(20.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new RaisedButton(
              onPressed: ()=> _signIn()
                .then((FirebaseUser user) => print(user))
                .catchError((e) => print(e)),
              child: new Text("Sign In"),
              color: Colors.green,
            ),
            new Padding(padding: const EdgeInsets.all(10.0)),
            new RaisedButton(
              onPressed: _signOut,
              child: new Text("Sign Out"),
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}