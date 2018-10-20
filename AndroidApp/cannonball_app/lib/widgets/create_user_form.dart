import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
//                  TODO: Create client with url?
                  var url = "https://cannonball-220004.appspot.com/newUser";
                  http.post(url, body: {"name": textController.text});

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