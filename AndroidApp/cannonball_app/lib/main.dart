import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(UserCreate());

class CreateUserForm extends StatefulWidget {
  @override
  CreateUserFormState createState() {
    return CreateUserFormState();
  }
}

class CreateUserFormState extends State<CreateUserForm> {
  final _formKey = GlobalKey<FormState>();
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: textController,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                  var url = "https://cannonball-220004.appspot.com/newUser?name=" + textController.text;
                  http.get(url);
                  return showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        // Retrieve the text the user has typed in using our
                        // TextEditingController
                        content: Text(textController.text),
                      );
                    },
                  );
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}

class UserCreate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    var url = "https://cannonball-220004.appspot.com/newUser";
//    http.post(url, body: {"name": "doodle"})
//        .then((response) {
//          print("Response status: ${response.statusCode}");
//          print("Response body: ${response.body}");
//        });
//    print("testing lol");
    return MaterialApp(
        title: 'Create New User',
        home: Scaffold(
          appBar: AppBar(
            title: Text('Create User'),
          ),
          body: Center(
            child: CreateUserForm(),
          ),
        )
    );
  }
}
