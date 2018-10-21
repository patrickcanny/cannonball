import 'package:flutter/material.dart';
import 'package:validate/validate.dart';
import 'package:cannonball_app/models/User.dart';
import 'package:cannonball_app/util/requests.dart';
import 'package:cannonball_app/screens/create_user_form.dart';

class SignInForm extends StatefulWidget {
  @override
  SignInFormState createState() {
    return SignInFormState();
  }
}

class SignInFormState extends State<SignInForm> {
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

  void submit() async {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save(); // Save our form now.

      Requests.POST(user.toJson(), "authenticateUser");
    }
  }

  void newUser() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateUserForm()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Sign In'),
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
                    color: Colors.green,
                  ),
                  margin: new EdgeInsets.only(
                      top: 20.0
                  ),
                ),
                new Container(
                  width: screenSize.width,
                  child: new RaisedButton(
                    child: new Text(
                      'Create New User',
                      style: new TextStyle(
                          color: Colors.white
                      ),
                    ),
                    onPressed: this.newUser,
                    color: Colors.green,
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
