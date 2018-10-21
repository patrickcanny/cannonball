import 'package:flutter/material.dart';
import 'package:validate/validate.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:cannonball_app/models/User.dart';

class CreateUserForm extends StatefulWidget {
  @override
  CreateUserFormState createState() {
    return CreateUserFormState();
  }
}

class CreateUserFormState extends State<CreateUserForm> {
  final _formKey = GlobalKey<FormState>();
  User user = new User();

  String validateEmail(String value) {
    try {
      Validate.isEmail(value);
    } catch (e) {
      return 'Error: invalid email.';
    }
    return null;
  }

  String validateName(String value) {
    try {
      Validate.notEmpty(value);
      Validate.isAlphaNumeric(value);
    } catch (e) {
      return 'Error: invalid name.';
    }
    return null;
  }

  Future<String> submit() async {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save(); // Save our form now.

      var url = "https://cannonball-220004.appspot.com/newUser";
      Map map = {
        'name': "janes"
      };

      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(json.encode(map)));
      HttpClientResponse response = await request.close();

      String reply = await response.transform(utf8.decoder).join();
      httpClient.close();
      print(reply);
      return reply;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Create User'),
      ),
      body: new Container(
          padding: new EdgeInsets.all(20.0),
          child: new Form(
            key: this._formKey,
            child: new ListView(
              children: <Widget>[
                new TextFormField(
                    decoration: new InputDecoration(
                        labelText: 'First Name'
                    ),
                    validator: this.validateName,
                    onSaved: (String value) {
                      this.user.firstName = value;
                    }
                ),
                new TextFormField(
                    decoration: new InputDecoration(
                        labelText: 'Last Name'
                    ),
                    validator: this.validateName,
                    onSaved: (String value) {
                      this.user.lastName = value;
                    }
                ),
                new TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: new InputDecoration(
                        labelText: 'E-mail Address'
                    ),
                    validator: this.validateEmail,
                    onSaved: (String value) {
                      this.user.email = value;
                    }
                ),
                new TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: new InputDecoration(
                        labelText: 'Phone Number'
                    ),
                    onSaved: (String value) {
                      this.user.phoneNumber = value;
                    }
                ),
                new Container(
                  width: screenSize.width,
                  child: new RaisedButton(
                    child: new Text(
                      'Login',
                      style: new TextStyle(
                          color: Colors.white
                      ),
                    ),
                    onPressed: this.submit,
                    color: Colors.blue,
                  ),
                  margin: new EdgeInsets.only(
                      top: 20.0
                  ),
                )
              ],
            ),
          )
      ),
    );
  }
}